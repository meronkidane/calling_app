package com.example.callingapp.service;

import com.example.callingapp.domain.Rate;
import com.example.callingapp.repository.RateRepository;
import java.time.Instant;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Service
public class RateService {

    private final RateRepository rateRepository;

    public RateService(RateRepository rateRepository) {
        this.rateRepository = rateRepository;
    }

    public Flux<Rate> findByCountry(String countryIso) {
        return rateRepository.findByCountryIsoOrderByEffectiveFromDesc(countryIso);
    }

    public Mono<Rate> findBestRateForDestination(String destination, Instant at) {
        return Flux.fromIterable(generatePrefixes(destination))
                .concatMap(prefix -> rateRepository.findByPrefixOrderByEffectiveFromDesc(prefix)
                        .filter(rate -> isEffective(rate, at))
                        .next())
                .next();
    }

    public Flux<Rate> searchByPrefix(String prefix) {
        return rateRepository.findByPrefixStartingWithOrderByEffectiveFromDesc(prefix);
    }

    public Mono<Rate> createRate(Rate rate) {
        return rateRepository.save(rate);
    }

    public Mono<Rate> updateRate(String id, Rate updated) {
        return rateRepository.findById(id)
                .switchIfEmpty(Mono.error(new IllegalArgumentException("Rate not found")))
                .flatMap(existing -> rateRepository.save(new Rate(
                        existing.id(),
                        updated.countryIso(),
                        updated.prefix(),
                        updated.ratePerMinuteCents(),
                        updated.currency(),
                        updated.effectiveFrom(),
                        updated.effectiveTo(),
                        updated.peak()
                )));
    }

    private boolean isEffective(Rate rate, Instant at) {
        boolean starts = rate.effectiveFrom().isBefore(at) || rate.effectiveFrom().equals(at);
        boolean notExpired = rate.effectiveTo() == null || rate.effectiveTo().isAfter(at);
        return starts && notExpired;
    }

    private Iterable<String> generatePrefixes(String destination) {
        String normalized = destination.replaceAll("[^0-9+]", "");
        int length = normalized.length();
        java.util.List<String> prefixes = new java.util.ArrayList<>();
        for (int i = length; i > 0; i--) {
            prefixes.add(normalized.substring(0, i));
        }
        return prefixes;
    }
}
