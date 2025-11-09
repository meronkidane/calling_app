package com.example.callingapp.domain;

import java.time.Instant;
import java.util.List;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

@Document("users")
public record User(
        @Id String id,
        @Indexed(unique = true) String phoneE164,
        @Indexed(unique = true) String email,
        List<String> roles,
        String kycStatus,
        Instant createdAt,
        Instant updatedAt,
        String timezone,
        String locale) {
}
