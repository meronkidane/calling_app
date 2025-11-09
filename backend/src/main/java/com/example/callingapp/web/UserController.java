package com.example.callingapp.web;

import com.example.callingapp.domain.SpendLimit;
import com.example.callingapp.domain.User;
import com.example.callingapp.service.UserService;
import com.example.callingapp.service.WalletService;
import com.example.callingapp.web.dto.UserDtos;
import com.example.callingapp.web.dto.WalletDtos;
import com.example.callingapp.repository.SpendLimitRepository;
import jakarta.validation.Valid;
import org.springframework.http.MediaType;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping(path = "/me", produces = MediaType.APPLICATION_JSON_VALUE)
public class UserController {

    private final UserService userService;
    private final WalletService walletService;
    private final SpendLimitRepository spendLimitRepository;

    public UserController(UserService userService, WalletService walletService, SpendLimitRepository spendLimitRepository) {
        this.userService = userService;
        this.walletService = walletService;
        this.spendLimitRepository = spendLimitRepository;
    }

    @GetMapping
    public Mono<UserDtos.UserResponse> me(@AuthenticationPrincipal Jwt jwt) {
        return userService.getOrCreateUser(jwt.getClaimAsString("phone"))
                .map(this::toDto);
    }

    @PatchMapping
    public Mono<UserDtos.UserResponse> updateMe(
            @AuthenticationPrincipal Jwt jwt,
            @Valid @RequestBody UserDtos.UpdateUserRequest request) {
        String userId = jwt.getSubject();
        return userService.updateProfile(userId, request.timezone(), request.locale())
                .map(this::toDto);
    }

    @GetMapping("/wallet")
    public Mono<WalletDtos.WalletResponse> wallet(@AuthenticationPrincipal Jwt jwt) {
        return walletService.getWallet(jwt.getSubject())
                .map(wallet -> new WalletDtos.WalletResponse(wallet.balanceCents(), wallet.updatedAt()));
    }

    @GetMapping("/limits")
    public Mono<UserDtos.SpendLimitResponse> limits(@AuthenticationPrincipal Jwt jwt) {
        return spendLimitRepository.findByUserId(jwt.getSubject())
                .map(limit -> new UserDtos.SpendLimitResponse(limit.dailyCapCents(), limit.perCallCapCents()))
                .defaultIfEmpty(new UserDtos.SpendLimitResponse(0, 0));
    }

    private UserDtos.UserResponse toDto(User user) {
        return new UserDtos.UserResponse(user.id(), user.phoneE164(), user.timezone(), user.locale(), user.kycStatus());
    }
}
