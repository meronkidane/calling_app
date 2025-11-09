package com.example.callingapp.service;

import java.time.Duration;
import java.time.Instant;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Service
public class TelnyxWebhookService {

    private static final Logger log = LoggerFactory.getLogger(TelnyxWebhookService.class);

    private final CallService callService;

    public TelnyxWebhookService(CallService callService) {
        this.callService = callService;
    }

    public Mono<Void> handleVoiceWebhook(Map<String, Object> payload) {
        String eventType = (String) payload.get("event_type");
        Map<String, Object> data = (Map<String, Object>) payload.get("data");
        Map<String, Object> callRecord = data != null ? (Map<String, Object>) data.get("record") : Map.of();

        String clientState = (String) callRecord.getOrDefault("client_state", "");
        String sipCallId = (String) callRecord.getOrDefault("call_control_id", null);

        return switch (eventType) {
            case "call.initiated" -> {
                String callSessionId = clientState;
                if (callSessionId != null && !callSessionId.isBlank()) {
                    yield callService.attachSipCallId(callSessionId, sipCallId);
                }
                yield Mono.empty();
            }
            case "call.answered" -> {
                yield Mono.fromRunnable(() -> log.info("Call {} answered", sipCallId));
            }
            case "call.hangup", "call.gather.ended" -> {
                long durationSeconds = ((Number) callRecord.getOrDefault("duration", 0)).longValue();
                String trunk = (String) callRecord.getOrDefault("connection_name", "telnyx");
                yield callService.finalizeBySipId(sipCallId, durationSeconds, eventType, trunk, null).then();
            }
            default -> {
                log.debug("Unhandled Telnyx event {}", eventType);
                yield Mono.empty();
            }
        };
    }
}
