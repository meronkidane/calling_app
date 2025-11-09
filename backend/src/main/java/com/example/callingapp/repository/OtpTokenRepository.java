package com.example.callingapp.repository;

import com.example.callingapp.domain.OtpToken;
import java.time.Instant;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import reactor.core.publisher.Mono;

public interface OtpTokenRepository extends ReactiveMongoRepository<OtpToken, String> {

    Mono<OtpToken> findByPhoneE164(String phoneE164);

    Mono<Long> deleteByExpiresAtBefore(Instant instant);
}
