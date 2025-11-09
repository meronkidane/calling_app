package com.example.callingapp.domain;

import java.time.Instant;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

@Document("wallets")
public record Wallet(
        @Id String id,
        @Indexed String userId,
        long balanceCents,
        Instant updatedAt,
        Instant createdAt) {
}
