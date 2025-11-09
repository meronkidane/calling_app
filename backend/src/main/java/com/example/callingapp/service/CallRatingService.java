package com.example.callingapp.service;

import com.example.callingapp.domain.Rate;
import java.time.Duration;
import java.time.Instant;
import org.springframework.stereotype.Service;

@Service
public class CallRatingService {

    public long estimateCostCents(Rate rate, Duration duration) {
        long seconds = duration.toSeconds();
        return costCents(rate, seconds);
    }

    public long costCents(Rate rate, long billableSeconds) {
        if (rate == null) {
            throw new IllegalArgumentException("Rate is required");
        }
        if (billableSeconds <= 0) {
            return 0L;
        }
        long perMinute = rate.ratePerMinuteCents();
        return Math.floorDiv(perMinute * billableSeconds + 59, 60);
    }

    public CallAuthorizationResult authorize(Rate rate, String to, Duration maxDuration) {
        long estimatedCost = estimateCostCents(rate, maxDuration);
        return new CallAuthorizationResult(rate, to, maxDuration, estimatedCost);
    }

    public record CallAuthorizationResult(Rate rate, String dialString, Duration maxDuration, long estimatedCostCents) {
    }
}
