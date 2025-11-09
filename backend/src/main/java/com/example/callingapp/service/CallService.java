package com.example.callingapp.service;

import com.example.callingapp.domain.Cdr;
import com.example.callingapp.domain.CallSession;
import com.example.callingapp.domain.Rate;
import com.example.callingapp.domain.WalletEntry;
import com.example.callingapp.repository.CallSessionRepository;
import com.example.callingapp.repository.CdrRepository;
import com.example.callingapp.repository.SpendLimitRepository;
import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Service
public class CallService {

    private static final Logger log = LoggerFactory.getLogger(CallService.class);
    private static final Duration DEFAULT_RESERVATION_DURATION = Duration.ofMinutes(3);

    private final RateService rateService;
    private final CallRatingService callRatingService;
    private final CallSessionRepository callSessionRepository;
    private final CdrRepository cdrRepository;
    private final WalletService walletService;
    private final RealtimeEventPublisher eventPublisher;
    private final SpendLimitRepository spendLimitRepository;
    private final Clock clock;

    public CallService(
            RateService rateService,
            CallRatingService callRatingService,
            CallSessionRepository callSessionRepository,
            CdrRepository cdrRepository,
            WalletService walletService,
            RealtimeEventPublisher eventPublisher,
            SpendLimitRepository spendLimitRepository,
            Clock clock) {
        this.rateService = rateService;
        this.callRatingService = callRatingService;
        this.callSessionRepository = callSessionRepository;
        this.cdrRepository = cdrRepository;
        this.walletService = walletService;
        this.eventPublisher = eventPublisher;
        this.spendLimitRepository = spendLimitRepository;
        this.clock = clock;
    }

    public Mono<OutboundCallAuthorization> initiateOutboundCall(String userId, String from, String to) {
        Instant now = clock.instant();
        return rateService.findBestRateForDestination(to, now)
                .switchIfEmpty(Mono.error(new IllegalArgumentException("No rate found for destination")))
                .flatMap(rate -> authorize(userId, from, to, rate, DEFAULT_RESERVATION_DURATION));
    }

    private Mono<OutboundCallAuthorization> authorize(String userId, String from, String to, Rate rate, Duration reservationDuration) {
        CallRatingService.CallAuthorizationResult authorization = callRatingService.authorize(rate, to, reservationDuration);
        String reservationReference = "CALL_RESERVE:" + UUID.randomUUID();
        return ensureSpendLimits(userId, authorization.estimatedCostCents())
                .then(walletService.hasSufficientBalance(userId, authorization.estimatedCostCents())
                        .filter(Boolean::booleanValue)
                        .switchIfEmpty(Mono.error(new IllegalArgumentException("Insufficient balance"))))
                .then(walletService.debit(userId, authorization.estimatedCostCents(), reservationReference))
                .flatMap(entry -> createCallSession(userId, from, to, rate, authorization, entry, reservationReference));
    }

    private Mono<Void> ensureSpendLimits(String userId, long estimatedCostCents) {
        return spendLimitRepository.findByUserId(userId)
                .flatMap(limit -> {
                    if (limit.perCallCapCents() > 0 && estimatedCostCents > limit.perCallCapCents()) {
                        return Mono.error(new IllegalArgumentException("Per-call spend cap exceeded"));
                    }
                    if (limit.dailyCapCents() > 0 && estimatedCostCents > limit.dailyCapCents()) {
                        return Mono.error(new IllegalArgumentException("Daily spend cap exceeded"));
                    }
                    return Mono.empty();
                })
                .switchIfEmpty(Mono.empty());
    }

