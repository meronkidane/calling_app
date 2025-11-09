package com.example.callingapp.web.dto;

import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.time.Instant;

public final class RateDtos {

    private RateDtos() {
    }

    public record RateResponse(
            String id,
            String countryIso,
            String prefix,
            long ratePerMinuteCents,
            String currency,
            Instant effectiveFrom,
            Instant effectiveTo,
            boolean peak) {
    }

    public record CreateRateRequest(
            @NotBlank String countryIso,
            @NotBlank String prefix,
            @Positive long ratePerMinuteCents,
            @NotBlank String currency,
            @NotNull Instant effectiveFrom,
            Instant effectiveTo,
            boolean peak) {
    }
}
