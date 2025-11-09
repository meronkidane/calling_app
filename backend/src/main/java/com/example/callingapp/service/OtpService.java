package com.example.callingapp.service;

import com.example.callingapp.config.AuthProperties;
import com.example.callingapp.domain.OtpToken;
import com.example.callingapp.repository.OtpTokenRepository;
import java.security.SecureRandom;
import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.util.Locale;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Service
public class OtpService {

    private static final Logger log = LoggerFactory.getLogger(OtpService.class);
    private static final Duration OTP_TTL = Duration.ofMinutes(5);
    private static final int MAX_ATTEMPTS = 5;

    private final SecureRandom random = new SecureRandom();
    private final AuthProperties authProperties;
    private final OtpTokenRepository otpTokenRepository;
    private final Clock clock;

    public OtpService(AuthProperties authProperties, OtpTokenRepository otpTokenRepository, Clock clock) {
        this.authProperties = authProperties;
        this.otpTokenRepository = otpTokenRepository;
        this.clock = clock;
    }

    public Mono<String> issueOtp(String phoneE164) {
        String code = authProperties.sandbox()
                ? authProperties.sandboxMasterOtp()
                : generateCode();
        Instant expiresAt = clock.instant().plus(OTP_TTL);
        return otpTokenRepository.findByPhoneE164(phoneE164)
                .defaultIfEmpty(new OtpToken(UUID.randomUUID().toString(), phoneE164, code, expiresAt, 0))
                .flatMap(existing -> otpTokenRepository.save(new OtpToken(
                        existing.id() == null ? UUID.randomUUID().toString() : existing.id(),
                        phoneE164,
                        code,
                        expiresAt,
                        0)))
                .doOnSuccess(token -> log.info("OTP issued for {}", phoneE164))
                .thenReturn(code);
    }

    public Mono<OtpVerificationResult> verifyOtp(String phoneE164, String submittedCode) {
        String sanitized = submittedCode.trim().toUpperCase(Locale.ROOT);
        return otpTokenRepository.findByPhoneE164(phoneE164)
                .switchIfEmpty(Mono.error(new IllegalArgumentException("OTP not found")))
                .flatMap(token -> {
                    if (token.expiresAt().isBefore(clock.instant())) {
                        return otpTokenRepository.delete(token)
                                .then(Mono.error(new IllegalArgumentException("OTP expired")));
                    }

                    String expectedCode = authProperties.sandbox() ? authProperties.sandboxMasterOtp() : token.code();
                    if (!expectedCode.equalsIgnoreCase(sanitized)) {
                        if (token.attempts() + 1 >= MAX_ATTEMPTS) {
                            return otpTokenRepository.delete(token)
                                    .then(Mono.error(new IllegalArgumentException("OTP attempts exceeded")));
                        }
                        return otpTokenRepository.save(new OtpToken(token.id(), token.phoneE164(), token.code(), token.expiresAt(), token.attempts() + 1))
                                .then(Mono.error(new IllegalArgumentException("Invalid OTP")));
                    }

                    return otpTokenRepository.delete(token)
                            .thenReturn(new OtpVerificationResult(true));
                });
    }

    @Scheduled(fixedDelayString = "PT5M")
    public void purgeExpiredOtps() {
        Instant now = clock.instant();
        otpTokenRepository.deleteByExpiresAtBefore(now).subscribe(count -> {
            if (count > 0) {
                log.info("Purged {} expired OTP tokens", count);
            }
        }, error -> log.warn("Failed to purge expired OTP tokens: {}", error.getMessage()));
    }

    private String generateCode() {
        return "%06d".formatted(random.nextInt(1_000_000));
    }

    public record OtpVerificationResult(boolean success) {
    }
}
