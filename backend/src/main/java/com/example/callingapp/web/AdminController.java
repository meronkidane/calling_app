package com.example.callingapp.web;

import com.example.callingapp.domain.SpendLimit;
import com.example.callingapp.domain.WalletEntry;
import com.example.callingapp.repository.CdrRepository;
import com.example.callingapp.repository.SpendLimitRepository;
import com.example.callingapp.service.WalletService;
import com.example.callingapp.web.dto.RateDtos;
import com.example.callingapp.web.dto.UserDtos;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Min;
import java.time.Clock;
import java.time.Instant;
import java.util.Map;
import org.springframework.http.MediaType;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping(path = "/admin", produces = MediaType.APPLICATION_JSON_VALUE)
@PreAuthorize("hasRole('ADMIN')")
public class AdminController {

    private final SpendLimitRepository spendLimitRepository;
    private final CdrRepository cdrRepository;
    private final WalletService walletService;
    private final Clock clock;

    public AdminController(
            SpendLimitRepository spendLimitRepository,
            CdrRepository cdrRepository,
            WalletService walletService,
            Clock clock) {
        this.spendLimitRepository = spendLimitRepository;
        this.cdrRepository = cdrRepository;
        this.walletService = walletService;
        this.clock = clock;
    }

    @PostMapping("/limits")
    public Mono<UserDtos.SpendLimitResponse> setLimit(@Valid @RequestBody SpendLimitRequest request) {
        Instant now = clock.instant();
        return spendLimitRepository.findByUserId(request.userId())
                .defaultIfEmpty(new SpendLimit(null, request.userId(), request.dailyCapCents(), request.perCallCapCents(), now))
                .flatMap(existing -> spendLimitRepository.save(new SpendLimit(
                        existing.id(),
                        request.userId(),
                        request.dailyCapCents(),
                        request.perCallCapCents(),
                        now
                )))
                .map(limit -> new UserDtos.SpendLimitResponse(limit.dailyCapCents(), limit.perCallCapCents()));
    }

    @GetMapping("/cdrs")
    public Flux<Map<String, Object>> cdrs() {
        return cdrRepository.findAll()
                .map(cdr -> Map.of(
                        "id", cdr.id(),
                        "userId", cdr.userId(),
                        "from", cdr.from(),
                        "to", cdr.to(),
                        "costCents", cdr.costCents(),
                        "status", cdr.status(),
                        "startTs", cdr.startTs(),
                        "endTs", cdr.endTs()
                ));
    }

    @PostMapping("/users/{id}/credit")
    public Mono<Void> adminCredit(@PathVariable("id") String userId, @Valid @RequestBody AdminCreditRequest request) {
        return walletService.credit(userId, request.amountCents(), "ADMIN_ADJUSTMENT", WalletEntry.EntryType.ADJUST).then();
    }

    public record SpendLimitRequest(
            String userId,
            @Min(0) long dailyCapCents,
            @Min(0) long perCallCapCents) {
    }

    public record AdminCreditRequest(@Min(1) long amountCents) {
    }
}
