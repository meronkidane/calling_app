package com.example.callingapp.repository;

import com.example.callingapp.domain.CallSession;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

public interface CallSessionRepository extends ReactiveMongoRepository<CallSession, String> {

    Flux<CallSession> findByUserIdOrderByCreatedAtDesc(String userId);

    Mono<CallSession> findBySipCallId(String sipCallId);
}
