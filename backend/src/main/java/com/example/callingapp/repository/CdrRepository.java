package com.example.callingapp.repository;

import com.example.callingapp.domain.Cdr;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import reactor.core.publisher.Flux;

public interface CdrRepository extends ReactiveMongoRepository<Cdr, String> {

    Flux<Cdr> findByUserIdOrderByStartTsDesc(String userId);
}
