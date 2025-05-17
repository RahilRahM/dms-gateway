package com.docmgmt.gateway.filter;

import com.docmgmt.gateway.security.JwtUtil;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.mock.http.server.reactive.MockServerHttpRequest;
import org.springframework.mock.web.server.MockServerWebExchange;
import reactor.core.publisher.Mono;
import reactor.test.StepVerifier;

import javax.crypto.SecretKey;
import java.lang.reflect.Field;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.atomic.AtomicBoolean;

class ReactiveJwtAuthenticationFilterTest {

    private static final String SECRET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789AB";
    private static final long EXPIRATION = 86_400_000L; // 1 day
    private static final String PROTECTED_URI = "/documents/anything";

    private ReactiveJwtAuthenticationFilter filter;
    private SecretKey key;

    @BeforeEach
    void setUp() throws Exception {
        // 1) Prepare JwtUtil
        JwtUtil jwtUtil = new JwtUtil();
        Field secretF = JwtUtil.class.getDeclaredField("secret");
        Field expF    = JwtUtil.class.getDeclaredField("expiration");
        secretF.setAccessible(true);
        expF.setAccessible(true);
        secretF.set(jwtUtil, SECRET);
        expF.setLong(jwtUtil, EXPIRATION);

        // 2) Inject into filter
        filter = new ReactiveJwtAuthenticationFilter();
        Field utilF = ReactiveJwtAuthenticationFilter.class.getDeclaredField("jwtUtil");
        utilF.setAccessible(true);
        utilF.set(filter, jwtUtil);

        // 3) Build a signing key for valid-token tests
        key = Keys.hmacShaKeyFor(SECRET.getBytes(StandardCharsets.UTF_8));
    }

    @Test
    void excludedPaths_areAllowed() {
        var exchange = MockServerWebExchange.from(
            MockServerHttpRequest.get("/auth/login").build()
        );
        AtomicBoolean called = new AtomicBoolean(false);
        GatewayFilterChain chain = ex -> {
            called.set(true);
            return Mono.empty();
        };

        StepVerifier.create(filter.filter(exchange, chain))
                    .verifyComplete();

        assert called.get() : "Excluded path should pass through";
    }

    @Test
    void missingAuthHeader_returns401() {
        var exchange = MockServerWebExchange.from(
            MockServerHttpRequest.get(PROTECTED_URI).build()
        );
        GatewayFilterChain chain = ex -> Mono.error(new IllegalStateException("should not be called"));

        StepVerifier.create(filter.filter(exchange, chain))
                    .verifyComplete();

        assert exchange.getResponse().getStatusCode() == HttpStatus.UNAUTHORIZED;
    }

    @Test
    void malformedAuthHeader_returns401() {
        var request = MockServerHttpRequest
                          .get(PROTECTED_URI)
                          .header(HttpHeaders.AUTHORIZATION, "Bearer not.a.jwt")
                          .build();
        var exchange = MockServerWebExchange.from(request);
        GatewayFilterChain chain = ex -> Mono.error(new IllegalStateException("should not be called"));

        StepVerifier.create(filter.filter(exchange, chain))
                    .verifyComplete();

        var statusCode = exchange.getResponse().getStatusCode();
        HttpStatus status = statusCode != null ? HttpStatus.valueOf(statusCode.value()) : null;
        assert status == HttpStatus.UNAUTHORIZED || status == HttpStatus.UNSUPPORTED_MEDIA_TYPE :
               "Expected 401 or 415, got " + status;
    }

    @Test
    void validToken_passesFilter() {
        String jwt = Jwts.builder()
                         .setSubject("test-user")
                         .signWith(key)
                         .compact();

        var request = MockServerHttpRequest
                          .get(PROTECTED_URI)
                          .header(HttpHeaders.AUTHORIZATION, "Bearer " + jwt)
                          .build();
        var exchange = MockServerWebExchange.from(request);
        AtomicBoolean called = new AtomicBoolean(false);
        GatewayFilterChain chain = ex -> {
            called.set(true);
            return Mono.empty();
        };

        StepVerifier.create(filter.filter(exchange, chain))
                    .verifyComplete();

        assert called.get() : "Valid token should pass through";
    }
}
