package com.example.callingapp.web;

import com.example.callingapp.service.BillingService;
import com.example.callingapp.service.TelnyxWebhookService;
import java.util.Map;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping(path = "/webhooks", produces = MediaType.APPLICATION_JSON_VALUE)
public class WebhookController {

    private final BillingService billingService;
    private final TelnyxWebhookService telnyxWebhookService;

    public WebhookController(BillingService billingService, TelnyxWebhookService telnyxWebhookService) {
        this.billingService = billingService;
        this.telnyxWebhookService = telnyxWebhookService;
    }

    @PostMapping(value = "/stripe", consumes = MediaType.APPLICATION_JSON_VALUE)
    public Mono<ResponseEntity<Void>> stripe(
            @RequestBody String payload,
            @RequestHeader("Stripe-Signature") String signature) {
        return billingService.handleStripeWebhook(payload, signature)
                .thenReturn(ResponseEntity.ok().build());
    }

    @PostMapping(value = "/voice", consumes = MediaType.APPLICATION_JSON_VALUE)
    public Mono<ResponseEntity<Void>> telnyx(@RequestBody Map<String, Object> payload) {
        return telnyxWebhookService.handleVoiceWebhook(payload)
                .thenReturn(ResponseEntity.ok().build());
    }
}
