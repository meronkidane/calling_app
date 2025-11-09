package com.example.callingapp.web;

import com.example.callingapp.domain.Rate;
import com.example.callingapp.service.RateService;
import com.example.callingapp.web.dto.RateDtos;
import jakarta.validation.Valid;
import org.springframework.http.MediaType;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping(path = "/rates", produces = MediaType.APPLICATION_JSON_VALUE)
public class RateController {

    private final RateService rateService;

    public RateController(RateService rateService) {
        this.rateService = rateService;
    }

    @GetMapping
    public Flux<RateDtos.RateResponse> byCountry(@RequestParam("country") String countryIso) {
        return rateService.findByCountry(countryIso)
                .map(this::toDto);
    }

    @GetMapping("/search")
    public Flux<RateDtos.RateResponse> searchByPrefix(@RequestParam("prefix") String prefix) {
        return rateService.searchByPrefix(prefix)
                .map(this::toDto);
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public Mono<RateDtos.RateResponse> createRate(@Valid @RequestBody RateDtos.CreateRateRequest request) {
        return rateService.createRate(toDomain(request))
                .map(this::toDto);
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public Mono<RateDtos.RateResponse> updateRate(
            @PathVariable String id,
            @Valid @RequestBody RateDtos.CreateRateRequest request) {
        return rateService.updateRate(id, toDomain(request))
                .map(this::toDto);
    }

    private Rate toDomain(RateDtos.CreateRateRequest request) {
        return new Rate(
                null,
                request.countryIso(),
                request.prefix(),
                request.ratePerMinuteCents(),
                request.currency(),
                request.effectiveFrom(),
                request.effectiveTo(),
                request.peak());
    }

    private RateDtos.RateResponse toDto(Rate rate) {
        return new RateDtos.RateResponse(
                rate.id(),
                rate.countryIso(),
                rate.prefix(),
                rate.ratePerMinuteCents(),
                rate.currency(),
                rate.effectiveFrom(),
                rate.effectiveTo(),
                rate.peak());
    }
}
