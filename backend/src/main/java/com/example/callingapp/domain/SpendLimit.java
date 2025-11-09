package com.example.callingapp.domain;

import java.time.Instant;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

@Document("spend_limits")
public record SpendLimit(
        @Id String id,
        @Indexed(unique = true) String userId,
        long dailyCapCents,
        long perCallCapCents,
        Instant lastReset) {
}
