package com.example.callingapp.web.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public final class AuthDtos {

    private AuthDtos() {
    }

    public record RequestOtpRequest(
            @NotBlank @Pattern(regexp = "^[+0-9\\s()-]{6,20}$") String phone) {
    }

    public record VerifyOtpRequest(
            @NotBlank String phone,
            @NotBlank String code) {
    }

    public record RefreshRequest(@NotBlank String refreshToken) {
    }

    public record TokenResponse(String accessToken, String refreshToken) {
    }

    public record AuthenticatedUser(String id, String phoneE164, String kycStatus, java.util.List<String> roles) {
    }

    public record AuthResponse(TokenResponse tokens, AuthenticatedUser user) {
    }
}
