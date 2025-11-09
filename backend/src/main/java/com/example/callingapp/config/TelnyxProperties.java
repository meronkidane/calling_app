package com.example.callingapp.config;

import jakarta.validation.constraints.NotBlank;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.bind.DefaultValue;
import org.springframework.validation.annotation.Validated;

@ConfigurationProperties(prefix = "app.telnyx")
@Validated
public record TelnyxProperties(
        @NotBlank String apiKey,
        @NotBlank String sipDomain,
        @NotBlank @DefaultValue("default-trunk") String defaultTrunkAlias) {
}
