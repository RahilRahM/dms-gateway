package com.docmgmt.gateway.filter;

import com.docmgmt.gateway.security.JwtUtil;
import io.jsonwebtoken.Claims;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.Ordered;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.List;

@Component
public class ReactiveJwtAuthenticationFilter implements GlobalFilter, Ordered {

    private static final Logger logger = LoggerFactory.getLogger(ReactiveJwtAuthenticationFilter.class);

    @Autowired
    private JwtUtil jwtUtil;

    /** Everything under these paths is completely open (no JWT required) */
    private static final List<String> OPEN_PATHS = List.of(
      "/auth/login",
      "/auth/register",

      // our user‐creation & listing
      "/users",          // exact /users
      "/users/",         // anything under /users/

      // product catalogs
      "/categories",
      "/categories/",
      "/departments",
      "/departments/"
    );

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        ServerHttpRequest  request = exchange.getRequest();
        String             path    = request.getPath().value();
        HttpMethod         method  = request.getMethod();

        // 1) Always let CORS preflight through
        if (method == HttpMethod.OPTIONS) {
            return chain.filter(exchange);
        }

        // 2) Let any of our OPEN_PATHS through
        if (OPEN_PATHS.stream().anyMatch(path::startsWith)) {
            return chain.filter(exchange);
        }

        // 3) Otherwise we require an Authorization: Bearer token
        if (!request.getHeaders().containsKey(HttpHeaders.AUTHORIZATION)) {
            logger.warn("Missing authorization header for path: {}", path);
            exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
            return exchange.getResponse().setComplete();
        }

        String authHeader = request.getHeaders().getFirst(HttpHeaders.AUTHORIZATION);
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            logger.warn("Invalid authorization header format for path: {}", path);
            exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
            return exchange.getResponse().setComplete();
        }

        String token = authHeader.substring(7);
        if (!jwtUtil.validateToken(token)) {
            logger.warn("Invalid JWT token for path: {}", path);
            exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
            return exchange.getResponse().setComplete();
        }

        // 4) Token is valid → propagate user info down to the services
        try {
            Claims claims = jwtUtil.getAllClaimsFromToken(token);
            String username = jwtUtil.extractUsername(token);
            @SuppressWarnings("unchecked")
            List<String> roles =
              (List<String>) claims.getOrDefault("roles", List.<String>of());

            String rolesString = String.join(",", roles);

            ServerHttpRequest modified = request.mutate()
                .header("X-Auth-User-Id",    username)
                .header("X-Auth-User-Roles", rolesString)
                .build();

            return chain.filter(exchange.mutate().request(modified).build());
        } catch (Exception e) {
            logger.error("Error processing JWT token: {}", e.getMessage(), e);
            exchange.getResponse().setStatusCode(HttpStatus.INTERNAL_SERVER_ERROR);
            return exchange.getResponse().setComplete();
        }
    }

    @Override
    public int getOrder() {
        // before Spring Cloud’s routing
        return -1;
    }
}
