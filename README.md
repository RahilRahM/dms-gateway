# API Gateway for Document Management System

This API Gateway is the main entry point for the Document Management System microservices. It routes client requests to the appropriate service, handles authentication and authorization, and provides a unified API for all client applications.

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

## Microservices Architecture

The gateway routes requests to the following services:

- **Auth Service**: User authentication and authorization (port 8081)
- **Document Service**: Document metadata management (port 8082)
- **Translation Service**: Document title translation (port 8083)
- **Storage Service**: File storage management (port 8090)

## Features

- **Single API Entry Point**: One endpoint for all client interactions
- **JWT Security**: Token validation and authorization
- **Path-Based Routing**: Request forwarding to appropriate microservices
- **Request Logging**: Tracking of requests and responses
- **Error Management**: Consistent error handling
- **CORS Configuration**: Cross-Origin Resource Sharing settings

## API Gateway Routes

The gateway routes to the following service endpoints:

| Service | Route Pattern | Target Service |
|---------|---------------|---------------|
| Authentication | `/auth/**` | Auth Service (http://localhost:8081) |
| Documents | `/documents/**` | Document Service (http://localhost:8082) |
| Categories | `/categories/**` | Document Service (http://localhost:8082) |
| Departments | `/departments/**` | Document Service (http://localhost:8082) |
| Translation | `/api/translate/**` | Translation Service (http://localhost:8083) |
| Storage | `/storage/**` | Storage Service (http://localhost:8090) |

### Authorization Requirements

| Endpoint Pattern | Required Role | Description |
|------------------|---------------|-------------|
| `/auth/register` | None (public) | User registration endpoint |
| `/auth/login` | None (public) | Authentication endpoint |
| `/documents/user/{email}` | ROLE_USER (self) or ROLE_ADMIN | Document access (user-specific) |
| `/documents` (POST) | ROLE_USER | Document creation |
| `/departments` (POST) | ROLE_ADMIN | Department creation |
| `/categories` (POST) | ROLE_ADMIN | Category creation |
| `/departments/{id}/users` | ROLE_ADMIN | Department user assignment |

All services are accessible through a single entry point at http://localhost:8080.

### Route Examples

| Service | Endpoint Example | Method | Description |
|---------|-----------------|--------|-------------|
| Auth | `/auth/register` | POST | Register a new user |
| Auth | `/auth/login` | POST | Login and get JWT token |
| Documents | `/documents` | POST | Create a document |
| Documents | `/documents/user/{email}` | GET | List user's documents |
| Documents | `/documents/{id}` | GET | Get document by ID |
| Documents | `/documents/{id}/download` | GET | Download document (redirect) |
| Categories | `/categories` | POST | Create a category |
| Categories | `/categories/{id}` | GET | Get category by ID |
| Departments | `/departments` | POST | Create a department |
| Departments | `/departments/{id}/users` | POST | Assign user to department |
| Translation | `/api/translate` | POST | Translate a title directly |
| Storage | `/storage/upload` | POST | Upload a file directly |
| Storage | `/storage/download/{key}` | GET | Get presigned download URL |

## API Examples

Below are key examples for using the API Gateway. For complete examples, see the `api-examples.sh`/`api-examples.bat` scripts.

> **Note:** Examples use [jq](https://stedolan.github.io/jq/) for JSON parsing where applicable.

### Authentication

```bash
# Register a new user
curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com", 
    "password": "password", 
    "roles": ["ROLE_USER"]
  }'

# Login and get token
TOKEN=$(curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com", 
    "password": "password"
  }' | jq -r '.token')
```

### Document Management

```bash
# Upload document with metadata
curl -X POST http://localhost:8080/documents \
  -H "Authorization: Bearer $TOKEN" \
  -F "file=@document.pdf" \
  -F 'metadata={"title":"Annual Report 2025","categoryId":"1","departmentId":"1","userEmail":"user@example.com"};type=application/json'

# Get documents for a user
curl -X GET "http://localhost:8080/documents/user/user@example.com" \
  -H "Authorization: Bearer $TOKEN"
```

### Admin Operations

```bash
# Create a department (requires ADMIN role)
curl -X POST http://localhost:8080/departments \
  -H "Authorization: Bearer $ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"HR", "description":"Human Resources Department"}'

# Assign user to department
curl -X POST "http://localhost:8080/departments/1/users?email=user@example.com" \
  -H "Authorization: Bearer $ADMIN_TOKEN"
```

### Other Services

```bash
# Translate a document title
curl -X POST "http://localhost:8080/api/translate" \
  -H "Content-Type: application/json" \
  -d '{"title":"Annual Report 2025","sourceLanguage":"en","targetLanguage":"es"}'

# Upload a file to storage
curl -X POST "http://localhost:8080/storage/upload" -F "file=@file.txt"

# Download a file (generates a pre-signed URL)
curl -L -o "downloaded_file.txt" "http://localhost:8080/storage/download/file_key"
```

## Security

The gateway uses JWT for authentication:

- Get a token from `/auth/login` (public endpoint)
- Include token in other requests: `Authorization: Bearer <your_token>`
- Headers forwarded to microservices: `X-Auth-User-Id`, `X-Auth-User-Roles`

### Authorization Flow

The authorization flow follows these steps:

1. Register a user (public endpoint)
2. Login to receive a JWT token 
3. Include the token in the Authorization header for subsequent requests
4. The gateway validates the token and enforces role-based access:
   - Regular users (ROLE_USER): Can access their own documents
   - Administrators (ROLE_ADMIN): Can manage departments, categories, and access all documents

## Monitoring

Access actuator endpoints for monitoring:

- http://localhost:8080/actuator/health
- http://localhost:8080/actuator/info
- http://localhost:8080/actuator/metrics
- http://localhost:8080/actuator/gateway

## Production Considerations

Before deploying to production:

- Use a secure JWT secret
- Restrict CORS to specific origins
- Set up proper logging
- Consider adding rate limiting