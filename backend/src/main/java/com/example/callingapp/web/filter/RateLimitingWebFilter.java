package com.example.callingapp.web.filter;

import com.example.callingapp.config.RateLimitProperties;
import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.Refill;
import java.net.InetSocketAddress;
import java.time.Duration;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.ReactiveSecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.server.ServerWebExchange;
import org.springframework.web.server.WebFilter;
import org.springframework.web.server.WebFilterChain;
import reactor.core.publisher.Mono;

@Component
public class RateLimitingWebFilter implements WebFilter {

    private static final Logger log = LoggerFactory.getLogger(RateLimitingWebFilter.class);

    private final RateLimitProperties properties;
    private final Map<String, Bucket> ipBuckets = new ConcurrentHashMap<>();
    private final Map<String, Bucket> userBuckets = new ConcurrentHashMap<>();

    public RateLimitingWebFilter(RateLimitProperties properties) {
        this.properties = properties;
    }

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, WebFilterChain chain) {
        ServerHttpRequest request = exchange.getRequest();
        String ip = resolveClientIp(request);
        Bucket ipBucket = ipBuckets.computeIfAbsent(ip, ignored -> buildBucket(properties.ipCapacity(), properties.ipWindow()));

        if (!ipBucket.tryConsume(1)) {
            log.warn("IP rate limit exceeded for {}", ip);
            return Mono.error(new ResponseStatusException(HttpStatus.TOO_MANY_REQUESTS, "IP rate limit exceeded"));
        }

        return ReactiveSecurityContextHolder.getContext()
                .map(context -> context.getAuthentication())
                .filter(Authentication::isAuthenticated)
                .map(Authentication::getName)
                .flatMap(userId -> {
                    Bucket userBucket = userBuckets.computeIfAbsent(userId,
                            ignored -> buildBucket(properties.userCapacity(), properties.userWindow()));
                    if (!userBucket.tryConsume(1)) {
                        log.warn("User rate limit exceeded for {}", userId);
                        return Mono.<Void>error(new ResponseStatusException(HttpStatus.TOO_MANY_REQUESTS, "User rate limit exceeded"));
                    }
                    return chain.filter(exchange);
                })
                .switchIfEmpty(chain.filter(exchange));
    }

    private Bucket buildBucket(long capacity, Duration window) {
        return Bucket.builder()
                .addLimit(Bandwidth.classic(capacity, Refill.intervally(capacity, window)))
                .build();
    }

    private String resolveClientIp(ServerHttpRequest request) {
        return request.getHeaders().getFirst("X-Forwarded-For") != null
                ? request.getHeaders().getFirst("X-Forwarded-For")
                : request.getRemoteAddress() != null
                ? safeHost(request.getRemoteAddress())
                : "unknown";
    }

    private String safeHost(InetSocketAddress address) {
        return address.getAddress() != null ? address.getAddress().getHostAddress() : address.getHostString();
    }
}
