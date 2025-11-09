package com.example.callingapp.config;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.Duration;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.bind.DefaultValue;
import org.springframework.validation.annotation.Validated;

@ConfigurationProperties(prefix = "app.jwt")
@Validated
public record JwtProperties(
        @NotBlank String secret,
        @NotBlank @DefaultValue("international-calling-app") String issuer,
        @NotNull @DefaultValue("PT15M") Duration accessTokenTtl,
        @NotNull @DefaultValue("P30D") Duration refreshTokenTtl) {
}
