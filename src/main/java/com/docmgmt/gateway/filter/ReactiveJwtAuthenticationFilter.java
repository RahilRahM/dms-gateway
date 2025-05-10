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
import org.springframework.http.HttpStatus;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.stream.Collectors;

@Component
public class ReactiveJwtAuthenticationFilter implements GlobalFilter, Ordered {

    private static final Logger logger = LoggerFactory.getLogger(ReactiveJwtAuthenticationFilter.class);
    
    @Autowired
    private JwtUtil jwtUtil;
    
    // List of paths that should be excluded from JWT validation
    private List<String> excludedPaths = List.of("/auth/login", "/auth/register");
    
    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        ServerHttpRequest request = exchange.getRequest();
        String path = request.getPath().value();
        
        // Skip JWT validation for excluded paths
        if (excludedPaths.stream().anyMatch(path::startsWith)) {
            return chain.filter(exchange);
        }
        
        // Check for Authorization header
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
        
        // Extract and validate token
        String token = authHeader.substring(7);
        if (!jwtUtil.validateToken(token)) {
            logger.warn("Invalid JWT token for path: {}", path);
            exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
            return exchange.getResponse().setComplete();
        }
        
        // If token is valid, extract claims and forward them to downstream services
        try {
            Claims claims = jwtUtil.getAllClaimsFromToken(token);
            String username = jwtUtil.extractUsername(token);
            
            // Handle roles as a List<String> instead of a String
            List<?> roles = claims.get("roles", List.class);
            String rolesString = "";
            
            if (roles != null) {
                // Convert the list to a comma-separated string
                rolesString = roles.stream()
                    .map(Object::toString)
                    .collect(Collectors.joining(","));
            }
            
            // Add user information to headers that will be passed to downstream services
            ServerHttpRequest modifiedRequest = request.mutate()
                    .header("X-Auth-User-Id", username)
                    .header("X-Auth-User-Roles", rolesString)
                    .build();
                    
            // Replace the request with our modified one and continue
            return chain.filter(exchange.mutate().request(modifiedRequest).build());
        } catch (Exception e) {
            logger.error("Error processing JWT token: {}", e.getMessage());
            exchange.getResponse().setStatusCode(HttpStatus.INTERNAL_SERVER_ERROR);
            return exchange.getResponse().setComplete();
        }
    }
    
    @Override
    public int getOrder() {
        // Execute this filter before the routing filter
        return -1;
    }
}