package com.example.callingapp.repository;

import com.example.callingapp.domain.Rate;
import org.springframework.data.mongodb.repository.ReactiveMongoRepository;
import reactor.core.publisher.Flux;

public interface RateRepository extends ReactiveMongoRepository<Rate, String> {

    Flux<Rate> findByCountryIsoOrderByEffectiveFromDesc(String countryIso);

    Flux<Rate> findByPrefixStartingWithOrderByEffectiveFromDesc(String prefix);

    Flux<Rate> findByPrefixOrderByEffectiveFromDesc(String prefix);
}
