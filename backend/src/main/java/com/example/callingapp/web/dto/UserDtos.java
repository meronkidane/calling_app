package com.example.callingapp.web.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public final class UserDtos {

    private UserDtos() {
    }

    public record UserResponse(String id, String phoneE164, String timezone, String locale, String kycStatus) {
    }

    public record UpdateUserRequest(
            @Pattern(regexp = "^[A-Za-z_/-]+$", message = "Invalid timezone format")
            String timezone,
            @Pattern(regexp = "^[a-z]{2}(-[A-Z]{2})?$", message = "Invalid locale format")
            String locale) {
    }

    public record SpendLimitResponse(long dailyCapCents, long perCallCapCents) {
    }
}
