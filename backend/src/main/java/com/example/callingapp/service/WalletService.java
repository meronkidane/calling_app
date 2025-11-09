package com.example.callingapp.service;

import com.example.callingapp.domain.Wallet;
import com.example.callingapp.domain.WalletEntry;
import com.example.callingapp.repository.WalletEntryRepository;
import com.example.callingapp.repository.WalletRepository;
import java.time.Clock;
import java.time.Instant;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import reactor.core.publisher.Flux;
import reactor.core.publisher.Mono;

@Service
public class WalletService {

    private static final Logger log = LoggerFactory.getLogger(WalletService.class);

    private final WalletRepository walletRepository;
    private final WalletEntryRepository walletEntryRepository;
    private final Clock clock;
    private final WalletEventPublisher eventPublisher;

    public WalletService(
            WalletRepository walletRepository,
            WalletEntryRepository walletEntryRepository,
            Clock clock,
            WalletEventPublisher eventPublisher) {
        this.walletRepository = walletRepository;
        this.walletEntryRepository = walletEntryRepository;
        this.clock = clock;
        this.eventPublisher = eventPublisher;
    }

    public Mono<Wallet> getWallet(String userId) {
        return walletRepository.findByUserId(userId)
                .switchIfEmpty(Mono.error(new IllegalArgumentException("Wallet not found")));
    }

    public Flux<WalletEntry> listEntries(String userId) {
        return walletEntryRepository.findByUserIdOrderByCreatedAtDesc(userId);
    }

    @Transactional
    public Mono<WalletEntry> credit(String userId, long amountCents, String reference, WalletEntry.EntryType type) {
        if (amountCents <= 0) {
            return Mono.error(new IllegalArgumentException("Amount must be positive"));
        }
        Instant now = clock.instant();
        return walletRepository.findByUserId(userId)
                .switchIfEmpty(Mono.error(new IllegalArgumentException("Wallet not found")))
                .flatMap(wallet -> {
                    Wallet updated = new Wallet(wallet.id(), wallet.userId(), wallet.balanceCents() + amountCents, now, wallet.createdAt());
                    WalletEntry entry = new WalletEntry(UUID.randomUUID().toString(), userId, type, amountCents, reference, now, null);
                    return walletRepository.save(updated)
                            .then(walletEntryRepository.save(entry))
                            .doOnSuccess(saved -> eventPublisher.publishBalanceChanged(userId, updated.balanceCents()))
                            .doOnSuccess(saved -> log.info("Wallet {} credited {} cents", wallet.id(), amountCents));
                });
    }

    @Transactional
    public Mono<WalletEntry> debit(String userId, long amountCents, String reference) {
        if (amountCents <= 0) {
            return Mono.error(new IllegalArgumentException("Amount must be positive"));
        }
        Instant now = clock.instant();
        return walletRepository.findByUserId(userId)
                .switchIfEmpty(Mono.error(new IllegalArgumentException("Wallet not found")))
                .flatMap(wallet -> {
                    if (wallet.balanceCents() < amountCents) {
                        return Mono.error(new IllegalArgumentException("Insufficient balance"));
                    }
                    Wallet updated = new Wallet(wallet.id(), wallet.userId(), wallet.balanceCents() - amountCents, now, wallet.createdAt());
                    WalletEntry entry = new WalletEntry(UUID.randomUUID().toString(), userId, WalletEntry.EntryType.DEBIT, -amountCents, reference, now, null);
                    return walletRepository.save(updated)
                            .then(walletEntryRepository.save(entry))
                            .doOnSuccess(saved -> eventPublisher.publishBalanceChanged(userId, updated.balanceCents()))
                            .doOnSuccess(saved -> log.info("Wallet {} debited {} cents", wallet.id(), amountCents));
                });
    }

    public Mono<Boolean> hasSufficientBalance(String userId, long amountCents) {
        return walletRepository.findByUserId(userId)
                .map(wallet -> wallet.balanceCents() >= amountCents)
                .defaultIfEmpty(false);
    }

    public interface WalletEventPublisher {
        void publishBalanceChanged(String userId, long balanceCents);
    }
}
