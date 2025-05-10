# API Gateway for Document Management System

This API Gateway serves as the central entry point for the Document Management System microservices architecture. It routes requests to the appropriate services, handles cross-cutting concerns like authentication, and provides a unified API experience for clients.

## Microservices Architecture

The gateway routes requests to the following services:

- **Auth Service**: User authentication and authorization (port 8081)
- **Document Service**: Document metadata management (port 8082)
- **Translation Service**: Document title translation (port 8083)
- **Storage Service**: File storage management (port 8090)

## Features

- **Unified Entry Point**: Single endpoint for all client requests
- **JWT Authentication**: Centralized token validation
- **Path-Based Routing**: Automatic routing to appropriate microservices
- **Logging**: Request/response logging with timing information
- **Error Handling**: Consistent error responses across all services
- **CORS Support**: Cross-Origin Resource Sharing configuration

## API Routes

The gateway exposes the following routes:

- `/auth/**` → Auth Service at http://localhost:8081
- `/documents/**`, `/categories/**`, `/departments/**` → Document Service at http://localhost:8082
- `/translate/**` → Translation Service at http://localhost:8083
- `/storage/**` → Storage Service at http://localhost:8090

## Getting Started

### Prerequisites

- Java 17 or higher
- Maven 3.6+
- All microservices running on their respective ports

### Running the Gateway

```bash
# Build the project
mvn clean install

# Run the gateway
mvn spring-boot:run
```

The gateway will be available at http://localhost:8080.

## Configuration

Main configuration is in `application.yml`. Key settings:

- **Server Port**: 8080
- **JWT Secret**: Configure in production
- **CORS Settings**: Currently allows all origins (restrict in production)
- **Route Definitions**: Path patterns and target services

## Security

The gateway uses JWT for authentication:

1. Obtain a token from `/auth/login` (excluded from auth requirements)
2. Include token in all other requests: `Authorization: Bearer <your_token>`
3. Gateway validates token and forwards user identity to microservices

## Monitoring

Access actuator endpoints for monitoring:

- http://localhost:8080/actuator/health
- http://localhost:8080/actuator/info
- http://localhost:8080/actuator/metrics
- http://localhost:8080/actuator/gateway

## Production Considerations

Before deploying to production:

- Replace the JWT secret with a secure value
- Restrict CORS to specific origins
- Configure proper logging
- Consider adding rate limiting