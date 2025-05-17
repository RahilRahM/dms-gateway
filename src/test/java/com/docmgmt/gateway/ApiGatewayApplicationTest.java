package com.docmgmt.gateway;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest(
  webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT
)
class ApiGatewayApplicationTest {

    @Test
    void contextLoads() {
        // simply verifies that the Spring context (and your routes + filters) can start
    }
}
