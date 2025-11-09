package com.example.callingapp.web;

import com.example.callingapp.domain.Cdr;
import com.example.callingapp.repository.CdrRepository;
import com.example.callingapp.service.CallService;
import com.example.callingapp.web.dto.CallDtos;
import jakarta.validation.Valid;
import org.springframework.data.domain.Pageable;
import org.springframework.http.MediaType;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping(path = "/calls", produces = MediaType.APPLICATION_JSON_VALUE)
public class CallController {

    private final CallService callService;
    private final CdrRepository cdrRepository;

    public CallController(CallService callService, CdrRepository cdrRepository) {
        this.callService = callService;
        this.cdrRepository = cdrRepository;
    }

    @PostMapping("/outbound")
    public Mono<CallDtos.InitiateCallResponse> initiateOutbound(
            @AuthenticationPrincipal Jwt jwt,
            @Valid @RequestBody CallDtos.InitiateCallRequest request) {
        return callService.initiateOutboundCall(jwt.getSubject(), jwt.getClaimAsString("phone"), request.to())
                .map(auth -> new CallDtos.InitiateCallResponse(
                        auth.callSessionId(),
                        auth.dialString(),
                        auth.reservedCents(),
                        auth.currency(),
                        auth.ratePerMinuteCents()));
    }

    @GetMapping("/history")
    public Flux<CallDtos.CallHistoryResponse> history(@AuthenticationPrincipal Jwt jwt) {
        return cdrRepository.findByUserIdOrderByStartTsDesc(jwt.getSubject())
                .map(this::toDto);
    }

    @GetMapping("/{id}")
    public Mono<CallDtos.CallHistoryResponse> get(@AuthenticationPrincipal Jwt jwt, @PathVariable String id) {
        return cdrRepository.findById(id)
                .filter(cdr -> cdr.userId().equals(jwt.getSubject()))
                .map(this::toDto);
    }

    private CallDtos.CallHistoryResponse toDto(Cdr cdr) {
        return new CallDtos.CallHistoryResponse(
                cdr.id(),
                cdr.direction(),
                cdr.from(),
                cdr.to(),
                cdr.startTs(),
                cdr.endTs(),
                cdr.costCents(),
                cdr.status());
    }
}
