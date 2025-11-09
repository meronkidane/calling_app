package com.example.callingapp.web;

import com.example.callingapp.service.AuthService;
import com.example.callingapp.web.dto.AuthDtos;
import jakarta.validation.Valid;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@RestController
@RequestMapping(path = "/auth", produces = MediaType.APPLICATION_JSON_VALUE)
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    @PostMapping("/request-otp")
    public Mono<AuthDtos.RequestOtpResponse> requestOtp(@Valid @RequestBody AuthDtos.RequestOtpRequest request) {
        return authService.requestOtp(request.phone())
                .map(response -> new AuthDtos.RequestOtpResponse(response.phoneE164(), response.debugOtp()));
    }

    @PostMapping("/verify-otp")
    public Mono<AuthDtos.AuthResponse> verifyOtp(@Valid @RequestBody AuthDtos.VerifyOtpRequest request) {
        return authService.verifyOtp(request.phone(), request.code())
                .map(session -> new AuthDtos.AuthResponse(
                        new AuthDtos.TokenResponse(session.tokens().accessToken(), session.tokens().refreshToken()),
                        new AuthDtos.AuthenticatedUser(
                                session.user().id(),
                                session.user().phone(),
                                session.user().kycStatus(),
                                session.user().roles()
                        )));
    }

    @PostMapping("/refresh")
    public Mono<AuthDtos.TokenResponse> refresh(@Valid @RequestBody AuthDtos.RefreshRequest request) {
        return authService.refresh(request.refreshToken())
                .map(session -> new AuthDtos.TokenResponse(
                        session.tokens().accessToken(),
                        session.tokens().refreshToken()
                ));
    }
}
