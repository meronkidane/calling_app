package com.example.callingapp.config;

import jakarta.validation.constraints.NotBlank;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.bind.DefaultValue;
import org.springframework.validation.annotation.Validated;

@ConfigurationProperties(prefix = "app.auth")
@Validated
public record AuthProperties(
        @DefaultValue("false") boolean sandbox,
        @DefaultValue("000000") String sandboxMasterOtp,
        @DefaultValue("US") @NotBlank String defaultRegion) {
}
