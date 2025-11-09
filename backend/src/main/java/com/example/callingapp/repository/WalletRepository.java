package com.example.callingapp.repository;

import com.example.callingapp.domain.Wallet;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import reactor.core.publisher.Mono;

public interface WalletRepository extends ReactiveMongoRepository<Wallet, String> {

    Mono<Wallet> findByUserId(String userId);
}
