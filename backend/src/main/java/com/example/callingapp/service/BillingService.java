package com.example.callingapp.service;

import com.example.callingapp.config.StripeProperties;
import com.example.callingapp.domain.WalletEntry;
import com.stripe.Stripe;
import com.stripe.exception.SignatureVerificationException;
import com.stripe.model.Event;
import com.stripe.model.PaymentIntent;
import com.stripe.net.Webhook;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;
import reactor.core.scheduler.Schedulers;

@Service
public class BillingService {

    private static final Logger log = LoggerFactory.getLogger(BillingService.class);

    private final StripeProperties stripeProperties;
    private final WalletService walletService;

    public BillingService(StripeProperties stripeProperties, WalletService walletService) {
        this.stripeProperties = stripeProperties;
        this.walletService = walletService;
        Stripe.apiKey = stripeProperties.secretKey();
    }

    public Mono<String> createTopupIntent(String userId, long amountCents) {
        return Mono.fromCallable(() -> {
                    Map<String, Object> params = Map.of(
                            "amount", amountCents,
                            "currency", stripeProperties.currency(),
                            "metadata", Map.of("userId", userId)
                    );
                    return PaymentIntent.create(params);
                })
                .subscribeOn(Schedulers.boundedElastic())
                .map(PaymentIntent::getClientSecret);
    }

    public Mono<Void> handleStripeWebhook(String payload, String signature) {
        return Mono.fromCallable(() -> Webhook.constructEvent(payload, signature, stripeProperties.webhookSecret()))
                .subscribeOn(Schedulers.boundedElastic())
                .flatMap(this::processEvent)
                .onErrorResume(SignatureVerificationException.class, ex -> {
                    log.error("Stripe signature verification failed: {}", ex.getMessage());
                    return Mono.error(new IllegalArgumentException("Invalid Stripe signature"));
                });
    }

    private Mono<Void> processEvent(Event event) {
        if ("payment_intent.succeeded".equals(event.getType())) {
            PaymentIntent intent = (PaymentIntent) event.getDataObjectDeserializer()
                    .getObject()
                    .orElseThrow(() -> new IllegalArgumentException("Unable to deserialize payment intent"));
            String userId = intent.getMetadata().get("userId");
            long amount = intent.getAmountReceived();
            return walletService.credit(userId, amount, intent.getId(), WalletEntry.EntryType.TOPUP).then();
        }

        log.debug("Ignoring Stripe event {}", event.getType());
        return Mono.empty();
    }
}
