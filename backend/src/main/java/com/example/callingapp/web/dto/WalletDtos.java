package com.example.callingapp.web.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import java.time.Instant;

public final class WalletDtos {

    private WalletDtos() {
    }

    public record WalletResponse(long balanceCents, Instant updatedAt) {
    }

    public record WalletEntryResponse(
            String id,
            String type,
            long amountCents,
            String reference,
            Instant createdAt) {
    }

    public record TopupIntentRequest(@Min(100) long amountCents) {
    }

    public record TopupIntentResponse(String clientSecret) {
    }
}