    private Mono<OutboundCallAuthorization> createCallSession(
            String userId,
            String from,
            String to,
            Rate rate,
            CallRatingService.CallAuthorizationResult authorization,
            WalletEntry reserveEntry,
            String reservationReference) {

        Instant now = clock.instant();
        CallSession session = new CallSession(
                UUID.randomUUID().toString(),
                userId,
                CallSession.Direction.OUTBOUND,
                from,
                to,
                "RESERVED",
                now,
                now.plus(Duration.ofHours(1)),
                null,
                rate.currency(),
                authorization.estimatedCostCents());

        return callSessionRepository.save(session)
                .doOnSuccess(saved -> log.info("Call session {} reserved {} cents", saved.id(), authorization.estimatedCostCents()))
                .map(saved -> new OutboundCallAuthorization(
                        saved.id(),
                        to,
                        authorization.estimatedCostCents(),
                        rate.currency(),
                        rate.ratePerMinuteCents(),
                        reservationReference));
    }

    public Mono<Cdr> finalizeCall(String callSessionId, long billSeconds, String status, String trunk, String recordingUrl) {
        return callSessionRepository.findById(callSessionId)
                .switchIfEmpty(Mono.error(new IllegalArgumentException("Call session not found")))
                .flatMap(session -> applyRating(session, billSeconds, status, trunk, recordingUrl));
    }

    public Mono<Cdr> finalizeBySipId(String sipCallId, long billSeconds, String status, String trunk, String recordingUrl) {
        return callSessionRepository.findBySipCallId(sipCallId)
                .switchIfEmpty(Mono.error(new IllegalArgumentException("Call session not found by SIP id")))
                .flatMap(session -> applyRating(session, billSeconds, status, trunk, recordingUrl));
    }

    private Mono<Cdr> applyRating(CallSession session, long billSeconds, String status, String trunk, String recordingUrl) {
        Instant now = clock.instant();
        return rateService.findBestRateForDestination(session.to(), now)
                .switchIfEmpty(Mono.error(new IllegalArgumentException("No rate found for session rating")))
                .flatMap(rate -> {
                    long actualCost = callRatingService.costCents(rate, billSeconds);
                    long delta = session.reservedCents() - actualCost;
                    Mono<Void> walletAdjustment;
                    if (delta > 0) {
                        walletAdjustment = walletService.credit(session.userId(), delta, "CALL_RELEASE", WalletEntry.EntryType.ADJUST).then();
                    } else if (delta < 0) {
                        walletAdjustment = walletService.debit(session.userId(), Math.abs(delta), "CALL_OVERRUN").then();
                    } else {
                        walletAdjustment = Mono.empty();
                    }

                    Cdr cdr = new Cdr(
                            UUID.randomUUID().toString(),
                            session.userId(),
                            session.direction().name(),
                            session.from(),
                            session.to(),
                            session.createdAt(),
                            session.createdAt().plusSeconds(Math.max(0, billSeconds - 60)),
                            now,
                            billSeconds,
                            actualCost,
                            trunk,
                            status,
                            recordingUrl,
                            null);

                    return walletAdjustment.then(
                            cdrRepository.save(cdr)
                                    .doOnSuccess(saved -> log.info("CDR {} written for session {}", saved.id(), session.id()))
                                    .flatMap(saved -> callSessionRepository.deleteById(session.id())
                                            .thenReturn(saved))
                                    .doOnSuccess(saved -> eventPublisher.publishCallState(
                                            new RealtimeEventPublisher.CallStateEvent(session.userId(), session.id(), status, now))))
                            ;
                });
    }

    public Mono<Void> attachSipCallId(String sessionId, String sipCallId) {
        return callSessionRepository.findById(sessionId)
                .switchIfEmpty(Mono.error(new IllegalArgumentException("Call session not found")))
                .flatMap(session -> callSessionRepository.save(new CallSession(
                        session.id(),
                        session.userId(),
                        session.direction(),
                        session.from(),
                        session.to(),
                        "IN_PROGRESS",
                        session.createdAt(),
                        session.expiresAt(),
                        sipCallId,
                        session.trunk(),
                        session.reservedCents())))
                .then();
    }

    public record OutboundCallAuthorization(
            String callSessionId,
            String dialString,
            long reservedCents,
            String currency,
            long ratePerMinuteCents,
            String reservationReference) {
    }
}
