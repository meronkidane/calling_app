package com.example.callingapp.service;

import com.example.callingapp.config.AuthProperties;
import com.example.callingapp.domain.User;
import com.example.callingapp.repository.UserRepository;
import reactor.core.publisher.Mono;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtException;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class AuthService {

    private static final Logger log = LoggerFactory.getLogger(AuthService.class);

    private final PhoneNumberService phoneNumberService;
    private final OtpService otpService;
    private final UserService userService;
    private final JwtService jwtService;
    private final AuthProperties authProperties;
    private final JwtDecoder jwtDecoder;

    public AuthService(PhoneNumberService phoneNumberService,
                       OtpService otpService,
                       UserService userService,
                       JwtService jwtService,
                       AuthProperties authProperties,
                       JwtDecoder jwtDecoder) {
        this.phoneNumberService = phoneNumberService;
        this.otpService = otpService;
        this.userService = userService;
        this.jwtService = jwtService;
        this.authProperties = authProperties;
        this.jwtDecoder = jwtDecoder;
    }

    public Mono<RequestOtpResponse> requestOtp(String rawPhoneNumber) {
        String e164 = phoneNumberService.toE164(rawPhoneNumber, authProperties.defaultRegion());
        return otpService.issueOtp(e164)
                .map(code -> new RequestOtpResponse(e164, authProperties.sandbox() ? code : null));
    }

    public Mono<AuthSession> verifyOtp(String rawPhoneNumber, String code) {
        String e164 = phoneNumberService.toE164(rawPhoneNumber, authProperties.defaultRegion());
        return otpService.verifyOtp(e164, code)
                .flatMap(result -> {
                    if (!result.success()) {
                        return Mono.error(new IllegalArgumentException("OTP verification failed"));
                    }
                    return userService.getOrCreateUser(e164);
                })
                .flatMap(this::createSession)
                .doOnSuccess(session -> log.info("User {} authenticated", session.user().id()));
    }

    public Mono<AuthSession> refresh(String refreshToken) {
        try {
            Jwt decoded = jwtDecoder.decode(refreshToken);
            @SuppressWarnings("unchecked")
            var roles = (java.util.List<String>) decoded.getClaims().getOrDefault("roles", java.util.List.of("USER"));
            return userService.getOrCreateUser(decoded.getClaimAsString("phone"))
                    .flatMap(user -> createTokenPair(user, roles, Map.of(
                            "phone", user.phoneE164(),
                            "kycStatus", user.kycStatus()
                    )).map(tokens -> new AuthSession(tokens, new UserSummary(
                            user.id(),
                            user.phoneE164(),
                            user.kycStatus(),
                            user.roles()
                    ))));
        } catch (JwtException ex) {
            return Mono.error(new IllegalArgumentException("Invalid refresh token"));
        }
    }

    private Mono<AuthSession> createSession(User user) {
        return createTokenPair(user, user.roles(), Map.of(
                "phone", user.phoneE164(),
                "kycStatus", user.kycStatus()
        )).map(tokens -> new AuthSession(tokens, new UserSummary(
                user.id(),
                user.phoneE164(),
                user.kycStatus(),
                user.roles()
        )));
    }

    private Mono<JwtService.TokenPair> createTokenPair(User user, java.util.List<String> roles, Map<String, Object> claims) {
        return Mono.zip(
                        jwtService.generateAccessToken(user.id(), roles, claims),
                        jwtService.generateRefreshToken(user.id(), roles, claims))
                .map(tuple -> new JwtService.TokenPair(tuple.getT1(), tuple.getT2()));
    }

    public record RequestOtpResponse(String phoneE164, String debugOtp) {
    }

    public record AuthSession(JwtService.TokenPair tokens, UserSummary user) {
    }

    public record UserSummary(String id, String phone, String kycStatus, java.util.List<String> roles) {
    }
}
