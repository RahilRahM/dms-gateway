package com.docmgmt.gateway.filter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import reactor.core.publisher.Mono;

@Configuration
public class GlobalFilterConfig {
    
    private static final Logger logger = LoggerFactory.getLogger(GlobalFilterConfig.class);
    
    @Bean
    @Order(-1) // This ensures it's the first filter to be applied
    public GlobalFilter loggingFilter() {
        return (exchange, chain) -> {
            logger.info("Request: {} {}", 
                exchange.getRequest().getMethod(), 
                exchange.getRequest().getURI());
            
            long startTime = System.currentTimeMillis();
            
            return chain.filter(exchange)
                .then(Mono.fromRunnable(() -> {
                    long endTime = System.currentTimeMillis();
                    long executionTime = endTime - startTime;
                    
                    logger.info("Response: {} completed in {} ms", 
                        exchange.getResponse().getStatusCode(), 
                        executionTime);
                }));
        };
    }
    
    @Bean
    @Order(0) 
    public GlobalFilter errorHandlingFilter() {
        return (exchange, chain) -> {
            return chain.filter(exchange)
                .onErrorResume(error -> {
                    logger.error("Error during gateway processing: {}", error.getMessage(), error);
                    return Mono.error(error);
                });
        };
    }
}