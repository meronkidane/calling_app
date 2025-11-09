package com.example.callingapp.service;

import java.time.Instant;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.rsocket.RSocketRequester;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Sinks;

@Service
public class RealtimeEventPublisher implements WalletService.WalletEventPublisher {

    private static final Logger log = LoggerFactory.getLogger(RealtimeEventPublisher.class);

    private final Sinks.Many<Event> sink = Sinks.many().multicast().directBestEffort();

    @Override
    public void publishBalanceChanged(String userId, long balanceCents) {
        emit(new BalanceChangedEvent(userId, balanceCents, Instant.now()));
    }

    public void publishCallState(CallStateEvent event) {
        emit(event);
    }

    public Flux<Event> streamEvents() {
        return sink.asFlux();
    }

    private void emit(Event event) {
        Sinks.EmitResult result = sink.tryEmitNext(event);
        if (result.isFailure()) {
            log.warn("Failed to emit realtime event {} because {}", event, result);
        }
    }

    public interface Event {
        String type();

        String userId();
    }

    public record BalanceChangedEvent(String userId, long balanceCents, Instant at) implements Event {
        @Override
        public String type() {
            return "BALANCE_CHANGED";
        }
    }

    public record CallStateEvent(String userId, String callId, String state, Instant at) implements Event {
        @Override
        public String type() {
            return "CALL_STATE";
        }
    }

    @Controller
    public static class RealtimeEventController {

        private final RealtimeEventPublisher publisher;

        public RealtimeEventController(RealtimeEventPublisher publisher) {
            this.publisher = publisher;
        }

        @MessageMapping("events.stream")
        public Flux<Event> stream(RSocketRequester requester) {
            return publisher.streamEvents();
        }
    }
}
