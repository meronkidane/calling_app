package com.example.callingapp.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.rsocket.RSocketStrategies;
import org.springframework.messaging.rsocket.annotation.support.RSocketMessageHandler;
import org.springframework.web.util.pattern.PathPatternRouteMatcher;

@Configuration
public class RSocketConfig {

    @Bean
    public RSocketStrategies rSocketStrategies() {
        return RSocketStrategies.builder()
                .routeMatcher(new PathPatternRouteMatcher())
                .build();
    }

    @Bean
    public RSocketMessageHandler rSocketMessageHandler(RSocketStrategies strategies) {
        RSocketMessageHandler handler = new RSocketMessageHandler();
        handler.setRSocketStrategies(strategies);
        return handler;
    }
}
