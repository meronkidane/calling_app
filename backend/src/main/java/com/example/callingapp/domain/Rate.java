package com.example.callingapp.domain;

import java.time.Instant;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

@Document("rates")
@CompoundIndex(name = "rate_prefix_effective_idx", def = "{'prefix': 1, 'effectiveFrom': -1}")
public record Rate(
        @Id String id,
        @Indexed String countryIso,
        @Indexed String prefix,
        long ratePerMinuteCents,
        String currency,
        Instant effectiveFrom,
        Instant effectiveTo,
        boolean peak) {
}
