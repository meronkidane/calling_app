package com.example.callingapp.repository;

import com.example.callingapp.domain.WalletEntry;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import reactor.core.publisher.Flux;

public interface WalletEntryRepository extends ReactiveMongoRepository<WalletEntry, String> {

    Flux<WalletEntry> findByUserIdOrderByCreatedAtDesc(String userId);
}
