package com.example.callingapp.domain;

import java.time.Instant;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

@Document("call_sessions")
@CompoundIndex(name = "call_session_user_created_idx", def = "{'userId': 1, 'createdAt': -1}")
public record CallSession(
        @Id String id,
        @Indexed String userId,
        Direction direction,
        String from,
        String to,
        String status,
        Instant createdAt,
        @Indexed(expireAfterSeconds = 3600) Instant expiresAt,
        String sipCallId,
        String trunk,
        long reservedCents) {

    public enum Direction {
        INBOUND,
        OUTBOUND
    }
}
