package com.example.callingapp.service;

import com.example.callingapp.config.JwtProperties;
import java.time.Instant;
import java.util.List;
import java.util.Map;
import org.springframework.security.oauth2.jwt.JwtClaimsSet;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.JwtEncoderParameters;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Mono;

@Service
public class JwtService {

    private final JwtEncoder jwtEncoder;
    private final JwtProperties jwtProperties;

    public JwtService(JwtEncoder jwtEncoder, JwtProperties jwtProperties) {
        this.jwtEncoder = jwtEncoder;
        this.jwtProperties = jwtProperties;
    }

    public Mono<String> generateAccessToken(String subject, List<String> roles, Map<String, Object> additionalClaims) {
        return Mono.fromSupplier(() -> encodeToken(subject, roles, additionalClaims, jwtProperties.accessTokenTtl()));
    }

    public Mono<String> generateRefreshToken(String subject, List<String> roles, Map<String, Object> additionalClaims) {
        return Mono.fromSupplier(() -> encodeToken(subject, roles, additionalClaims, jwtProperties.refreshTokenTtl()));
    }

    private String encodeToken(String subject, List<String> roles, Map<String, Object> additionalClaims, java.time.Duration ttl) {
        Instant now = Instant.now();
        JwtClaimsSet.Builder builder = JwtClaimsSet.builder()
                .issuer(jwtProperties.issuer())
                .subject(subject)
                .issuedAt(now)
                .expiresAt(now.plus(ttl))
                .claim("roles", roles);

        additionalClaims.forEach(builder::claim);

        return jwtEncoder.encode(JwtEncoderParameters.from(builder.build())).getTokenValue();
    }

    public record TokenPair(String accessToken, String refreshToken) {
    }
}
