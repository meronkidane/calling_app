package com.example.callingapp.service;

import static org.assertj.core.api.Assertions.assertThat;

import com.example.callingapp.domain.Rate;
import java.time.Instant;
import org.junit.jupiter.api.Test;

class CallRatingServiceTest {

    private final CallRatingService service = new CallRatingService();

    @Test
    void costCentsRoundsUpToNextMinute() {
        Rate rate = new Rate("rate-1", "US", "+1", 100, "usd", Instant.now(), null, false);
        assertThat(service.costCents(rate, 30)).isEqualTo(50);
        assertThat(service.costCents(rate, 60)).isEqualTo(100);
        assertThat(service.costCents(rate, 61)).isEqualTo(102);
    }
}
