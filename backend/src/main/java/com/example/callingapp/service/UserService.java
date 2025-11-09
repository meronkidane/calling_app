package com.example.callingapp.service;

import com.example.callingapp.domain.User;
import com.example.callingapp.domain.Wallet;
import com.example.callingapp.repository.UserRepository;
import com.example.callingapp.repository.WalletRepository;
import java.time.Clock;
import java.time.Instant;
import java.util.List;
import java.util.UUID;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Service
public class UserService {

    private static final Logger log = LoggerFactory.getLogger(UserService.class);

    private final UserRepository userRepository;
    private final WalletRepository walletRepository;
    private final Clock clock;

    public UserService(UserRepository userRepository, WalletRepository walletRepository, Clock clock) {
        this.userRepository = userRepository;
        this.walletRepository = walletRepository;
        this.clock = clock;
    }

    public Mono<User> getOrCreateUser(String phoneE164) {
        return userRepository.findByPhoneE164(phoneE164)
                .switchIfEmpty(createUser(phoneE164));
    }

    private Mono<User> createUser(String phoneE164) {
        Instant now = clock.instant();
        User newUser = new User(UUID.randomUUID().toString(), phoneE164, null, List.of("USER"), "PENDING", now, now, "UTC", "en");
        return userRepository.save(newUser)
                .flatMap(user -> walletRepository.save(new Wallet(UUID.randomUUID().toString(), user.id(), 0, now, now))
                        .thenReturn(user))
                .doOnSuccess(user -> log.info("Created new user {}", user.id()));
    }

    public Mono<User> updateProfile(String userId, String timezone, String locale) {
        return userRepository.findById(userId)
                .switchIfEmpty(Mono.error(new IllegalArgumentException("User not found")))
                .flatMap(user -> {
                    User updated = new User(
                            user.id(),
                            user.phoneE164(),
                            user.email(),
                            user.roles(),
                            user.kycStatus(),
                            user.createdAt(),
                            clock.instant(),
                            timezone != null ? timezone : user.timezone(),
                            locale != null ? locale : user.locale());
                    return userRepository.save(updated);
                });
    }
}
