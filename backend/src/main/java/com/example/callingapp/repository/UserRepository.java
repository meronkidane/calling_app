package com.example.callingapp.repository;

import com.example.callingapp.domain.User;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import reactor.core.publisher.Mono;

public interface UserRepository extends ReactiveMongoRepository<User, String> {

    Mono<User> findByPhoneE164(String phoneE164);

    Mono<User> findByEmail(String email);
}
