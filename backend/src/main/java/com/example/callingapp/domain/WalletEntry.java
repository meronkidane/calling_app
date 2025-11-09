package com.example.callingapp.domain;

import java.time.Instant;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

@Document("wallet_entries")
@CompoundIndex(name = "wallet_entry_user_ts_idx", def = "{'userId': 1, 'createdAt': -1}")
public record WalletEntry(
        @Id String id,
        @Indexed String userId,
        EntryType type,
        long amountCents,
        String reference,
        Instant createdAt,
        String metadata) {

    public enum EntryType {
        TOPUP,
        DEBIT,
        ADJUST
    }
}
