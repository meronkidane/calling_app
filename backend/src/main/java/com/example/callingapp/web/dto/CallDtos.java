package com.example.callingapp.web.dto;

import jakarta.validation.constraints.NotBlank;
import java.time.Instant;

public final class CallDtos {

    private CallDtos() {
    }

    public record InitiateCallRequest(@NotBlank String to) {
    }

    public record InitiateCallResponse(
            String callSessionId,
            String dialString,
            long reservedCents,
            String currency,
            long ratePerMinuteCents) {
    }

    public record CallHistoryResponse(
            String id,
            String direction,
            String from,
            String to,
            Instant startTs,
            Instant endTs,
            long costCents,
            String status) {
    }
}
