package com.example.callingapp.domain;

import java.time.Instant;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

@Document("cdrs")
@CompoundIndex(name = "cdr_user_start_idx", def = "{'userId': 1, 'startTs': -1}")
public record Cdr(
        @Id String id,
        @Indexed String userId,
        String direction,
        String from,
        String to,
        Instant startTs,
        Instant answerTs,
        Instant endTs,
        long billSeconds,
        long costCents,
        String trunk,
        String status,
        String recordingUrl,
        org.bson.Document rawEvent) {
}
