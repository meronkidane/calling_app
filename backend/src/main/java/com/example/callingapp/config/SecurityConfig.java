package com.example.callingapp.config;

import com.example.callingapp.web.filter.RateLimitingWebFilter;
import com.nimbusds.jose.jwk.source.ImmutableSecret;
import java.nio.charset.StandardCharsets;
import java.util.List;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.ReactiveAuthenticationManager;
import org.springframework.security.config.annotation.method.configuration.EnableReactiveMethodSecurity;
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.NimbusJwtEncoder;
import org.springframework.security.oauth2.jwt.NimbusReactiveJwtDecoder;
import org.springframework.security.oauth2.jwt.ReactiveJwtDecoder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.oauth2.server.resource.authentication.JwtReactiveAuthenticationManager;
import org.springframework.security.oauth2.server.resource.authentication.ReactiveJwtAuthenticationConverterAdapter;
import org.springframework.security.web.server.SecurityWebFilterChain;
import org.springframework.security.web.server.util.matcher.ServerWebExchangeMatchers;

@Configuration
@EnableWebFluxSecurity
@EnableReactiveMethodSecurity
public class SecurityConfig {

    private static final List<String> SWAGGER_PATHS = List.of(
            "/swagger-ui.html",
            "/swagger-ui/**",
            "/v3/api-docs/**",
            "/actuator/health",
            "/actuator/info"
    );

    @Bean
    public SecurityWebFilterChain springSecurityFilterChain(
            ServerHttpSecurity http,
            ReactiveAuthenticationManager authenticationManager,
            JwtAuthenticationConverter jwtAuthenticationConverter,
            RateLimitingWebFilter rateLimitingWebFilter) {

        http.csrf(ServerHttpSecurity.CsrfSpec::disable)
                .httpBasic(ServerHttpSecurity.HttpBasicSpec::disable)
                .formLogin(ServerHttpSecurity.FormLoginSpec::disable)
                .logout(ServerHttpSecurity.LogoutSpec::disable)
                .authenticationManager(authenticationManager)
                .oauth2ResourceServer(oauth2 -> oauth2
                        .jwt(jwt -> jwt.jwtAuthenticationConverter(new ReactiveJwtAuthenticationConverterAdapter(jwtAuthenticationConverter))))
                .addFilterAt(rateLimitingWebFilter, org.springframework.security.web.server.SecurityWebFiltersOrder.FIRST)
                .authorizeExchange(exchange -> exchange
                        .pathMatchers(HttpMethod.POST, "/auth/request-otp", "/auth/verify-otp", "/auth/refresh").permitAll()
                        .pathMatchers(HttpMethod.POST, "/webhooks/**").permitAll()
                        .matchers(ServerWebExchangeMatchers.pathMatchers(SWAGGER_PATHS.toArray(String[]::new))).permitAll()
                        .anyExchange().authenticated());

        return http.build();
    }

    @Bean
    public ReactiveAuthenticationManager reactiveAuthenticationManager(
            ReactiveJwtDecoder jwtDecoder,
            JwtAuthenticationConverter jwtAuthenticationConverter) {
        JwtReactiveAuthenticationManager manager = new JwtReactiveAuthenticationManager(jwtDecoder);
        manager.setJwtAuthenticationConverter(new ReactiveJwtAuthenticationConverterAdapter(jwtAuthenticationConverter));
        return manager;
    }

    @Bean
    public JwtAuthenticationConverter jwtAuthenticationConverter() {
        JwtAuthenticationConverter converter = new JwtAuthenticationConverter();
        converter.setJwtGrantedAuthoritiesConverter(jwt -> {
            List<String> roles = jwt.getClaimAsStringList("roles");
            if (roles == null || roles.isEmpty()) {
                return List.of();
            }
            return roles.stream()
                    .map(role -> role.startsWith("ROLE_") ? role : "ROLE_" + role.toUpperCase())
                    .map(SimpleGrantedAuthority::new)
                    .toList();
        });
        return converter;
    }

    @Bean
    public ReactiveJwtDecoder reactiveJwtDecoder(JwtProperties properties) {
        SecretKey secretKey = new SecretKeySpec(properties.secret().getBytes(StandardCharsets.UTF_8), "HmacSHA256");
        return NimbusReactiveJwtDecoder.withSecretKey(secretKey)
                .macAlgorithm(MacAlgorithm.HS256)
                .build();
    }

    @Bean
    public org.springframework.security.oauth2.jwt.JwtDecoder jwtDecoder(JwtProperties properties) {
        SecretKey secretKey = new SecretKeySpec(properties.secret().getBytes(StandardCharsets.UTF_8), "HmacSHA256");
        return org.springframework.security.oauth2.jwt.NimbusJwtDecoder.withSecretKey(secretKey)
                .macAlgorithm(MacAlgorithm.HS256)
                .build();
    }

    @Bean
    public JwtEncoder jwtEncoder(JwtProperties properties) {
        SecretKey secretKey = new SecretKeySpec(properties.secret().getBytes(StandardCharsets.UTF_8), "HmacSHA256");
        return new NimbusJwtEncoder(new ImmutableSecret<>(secretKey));
    }
}
