package com.example.callingapp.web;

import com.example.callingapp.domain.WalletEntry;
import com.example.callingapp.service.BillingService;
import com.example.callingapp.service.WalletService;
import com.example.callingapp.web.dto.WalletDtos;
import jakarta.validation.Valid;
import org.springframework.http.MediaType;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping(path = "/wallet", produces = MediaType.APPLICATION_JSON_VALUE)
public class WalletController {

    private final WalletService walletService;
    private final BillingService billingService;

    public WalletController(WalletService walletService, BillingService billingService) {
        this.walletService = walletService;
        this.billingService = billingService;
    }

    @PostMapping("/topup-intent")
    public Mono<WalletDtos.TopupIntentResponse> topupIntent(
            @AuthenticationPrincipal Jwt jwt,
            @Valid @RequestBody WalletDtos.TopupIntentRequest request) {
        return billingService.createTopupIntent(jwt.getSubject(), request.amountCents())
                .map(WalletDtos.TopupIntentResponse::new);
    }

    @GetMapping("/entries")
    public Flux<WalletDtos.WalletEntryResponse> entries(@AuthenticationPrincipal Jwt jwt) {
        return walletService.listEntries(jwt.getSubject())
                .map(this::toDto);
    }

    private WalletDtos.WalletEntryResponse toDto(WalletEntry entry) {
        return new WalletDtos.WalletEntryResponse(
                entry.id(),
                entry.type().name(),
                entry.amountCents(),
                entry.reference(),
                entry.createdAt());
    }
}
