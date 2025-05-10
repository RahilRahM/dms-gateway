package com.docmgmt.gateway.filter;

import com.docmgmt.gateway.security.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.List;

@Component
public class JwtAuthenticationFilter extends AbstractGatewayFilterFactory<JwtAuthenticationFilter.Config> {

    @Autowired
    private JwtUtil jwtUtil;

    public JwtAuthenticationFilter() {
        super(Config.class);
    }

    @Override
    public GatewayFilter apply(Config config) {
        return ((exchange, chain) -> {
            ServerHttpRequest request = exchange.getRequest();
            
            // Skip authentication for excluded paths
            if (config.isSecured(request, config.getExcludedPaths())) {
                if (!request.getHeaders().containsKey(HttpHeaders.AUTHORIZATION)) {
                    return onError(exchange, "Missing authorization header", HttpStatus.UNAUTHORIZED);
                }

                String authHeader = request.getHeaders().getFirst(HttpHeaders.AUTHORIZATION);
                if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                    return onError(exchange, "Invalid authorization header", HttpStatus.UNAUTHORIZED);
                }

                String token = authHeader.substring(7);
                if (!jwtUtil.validateToken(token)) {
                    return onError(exchange, "Invalid JWT token", HttpStatus.UNAUTHORIZED);
                }

                // Add user information to headers
                String username = jwtUtil.extractUsername(token);
                ServerHttpRequest modifiedRequest = request.mutate()
                        .header("X-User-Id", username)
                        .build();

                return chain.filter(exchange.mutate().request(modifiedRequest).build());
            }
            
            return chain.filter(exchange);
        });
    }

    private Mono<Void> onError(ServerWebExchange exchange, String message, HttpStatus status) {
        ServerHttpResponse response = exchange.getResponse();
        response.setStatusCode(status);
        return response.setComplete();
    }

    public static class Config {
        private List<String> excludedPaths;

        public List<String> getExcludedPaths() {
            return excludedPaths;
        }

        public void setExcludedPaths(List<String> excludedPaths) {
            this.excludedPaths = excludedPaths;
        }
        
        public boolean isSecured(ServerHttpRequest request, List<String> excludedPaths) {
            if (excludedPaths == null) {
                return true;
            }
            
            return excludedPaths.stream()
                    .noneMatch(path -> request.getURI().getPath().contains(path));
        }
    }
}