package com.example.callingapp.domain;

import java.time.Instant;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

@Document("otp_tokens")
public record OtpToken(
        @Id String id,
        @Indexed(unique = true) String phoneE164,
        String code,
        Instant expiresAt,
        int attempts) {
}
