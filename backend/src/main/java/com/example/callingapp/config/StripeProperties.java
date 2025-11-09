package com.example.callingapp.config;

import jakarta.validation.constraints.NotBlank;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.bind.DefaultValue;
import org.springframework.validation.annotation.Validated;

@ConfigurationProperties(prefix = "app.stripe")
@Validated
public record StripeProperties(
        @NotBlank String secretKey,
        @NotBlank String webhookSecret,
        @NotBlank @DefaultValue("usd") String currency) {
}
