package com.example.callingapp.repository;

import com.example.callingapp.domain.SpendLimit;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import reactor.core.publisher.Mono;

public interface SpendLimitRepository extends ReactiveMongoRepository<SpendLimit, String> {

    Mono<SpendLimit> findByUserId(String userId);
}
