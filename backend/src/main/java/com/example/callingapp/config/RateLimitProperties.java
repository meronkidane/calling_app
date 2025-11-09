package com.example.callingapp.config;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import java.time.Duration;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.bind.DefaultValue;
import org.springframework.validation.annotation.Validated;

@ConfigurationProperties(prefix = "app.ratelimit")
@Validated
public record RateLimitProperties(
        @NotNull @DefaultValue("PT1M") Duration ipWindow,
        @Min(1) @DefaultValue("60") long ipCapacity,
        @NotNull @DefaultValue("PT1M") Duration userWindow,
        @Min(1) @DefaultValue("120") long userCapacity) {
}
