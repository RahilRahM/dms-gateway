[1mdiff --git a/README.md b/README.md[m
[1mindex 5f86aa1..1544ce8 100644[m
[1m--- a/README.md[m
[1m+++ b/README.md[m
[36m@@ -1,6 +1,33 @@[m
 # API Gateway for Document Management System[m
 [m
[31m-This API Gateway is the main entry point for the Document Management System microservices. It routes client requests to the appropriate service, handles authentication and authorization, and provides a unified API for all client applications.[m
[32m+[m[32mThis API Gateway serves as the central entry point for the Document Management System microservices architecture. It routes requests to the appropriate services, handles cross-cutting concerns like authentication, and provides a unified API experience for clients.[m
[32m+[m
[32m+[m[32m## Microservices Architecture[m
[32m+[m
[32m+[m[32mThe gateway routes requests to the following services:[m
[32m+[m
[32m+[m[32m- **Auth Service**: User authentication and authorization (port 8081)[m
[32m+[m[32m- **Document Service**: Document metadata management (port 8082)[m
[32m+[m[32m- **Translation Service**: Document title translation (port 8083)[m
[32m+[m[32m- **Storage Service**: File storage management (port 8090)[m
[32m+[m
[32m+[m[32m## Features[m
[32m+[m
[32m+[m[32m- **Unified Entry Point**: Single endpoint for all client requests[m
[32m+[m[32m- **JWT Authentication**: Centralized token validation[m
[32m+[m[32m- **Path-Based Routing**: Automatic routing to appropriate microservices[m
[32m+[m[32m- **Logging**: Request/response logging with timing information[m
[32m+[m[32m- **Error Handling**: Consistent error responses across all services[m
[32m+[m[32m- **CORS Support**: Cross-Origin Resource Sharing configuration[m
[32m+[m
[32m+[m[32m## API Routes[m
[32m+[m
[32m+[m[32mThe gateway exposes the following routes:[m
[32m+[m
[32m+[m[32m- `/auth/**` → Auth Service at http://localhost:8081[m
[32m+[m[32m- `/documents/**`, `/categories/**`, `/departments/**` → Document Service at http://localhost:8082[m
[32m+[m[32m- `/translate/**` → Translation Service at http://localhost:8083[m
[32m+[m[32m- `/storage/**` → Storage Service at http://localhost:8090[m
 [m
 ## Getting Started[m
 [m
[36m@@ -31,157 +58,13 @@[m [mMain configuration is in `application.yml`. Key settings:[m
 - **CORS Settings**: Currently allows all origins (restrict in production)[m
 - **Route Definitions**: Path patterns and target services[m
 [m
[31m-## Microservices Architecture[m
[31m-[m
[31m-The gateway routes requests to the following services:[m
[31m-[m
[31m-- **Auth Service**: User authentication and authorization (port 8081)[m
[31m-- **Document Service**: Document metadata management (port 8082)[m
[31m-- **Translation Service**: Document title translation (port 8083)[m
[31m-- **Storage Service**: File storage management (port 8090)[m
[31m-[m
[31m-## Features[m
[31m-[m
[31m-- **Single API Entry Point**: One endpoint for all client interactions[m
[31m-- **JWT Security**: Token validation and authorization[m
[31m-- **Path-Based Routing**: Request forwarding to appropriate microservices[m
[31m-- **Request Logging**: Tracking of requests and responses[m
[31m-- **Error Management**: Consistent error handling[m
[31m-- **CORS Configuration**: Cross-Origin Resource Sharing settings[m
[31m-[m
[31m-## API Gateway Routes[m
[31m-[m
[31m-The gateway routes to the following service endpoints:[m
[31m-[m
[31m-| Service | Route Pattern | Target Service |[m
[31m-|---------|---------------|---------------|[m
[31m-| Authentication | `/auth/**` | Auth Service (http://localhost:8081) |[m
[31m-| Documents | `/documents/**` | Document Service (http://localhost:8082) |[m
[31m-| Categories | `/categories/**` | Document Service (http://localhost:8082) |[m
[31m-| Departments | `/departments/**` | Document Service (http://localhost:8082) |[m
[31m-| Translation | `/api/translate/**` | Translation Service (http://localhost:8083) |[m
[31m-| Storage | `/storage/**` | Storage Service (http://localhost:8090) |[m
[31m-[m
[31m-### Authorization Requirements[m
[31m-[m
[31m-| Endpoint Pattern | Required Role | Description |[m
[31m-|------------------|---------------|-------------|[m
[31m-| `/auth/register` | None (public) | User registration endpoint |[m
[31m-| `/auth/login` | None (public) | Authentication endpoint |[m
[31m-| `/documents/user/{email}` | ROLE_USER (self) or ROLE_ADMIN | Document access (user-specific) |[m
[31m-| `/documents` (POST) | ROLE_USER | Document creation |[m
[31m-| `/departments` (POST) | ROLE_ADMIN | Department creation |[m
[31m-| `/categories` (POST) | ROLE_ADMIN | Category creation |[m
[31m-| `/departments/{id}/users` | ROLE_ADMIN | Department user assignment |[m
[31m-[m
[31m-All services are accessible through a single entry point at http://localhost:8080.[m
[31m-[m
[31m-### Route Examples[m
[31m-[m
[31m-| Service | Endpoint Example | Method | Description |[m
[31m-|---------|-----------------|--------|-------------|[m
[31m-| Auth | `/auth/register` | POST | Register a new user |[m
[31m-| Auth | `/auth/login` | POST | Login and get JWT token |[m
[31m-| Documents | `/documents` | POST | Create a document |[m
[31m-| Documents | `/documents/user/{email}` | GET | List user's documents |[m
[31m-| Documents | `/documents/{id}` | GET | Get document by ID |[m
[31m-| Documents | `/documents/{id}/download` | GET | Download document (redirect) |[m
[31m-| Categories | `/categories` | POST | Create a category |[m
[31m-| Categories | `/categories/{id}` | GET | Get category by ID |[m
[31m-| Departments | `/departments` | POST | Create a department |[m
[31m-| Departments | `/departments/{id}/users` | POST | Assign user to department |[m
[31m-| Translation | `/api/translate` | POST | Translate a title directly |[m
[31m-| Storage | `/storage/upload` | POST | Upload a file directly |[m
[31m-| Storage | `/storage/download/{key}` | GET | Get presigned download URL |[m
[31m-[m
[31m-## API Examples[m
[31m-[m
[31m-Below are key examples for using the API Gateway. [m
[31m-[m
[31m-> **Note:** Examples use [jq](https://stedolan.github.io/jq/) for JSON parsing where applicable.[m
[31m-[m
[31m-### Authentication[m
[31m-[m
[31m-```bash[m
[31m-# Register a new user[m
[31m-curl -X POST http://localhost:8080/auth/register \[m
[31m-  -H "Content-Type: application/json" \[m
[31m-  -d '{[m
[31m-    "email": "user@example.com", [m
[31m-    "password": "password", [m
[31m-    "roles": ["ROLE_USER"][m
[31m-  }'[m
[31m-[m
[31m-# Login and get token[m
[31m-TOKEN=$(curl -X POST http://localhost:8080/auth/login \[m
[31m-  -H "Content-Type: application/json" \[m
[31m-  -d '{[m
[31m-    "email": "user@example.com", [m
[31m-    "password": "password"[m
[31m-  }' | jq -r '.token')[m
[31m-```[m
[31m-[m
[31m-### Document Management[m
[31m-[m
[31m-```bash[m
[31m-# Upload document with metadata[m
[31m-curl -X POST http://localhost:8080/documents \[m
[31m-  -H "Authorization: Bearer $TOKEN" \[m
[31m-  -F "file=@document.pdf" \[m
[31m-  -F 'metadata={"title":"Annual Report 2025","categoryId":"1","departmentId":"1","userEmail":"user@example.com"};type=application/json'[m
[31m-[m
[31m-# Get documents for a user[m
[31m-curl -X GET "http://localhost:8080/documents/user/user@example.com" \[m
[31m-  -H "Authorization: Bearer $TOKEN"[m
[31m-```[m
[31m-[m
[31m-### Admin Operations[m
[31m-[m
[31m-```bash[m
[31m-# Create a department (requires ADMIN role)[m
[31m-curl -X POST http://localhost:8080/departments \[m
[31m-  -H "Authorization: Bearer $ADMIN_TOKEN" \[m
[31m-  -H "Content-Type: application/json" \[m
[31m-  -d '{"name":"HR", "description":"Human Resources Department"}'[m
[31m-[m
[31m-# Assign user to department[m
[31m-curl -X POST "http://localhost:8080/departments/1/users?email=user@example.com" \[m
[31m-  -H "Authorization: Bearer $ADMIN_TOKEN"[m
[31m-```[m
[31m-[m
[31m-### Other Services[m
[31m-[m
[31m-```bash[m
[31m-# Translate a document title[m
[31m-curl -X POST "http://localhost:8080/api/translate" \[m
[31m-  -H "Content-Type: application/json" \[m
[31m-  -d '{"title":"Annual Report 2025","sourceLanguage":"en","targetLanguage":"es"}'[m
[31m-[m
[31m-# Upload a file to storage[m
[31m-curl -X POST "http://localhost:8080/storage/upload" -F "file=@file.txt"[m
[31m-[m
[31m-# Download a file (generates a pre-signed URL)[m
[31m-curl -L -o "downloaded_file.txt" "http://localhost:8080/storage/download/file_key"[m
[31m-```[m
[31m-[m
 ## Security[m
 [m
 The gateway uses JWT for authentication:[m
 [m
[31m-- Get a token from `/auth/login` (public endpoint)[m
[31m-- Include token in other requests: `Authorization: Bearer <your_token>`[m
[31m-- Headers forwarded to microservices: `X-Auth-User-Id`, `X-Auth-User-Roles`[m
[31m-[m
[31m-### Authorization Flow[m
[31m-[m
[31m-The authorization flow follows these steps:[m
[31m-[m
[31m-1. Register a user (public endpoint)[m
[31m-2. Login to receive a JWT token [m
[31m-3. Include the token in the Authorization header for subsequent requests[m
[31m-4. The gateway validates the token and enforces role-based access:[m
[31m-   - Regular users (ROLE_USER): Can access their own documents[m
[31m-   - Administrators (ROLE_ADMIN): Can manage departments, categories, and access all documents[m
[32m+[m[32m1. Obtain a token from `/auth/login` (excluded from auth requirements)[m
[32m+[m[32m2. Include token in all other requests: `Authorization: Bearer <your_token>`[m
[32m+[m[32m3. Gateway validates token and forwards user identity to microservices[m
 [m
 ## Monitoring[m
 [m
[36m@@ -196,7 +79,7 @@[m [mAccess actuator endpoints for monitoring:[m
 [m
 Before deploying to production:[m
 [m
[31m-- Use a secure JWT secret[m
[32m+[m[32m- Replace the JWT secret with a secure value[m
 - Restrict CORS to specific origins[m
[31m-- Set up proper logging[m
[31m-- Consider adding rate limiting[m
[32m+[m[32m- Configure proper logging[m
[32m+[m[32m- Consider adding rate limiting[m
\ No newline at end of file[m
[1mdiff --git a/pom.xml b/pom.xml[m
[1mindex c51d3b5..9f1da1f 100644[m
[1m--- a/pom.xml[m
[1m+++ b/pom.xml[m
[36m@@ -1,101 +1,141 @@[m
 <?xml version="1.0" encoding="UTF-8"?>[m
[31m-<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"[m
[31m-         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">[m
[31m-    <modelVersion>4.0.0</modelVersion>[m
[31m-    <parent>[m
[31m-        <groupId>org.springframework.boot</groupId>[m
[31m-        <artifactId>spring-boot-starter-parent</artifactId>[m
[31m-        <version>3.2.0</version>[m
[31m-        <relativePath/> <!-- lookup parent from repository -->[m
[31m-    </parent>[m
[31m-    [m
[31m-    <groupId>com.docmgmt</groupId>[m
[31m-    <artifactId>api-gateway</artifactId>[m
[31m-    <version>0.0.1-SNAPSHOT</version>[m
[31m-    <name>api-gateway</name>[m
[31m-    <description>API Gateway for Document Management System</description>[m
[31m-    [m
[31m-    <properties>[m
[31m-        <java.version>17</java.version>[m
[31m-        <spring-cloud.version>2023.0.0</spring-cloud.version>[m
[31m-    </properties>[m
[31m-    [m
[32m+[m[32m<project xmlns="http://maven.apache.org/POM/4.0.0"[m[41m [m
[32m+[m[32m         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"[m
[32m+[m[32m         xsi:schemaLocation="[m
[32m+[m[32m           http://maven.apache.org/POM/4.0.0[m[41m [m
[32m+[m[32m           https://maven.apache.org/xsd/maven-4.0.0.xsd">[m
[32m+[m[32m  <modelVersion>4.0.0</modelVersion>[m
[32m+[m
[32m+[m[32m  <!-- ========== PARENT ========== -->[m
[32m+[m[32m  <parent>[m
[32m+[m[32m    <groupId>org.springframework.boot</groupId>[m
[32m+[m[32m    <artifactId>spring-boot-starter-parent</artifactId>[m
[32m+[m[32m    <version>3.2.0</version>[m
[32m+[m[32m    <relativePath/>[m
[32m+[m[32m  </parent>[m
[32m+[m
[32m+[m[32m  <groupId>com.docmgmt</groupId>[m
[32m+[m[32m  <artifactId>api-gateway</artifactId>[m
[32m+[m[32m  <version>0.0.1-SNAPSHOT</version>[m
[32m+[m[32m  <name>api-gateway</name>[m
[32m+[m[32m  <description>API Gateway for Document Management System</description>[m
[32m+[m
[32m+[m[32m  <!-- ========== PROPERTIES ========== -->[m
[32m+[m[32m  <properties>[m
[32m+[m[32m    <java.version>17</java.version>[m
[32m+[m[32m    <spring-cloud.version>2023.0.0</spring-cloud.version>[m
[32m+[m[32m    <jjwt.version>0.11.5</jjwt.version>[m
[32m+[m[32m    <mockito.version>5.5.0</mockito.version>[m
[32m+[m[32m    <lombok.version>1.18.32</lombok.version>[m
[32m+[m[32m  </properties>[m
[32m+[m
[32m+[m[32m  <!-- ========== BOM IMPORT ========== -->[m
[32m+[m[32m  <dependencyManagement>[m
     <dependencies>[m
[31m-        <dependency>[m
[31m-            <groupId>org.springframework.cloud</groupId>[m
[31m-            <artifactId>spring-cloud-starter-gateway</artifactId>[m
[31m-        </dependency>[m
[31m-        [m
[31m-        <dependency>[m
[31m-            <groupId>org.springframework.boot</groupId>[m
[31m-            <artifactId>spring-boot-starter-actuator</artifactId>[m
[31m-        </dependency>[m
[31m-        [m
[31m-        <!-- For JWT token validation -->[m
[31m-        <dependency>[m
[31m-            <groupId>org.springframework.boot</groupId>[m
[31m-            <artifactId>spring-boot-starter-security</artifactId>[m
[31m-        </dependency>[m
[31m-        [m
[31m-        <dependency>[m
[31m-            <groupId>io.jsonwebtoken</groupId>[m
[31m-            <artifactId>jjwt-api</artifactId>[m
[31m-            <version>0.11.5</version>[m
[31m-        </dependency>[m
[31m-        [m
[31m-        <dependency>[m
[31m-            <groupId>io.jsonwebtoken</groupId>[m
[31m-            <artifactId>jjwt-impl</artifactId>[m
[31m-            <version>0.11.5</version>[m
[31m-            <scope>runtime</scope>[m
[31m-        </dependency>[m
[31m-        [m
[31m-        <dependency>[m
[31m-            <groupId>io.jsonwebtoken</groupId>[m
[31m-            <artifactId>jjwt-jackson</artifactId>[m
[31m-            <version>0.11.5</version>[m
[31m-            <scope>runtime</scope>[m
[31m-        </dependency>[m
[31m-        [m
[31m-        <dependency>[m
[31m-            <groupId>org.projectlombok</groupId>[m
[31m-            <artifactId>lombok</artifactId>[m
[31m-            <optional>true</optional>[m
[31m-        </dependency>[m
[31m-        [m
[31m-        <dependency>[m
[31m-            <groupId>org.springframework.boot</groupId>[m
[31m-            <artifactId>spring-boot-starter-test</artifactId>[m
[31m-            <scope>test</scope>[m
[31m-        </dependency>[m
[32m+[m[32m      <dependency>[m
[32m+[m[32m        <groupId>org.springframework.cloud</groupId>[m
[32m+[m[32m        <artifactId>spring-cloud-dependencies</artifactId>[m
[32m+[m[32m        <version>${spring-cloud.version}</version>[m
[32m+[m[32m        <type>pom</type>[m
[32m+[m[32m        <scope>import</scope>[m
[32m+[m[32m      </dependency>[m
     </dependencies>[m
[31m-    [m
[31m-    <dependencyManagement>[m
[31m-        <dependencies>[m
[31m-            <dependency>[m
[31m-                <groupId>org.springframework.cloud</groupId>[m
[31m-                <artifactId>spring-cloud-dependencies</artifactId>[m
[31m-                <version>${spring-cloud.version}</version>[m
[31m-                <type>pom</type>[m
[31m-                <scope>import</scope>[m
[31m-            </dependency>[m
[31m-        </dependencies>[m
[31m-    </dependencyManagement>[m
[31m-    [m
[31m-    <build>[m
[31m-        <plugins>[m
[31m-            <plugin>[m
[31m-                <groupId>org.springframework.boot</groupId>[m
[31m-                <artifactId>spring-boot-maven-plugin</artifactId>[m
[31m-                <configuration>[m
[31m-                    <excludes>[m
[31m-                        <exclude>[m
[31m-                            <groupId>org.projectlombok</groupId>[m
[31m-                            <artifactId>lombok</artifactId>[m
[31m-                        </exclude>[m
[31m-                    </excludes>[m
[31m-                </configuration>[m
[31m-            </plugin>[m
[31m-        </plugins>[m
[31m-    </build>[m
[31m-</project>[m
\ No newline at end of file[m
[32m+[m[32m  </dependencyManagement>[m
[32m+[m
[32m+[m[32m  <!-- ========== DEPENDENCIES ========== -->[m
[32m+[m[32m  <dependencies>[m
[32m+[m[32m    <!-- Gateway + Actuator + Security -->[m
[32m+[m[32m    <dependency>[m
[32m+[m[32m      <groupId>org.springframework.cloud</groupId>[m
[32m+[m[32m      <artifactId>spring-cloud-starter-gateway</artifactId>[m
[32m+[m[32m    </dependency>[m
[32m+[m[32m    <dependency>[m
[32m+[m[32m      <groupId>org.springframework.boot</groupId>[m
[32m+[m[32m      <artifactId>spring-boot-starter-actuator</artifactId>[m
[32m+[m[32m    </dependency>[m
[32m+[m[32m    <dependency>[m
[32m+[m[32m      <groupId>org.springframework.boot</groupId>[m
[32m+[m[32m      <artifactId>spring-boot-starter-security</artifactId>[m
[32m+[m[32m    </dependency>[m
[32m+[m
[32m+[m[32m    <!-- JJWT -->[m
[32m+[m[32m    <dependency>[m
[32m+[m[32m      <groupId>io.jsonwebtoken</groupId>[m
[32m+[m[32m      <artifactId>jjwt-api</artifactId>[m
[32m+[m[32m      <version>${jjwt.version}</version>[m
[32m+[m[32m    </dependency>[m
[32m+[m[32m    <dependency>[m
[32m+[m[32m      <groupId>io.jsonwebtoken</groupId>[m
[32m+[m[32m      <artifactId>jjwt-impl</artifactId>[m
[32m+[m[32m      <version>${jjwt.version}</version>[m
[32m+[m[32m      <scope>runtime</scope>[m
[32m+[m[32m    </dependency>[m
[32m+[m[32m    <dependency>[m
[32m+[m[32m      <groupId>io.jsonwebtoken</groupId>[m
[32m+[m[32m      <artifactId>jjwt-jackson</artifactId>[m
[32m+[m[32m      <version>${jjwt.version}</version>[m
[32m+[m[32m      <scope>runtime</scope>[m
[32m+[m[32m    </dependency>[m
[32m+[m
[32m+[m[32m    <!-- Lombok (compile-only) -->[m
[32m+[m[32m    <dependency>[m
[32m+[m[32m      <groupId>org.projectlombok</groupId>[m
[32m+[m[32m      <artifactId>lombok</artifactId>[m
[32m+[m[32m      <version>${lombok.version}</version>[m
[32m+[m[32m      <scope>provided</scope>[m
[32m+[m[32m    </dependency>[m
[32m+[m
[32m+[m[32m    <!-- ===== TESTING ===== -->[m
[32m+[m[32m    <dependency>[m
[32m+[m[32m      <groupId>org.springframework.boot</groupId>[m
[32m+[m[32m      <artifactId>spring-boot-starter-test</artifactId>[m
[32m+[m[32m      <scope>test</scope>[m
[32m+[m[32m    </dependency>[m
[32m+[m[32m    <dependency>[m
[32m+[m[32m      <groupId>io.projectreactor</groupId>[m
[32m+[m[32m      <artifactId>reactor-test</artifactId>[m
[32m+[m[32m      <scope>test</scope>[m
[32m+[m[32m    </dependency>[m
[32m+[m[32m    <dependency>[m
[32m+[m[32m      <groupId>org.mockito</groupId>[m
[32m+[m[32m      <artifactId>mockito-junit-jupiter</artifactId>[m
[32m+[m[32m      <version>${mockito.version}</version>[m
[32m+[m[32m      <scope>test</scope>[m
[32m+[m[32m    </dependency>[m
[32m+[m[32m    <dependency>[m
[32m+[m[32m      <groupId>org.mockito</groupId>[m
[32m+[m[32m      <artifactId>mockito-inline</artifactId>[m
[32m+[m[32m      <version>5.2.0</version>[m
[32m+[m[32m      <scope>test</scope>[m
[32m+[m[32m    </dependency>[m
[32m+[m[32m  </dependencies>[m
[32m+[m
[32m+[m[32m  <!-- ========== BUILD PLUGINS ========== -->[m
[32m+[m[32m  <build>[m
[32m+[m[32m    <plugins>[m
[32m+[m[32m      <!-- Ensure Java 17 compilation -->[m
[32m+[m[32m      <plugin>[m
[32m+[m[32m        <groupId>org.apache.maven.plugins</groupId>[m
[32m+[m[32m        <artifactId>maven-compiler-plugin</artifactId>[m
[32m+[m[32m        <version>3.11.0</version>[m
[32m+[m[32m        <configuration>[m
[32m+[m[32m          <source>${java.version}</source>[m
[32m+[m[32m          <target>${java.version}</target>[m
[32m+[m[32m        </configuration>[m
[32m+[m[32m      </plugin>[m
[32m+[m[32m      <!-- Spring Boot launcher -->[m
[32m+[m[32m      <plugin>[m
[32m+[m[32m        <groupId>org.springframework.boot</groupId>[m
[32m+[m[32m        <artifactId>spring-boot-maven-plugin</artifactId>[m
[32m+[m[32m        <configuration>[m
[32m+[m[32m          <excludes>[m
[32m+[m[32m            <exclude>[m
[32m+[m[32m              <groupId>org.projectlombok</groupId>[m
[32m+[m[32m              <artifactId>lombok</artifactId>[m
[32m+[m[32m            </exclude>[m
[32m+[m[32m          </excludes>[m
[32m+[m[32m        </configuration>[m
[32m+[m[32m      </plugin>[m
[32m+[m[32m    </plugins>[m
[32m+[m[32m  </build>[m
[32m+[m[32m</project>[m
[1mdiff --git a/src/main/java/com/docmgmt/gateway/filter/JwtAuthenticationFilter.java b/src/main/java/com/docmgmt/gateway/filter/JwtAuthenticationFilter.java[m
[1mdeleted file mode 100644[m
[1mindex 4ecd0f8..0000000[m
[1m--- a/src/main/java/com/docmgmt/gateway/filter/JwtAuthenticationFilter.java[m
[1m+++ /dev/null[m
[36m@@ -1,87 +0,0 @@[m
[31m-package com.docmgmt.gateway.filter;[m
[31m-[m
[31m-import com.docmgmt.gateway.security.JwtUtil;[m
[31m-import org.springframework.beans.factory.annotation.Autowired;[m
[31m-import org.springframework.cloud.gateway.filter.GatewayFilter;[m
[31m-import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;[m
[31m-import org.springframework.http.HttpHeaders;[m
[31m-import org.springframework.http.HttpStatus;[m
[31m-import org.springframework.http.server.reactive.ServerHttpRequest;[m
[31m-import org.springframework.http.server.reactive.ServerHttpResponse;[m
[31m-import org.springframework.stereotype.Component;[m
[31m-import org.springframework.web.server.ServerWebExchange;[m
[31m-import reactor.core.publisher.Mono;[m
[31m-[m
[31m-import java.util.List;[m
[31m-[m
[31m-@Component[m
[31m-public class JwtAuthenticationFilter extends AbstractGatewayFilterFactory<JwtAuthenticationFilter.Config> {[m
[31m-[m
[31m-    @Autowired[m
[31m-    private JwtUtil jwtUtil;[m
[31m-[m
[31m-    public JwtAuthenticationFilter() {[m
[31m-        super(Config.class);[m
[31m-    }[m
[31m-[m
[31m-    @Override[m
[31m-    public GatewayFilter apply(Config config) {[m
[31m-        return ((exchange, chain) -> {[m
[31m-            ServerHttpRequest request = exchange.getRequest();[m
[31m-            [m
[31m-            // Skip authentication for excluded paths[m
[31m-            if (config.isSecured(request, config.getExcludedPaths())) {[m
[31m-                if (!request.getHeaders().containsKey(HttpHeaders.AUTHORIZATION)) {[m
[31m-                    return onError(exchange, "Missing authorization header", HttpStatus.UNAUTHORIZED);[m
[31m-                }[m
[31m-[m
[31m-                String authHeader = request.getHeaders().getFirst(HttpHeaders.AUTHORIZATION);[m
[31m-                if (authHeader == null || !authHeader.startsWith("Bearer ")) {[m
[31m-                    return onError(exchange, "Invalid authorization header", HttpStatus.UNAUTHORIZED);[m
[31m-                }[m
[31m-[m
[31m-                String token = authHeader.substring(7);[m
[31m-                if (!jwtUtil.validateToken(token)) {[m
[31m-                    return onError(exchange, "Invalid JWT token", HttpStatus.UNAUTHORIZED);[m
[31m-                }[m
[31m-[m
[31m-                // Add user information to headers[m
[31m-                String username = jwtUtil.extractUsername(token);[m
[31m-                ServerHttpRequest modifiedRequest = request.mutate()[m
[31m-                        .header("X-User-Id", username)[m
[31m-                        .build();[m
[31m-[m
[31m-                return chain.filter(exchange.mutate().request(modifiedRequest).build());[m
[31m-            }[m
[31m-            [m
[31m-            return chain.filter(exchange);[m
[31m-        });[m
[31m-    }[m
[31m-[m
[31m-    private Mono<Void> onError(ServerWebExchange exchange, String message, HttpStatus status) {[m
[31m-        ServerHttpResponse response = exchange.getResponse();[m
[31m-        response.setStatusCode(status);[m
[31m-        return response.setComplete();[m
[31m-    }[m
[31m-[m
[31m-    public static class Config {[m
[31m-        private List<String> excludedPaths;[m
[31m-[m
[31m-        public List<String> getExcludedPaths() {[m
[31m-            return excludedPaths;[m
[31m-        }[m
[31m-[m
[31m-        public void setExcludedPaths(List<String> excludedPaths) {[m
[31m-            this.excludedPaths = excludedPaths;[m
[31m-        }[m
[31m-        [m
[31m-        public boolean isSecured(ServerHttpRequest request, List<String> excludedPaths) {[m
[31m-            if (excludedPaths == null) {[m
[31m-                return true;[m
[31m-            }[m
[31m-            [m
[31m-            return excludedPaths.stream()[m
[31m-                    .noneMatch(path -> request.getURI().getPath().contains(path));[m
[31m-        }[m
[31m-    }[m
[31m-}[m
\ No newline at end of file[m
[1mdiff --git a/src/main/java/com/docmgmt/gateway/filter/ReactiveJwtAuthenticationFilter.java b/src/main/java/com/docmgmt/gateway/filter/ReactiveJwtAuthenticationFilter.java[m
[1mindex b2e817d..858f4f6 100644[m
[1m--- a/src/main/java/com/docmgmt/gateway/filter/ReactiveJwtAuthenticationFilter.java[m
[1m+++ b/src/main/java/com/docmgmt/gateway/filter/ReactiveJwtAuthenticationFilter.java[m
[36m@@ -9,6 +9,7 @@[m [mimport org.springframework.cloud.gateway.filter.GatewayFilterChain;[m
 import org.springframework.cloud.gateway.filter.GlobalFilter;[m
 import org.springframework.core.Ordered;[m
 import org.springframework.http.HttpHeaders;[m
[32m+[m[32mimport org.springframework.http.HttpMethod;[m
 import org.springframework.http.HttpStatus;[m
 import org.springframework.http.server.reactive.ServerHttpRequest;[m
 import org.springframework.stereotype.Component;[m
[36m@@ -16,85 +17,94 @@[m [mimport org.springframework.web.server.ServerWebExchange;[m
 import reactor.core.publisher.Mono;[m
 [m
 import java.util.List;[m
[31m-import java.util.stream.Collectors;[m
 [m
 @Component[m
 public class ReactiveJwtAuthenticationFilter implements GlobalFilter, Ordered {[m
 [m
     private static final Logger logger = LoggerFactory.getLogger(ReactiveJwtAuthenticationFilter.class);[m
[31m-    [m
[32m+[m
     @Autowired[m
     private JwtUtil jwtUtil;[m
[31m-    [m
[31m-    // List of paths that should be excluded from JWT validation[m
[31m-    private List<String> excludedPaths = List.of("/auth/login", "/auth/register");[m
[31m-    [m
[32m+[m
[32m+[m[32m    /** Everything under these paths is completely open (no JWT required) */[m
[32m+[m[32m    private static final List<String> OPEN_PATHS = List.of([m
[32m+[m[32m      "/auth/login",[m
[32m+[m[32m      "/auth/register",[m
[32m+[m
[32m+[m[32m      // our user‐creation & listing[m
[32m+[m[32m      "/users",          // exact /users[m
[32m+[m[32m      "/users/",         // anything under /users/[m
[32m+[m
[32m+[m[32m      // product catalogs[m
[32m+[m[32m      "/categories",[m
[32m+[m[32m      "/categories/",[m
[32m+[m[32m      "/departments",[m
[32m+[m[32m      "/departments/"[m
[32m+[m[32m    );[m
[32m+[m
     @Override[m
     public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {[m
[31m-        ServerHttpRequest request = exchange.getRequest();[m
[31m-        String path = request.getPath().value();[m
[31m-        [m
[31m-        // Skip JWT validation for excluded paths[m
[31m-        if (excludedPaths.stream().anyMatch(path::startsWith)) {[m
[32m+[m[32m        ServerHttpRequest  request = exchange.getRequest();[m
[32m+[m[32m        String             path    = request.getPath().value();[m
[32m+[m[32m        HttpMethod         method  = request.getMethod();[m
[32m+[m
[32m+[m[32m        // 1) Always let CORS preflight through[m
[32m+[m[32m        if (method == HttpMethod.OPTIONS) {[m
[32m+[m[32m            return chain.filter(exchange);[m
[32m+[m[32m        }[m
[32m+[m
[32m+[m[32m        // 2) Let any of our OPEN_PATHS through[m
[32m+[m[32m        if (OPEN_PATHS.stream().anyMatch(path::startsWith)) {[m
             return chain.filter(exchange);[m
         }[m
[31m-        [m
[31m-        // Check for Authorization header[m
[32m+[m
[32m+[m[32m        // 3) Otherwise we require an Authorization: Bearer token[m
         if (!request.getHeaders().containsKey(HttpHeaders.AUTHORIZATION)) {[m
             logger.warn("Missing authorization header for path: {}", path);[m
             exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);[m
             return exchange.getResponse().setComplete();[m
         }[m
[31m-        [m
[32m+[m
         String authHeader = request.getHeaders().getFirst(HttpHeaders.AUTHORIZATION);[m
         if (authHeader == null || !authHeader.startsWith("Bearer ")) {[m
             logger.warn("Invalid authorization header format for path: {}", path);[m
             exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);[m
             return exchange.getResponse().setComplete();[m
         }[m
[31m-        [m
[31m-        // Extract and validate token[m
[32m+[m
         String token = authHeader.substring(7);[m
         if (!jwtUtil.validateToken(token)) {[m
             logger.warn("Invalid JWT token for path: {}", path);[m
             exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);[m
             return exchange.getResponse().setComplete();[m
         }[m
[31m-        [m
[31m-        // If token is valid, extract claims and forward them to downstream services[m
[32m+[m
[32m+[m[32m        // 4) Token is valid → propagate user info down to the services[m
         try {[m
             Claims claims = jwtUtil.getAllClaimsFromToken(token);[m
             String username = jwtUtil.extractUsername(token);[m
[31m-            [m
[31m-            // Handle roles as a List<String> instead of a String[m
[31m-            List<?> roles = claims.get("roles", List.class);[m
[31m-            String rolesString = "";[m
[31m-            [m
[31m-            if (roles != null) {[m
[31m-                // Convert the list to a comma-separated string[m
[31m-                rolesString = roles.stream()[m
[31m-                    .map(Object::toString)[m
[31m-                    .collect(Collectors.joining(","));[m
[31m-            }[m
[31m-            [m
[31m-            // Add user information to headers that will be passed to downstream services[m
[31m-            ServerHttpRequest modifiedRequest = request.mutate()[m
[31m-                    .header("X-Auth-User-Id", username)[m
[31m-                    .header("X-Auth-User-Roles", rolesString)[m
[31m-                    .build();[m
[31m-                    [m
[31m-            // Replace the request with our modified one and continue[m
[31m-            return chain.filter(exchange.mutate().request(modifiedRequest).build());[m
[32m+[m[32m            @SuppressWarnings("unchecked")[m
[32m+[m[32m            List<String> roles =[m
[32m+[m[32m              (List<String>) claims.getOrDefault("roles", List.<String>of());[m
[32m+[m
[32m+[m[32m            String rolesString = String.join(",", roles);[m
[32m+[m
[32m+[m[32m            ServerHttpRequest modified = request.mutate()[m
[32m+[m[32m                .header("X-Auth-User-Id",    username)[m
[32m+[m[32m                .header("X-Auth-User-Roles", rolesString)[m
[32m+[m[32m                .build();[m
[32m+[m
[32m+[m[32m            return chain.filter(exchange.mutate().request(modified).build());[m
         } catch (Exception e) {[m
[31m-            logger.error("Error processing JWT token: {}", e.getMessage());[m
[32m+[m[32m            logger.error("Error processing JWT token: {}", e.getMessage(), e);[m
             exchange.getResponse().setStatusCode(HttpStatus.INTERNAL_SERVER_ERROR);[m
             return exchange.getResponse().setComplete();[m
         }[m
     }[m
[31m-    [m
[32m+[m
     @Override[m
     public int getOrder() {[m
[31m-        // Execute this filter before the routing filter[m
[32m+[m[32m        // before Spring Cloud’s routing[m
         return -1;[m
     }[m
[31m-}[m
\ No newline at end of file[m
[32m+[m[32m}[m
[1mdiff --git a/src/main/resources/application.yml b/src/main/resources/application.yml[m
[1mindex d6dbd4d..c363d4f 100644[m
[1m--- a/src/main/resources/application.yml[m
[1m+++ b/src/main/resources/application.yml[m
[36m@@ -4,50 +4,79 @@[m [mserver:[m
 spring:[m
   application:[m
     name: api-gateway[m
[32m+[m
   cloud:[m
     gateway:[m
       globalcors:[m
         corsConfigurations:[m
           '[/**]':[m
[31m-            allowedOrigins: "*"[m
[31m-            allowedMethods: "*"[m
[31m-            allowedHeaders: "*"[m
[32m+[m[32m            allowedOrigins:[m
[32m+[m[32m              - "http://localhost:3000"[m
[32m+[m[32m            allowedMethods:[m
[32m+[m[32m              - GET[m
[32m+[m[32m              - POST[m
[32m+[m[32m              - PUT[m
[32m+[m[32m              - DELETE[m
[32m+[m[32m              - OPTIONS[m
[32m+[m[32m            allowedHeaders:[m
[32m+[m[32m              - "*"[m
[32m+[m[32m            allowCredentials: true[m
[32m+[m[32m            maxAge: 3600[m
[32m+[m
       routes:[m
[31m-        # Auth Service Routes - now preserving the /auth/ prefix[m
         - id: auth-service[m
           uri: http://localhost:8081[m
           predicates:[m
             - Path=/auth/**[m
 [m
[31m-        # Document Service Routes[m
         - id: document-service[m
           uri: http://localhost:8082[m
           predicates:[m
[31m-            - Path=/documents/**, /categories/**, /departments/**[m
[32m+[m[32m            - Path=/documents/**[m
[32m+[m
[32m+[m[32m        - id: category-service[m
[32m+[m[32m          uri: http://localhost:8082[m
[32m+[m[32m          predicates:[m
[32m+[m[32m            - Path=/categories/**[m
 [m
[31m-        # Translation Service Routes [m
[31m-        - id: translation-service-direct[m
[31m-          uri: http://localhost:8083[m
[32m+[m[32m        - id: department-service[m
[32m+[m[32m          uri: http://localhost:8082[m
[32m+[m[32m          predicates:[m
[32m+[m[32m            - Path=/departments/**[m
[32m+[m
[32m+[m[32m        - id: translation-service[m
[32m+[m[32m          uri: http://localhost:9083[m
           predicates:[m
             - Path=/api/translate/**[m
 [m
[31m-        # Storage Service Routes[m
         - id: storage-service[m
           uri: http://localhost:8090[m
           predicates:[m
             - Path=/storage/**[m
 [m
[31m-# JWT Configuration[m
[32m+[m[32m        - id: user-service[m
[32m+[m[32m          uri: http://localhost:8082[m
[32m+[m[32m          predicates:[m
[32m+[m[32m            - Path=/users/**   # this one line covers both list & detail[m
[32m+[m
[32m+[m
[32m+[m[41m        [m
[32m+[m
 jwt:[m
   secret: abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789AB[m
[31m-  expiration: 86400000 # 24 hours in milliseconds[m
[32m+[m[32m  expiration: 86400000[m
 [m
[31m-# Actuator Configuration[m
 management:[m
[32m+[m[32m  endpoint:[m
[32m+[m[32m    gateway:[m
[32m+[m[32m      enabled: true[m
[32m+[m[32m    health:[m
[32m+[m[32m      show-details: always[m
   endpoints:[m
     web:[m
       exposure:[m
[31m-        include: health,info,metrics,gateway[m
[31m-  endpoint:[m
[31m-    health:[m
[31m-      show-details: always[m
\ No newline at end of file[m
[32m+[m[32m        include: health, info, metrics, gateway[m
[32m+[m
[32m+[m[32mlogging:[m
[32m+[m[32m  level:[m
[32m+[m[32m    org.springframework.cloud.gateway: DEBUG[m
[1mdiff --git a/src/test/java/com/docmgmt/gateway/ApiGatewayApplicationTest.java b/src/test/java/com/docmgmt/gateway/ApiGatewayApplicationTest.java[m
[1mnew file mode 100644[m
[1mindex 0000000..e7d36af[m
[1m--- /dev/null[m
[1m+++ b/src/test/java/com/docmgmt/gateway/ApiGatewayApplicationTest.java[m
[36m@@ -0,0 +1,15 @@[m
[32m+[m[32mpackage com.docmgmt.gateway;[m
[32m+[m
[32m+[m[32mimport org.junit.jupiter.api.Test;[m
[32m+[m[32mimport org.springframework.boot.test.context.SpringBootTest;[m
[32m+[m
[32m+[m[32m@SpringBootTest([m
[32m+[m[32m  webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT[m
[32m+[m[32m)[m
[32m+[m[32mclass ApiGatewayApplicationTest {[m
[32m+[m
[32m+[m[32m    @Test[m
[32m+[m[32m    void contextLoads() {[m
[32m+[m[32m        // simply verifies that the Spring context (and your routes + filters) can start[m
[32m+[m[32m    }[m
[32m+[m[32m}[m
[1mdiff --git a/src/test/java/com/docmgmt/gateway/filter/ReactiveJwtAuthenticationFilterTest.java b/src/test/java/com/docmgmt/gateway/filter/ReactiveJwtAuthenticationFilterTest.java[m
[1mnew file mode 100644[m
[1mindex 0000000..15257f4[m
[1m--- /dev/null[m
[1m+++ b/src/test/java/com/docmgmt/gateway/filter/ReactiveJwtAuthenticationFilterTest.java[m
[36m@@ -0,0 +1,122 @@[m
[32m+[m[32mpackage com.docmgmt.gateway.filter;[m
[32m+[m
[32m+[m[32mimport com.docmgmt.gateway.security.JwtUtil;[m
[32m+[m[32mimport io.jsonwebtoken.Jwts;[m
[32m+[m[32mimport io.jsonwebtoken.security.Keys;[m
[32m+[m[32mimport org.junit.jupiter.api.BeforeEach;[m
[32m+[m[32mimport org.junit.jupiter.api.Test;[m
[32m+[m[32mimport org.springframework.cloud.gateway.filter.GatewayFilterChain;[m
[32m+[m[32mimport org.springframework.http.HttpHeaders;[m
[32m+[m[32mimport org.springframework.http.HttpStatus;[m
[32m+[m[32mimport org.springframework.mock.http.server.reactive.MockServerHttpRequest;[m
[32m+[m[32mimport org.springframework.mock.web.server.MockServerWebExchange;[m
[32m+[m[32mimport reactor.core.publisher.Mono;[m
[32m+[m[32mimport reactor.test.StepVerifier;[m
[32m+[m
[32m+[m[32mimport javax.crypto.SecretKey;[m
[32m+[m[32mimport java.lang.reflect.Field;[m
[32m+[m[32mimport java.nio.charset.StandardCharsets;[m
[32m+[m[32mimport java.util.concurrent.atomic.AtomicBoolean;[m
[32m+[m
[32m+[m[32mclass ReactiveJwtAuthenticationFilterTest {[m
[32m+[m
[32m+[m[32m    private static final String SECRET = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789AB";[m
[32m+[m[32m    private static final long EXPIRATION = 86_400_000L; // 1 day[m
[32m+[m[32m    private static final String PROTECTED_URI = "/documents/anything";[m
[32m+[m
[32m+[m[32m    private ReactiveJwtAuthenticationFilter filter;[m
[32m+[m[32m    private SecretKey key;[m
[32m+[m
[32m+[m[32m    @BeforeEach[m
[32m+[m[32m    void setUp() throws Exception {[m
[32m+[m[32m        // 1) Prepare JwtUtil[m
[32m+[m[32m        JwtUtil jwtUtil = new JwtUtil();[m
[32m+[m[32m        Field secretF = JwtUtil.class.getDeclaredField("secret");[m
[32m+[m[32m        Field expF    = JwtUtil.class.getDeclaredField("expiration");[m
[32m+[m[32m        secretF.setAccessible(true);[m
[32m+[m[32m        expF.setAccessible(true);[m
[32m+[m[32m        secretF.set(jwtUtil, SECRET);[m
[32m+[m[32m        expF.setLong(jwtUtil, EXPIRATION);[m
[32m+[m
[32m+[m[32m        // 2) Inject into filter[m
[32m+[m[32m        filter = new ReactiveJwtAuthenticationFilter();[m
[32m+[m[32m        Field utilF = ReactiveJwtAuthenticationFilter.class.getDeclaredField("jwtUtil");[m
[32m+[m[32m        utilF.setAccessible(true);[m
[32m+[m[32m        utilF.set(filter, jwtUtil);[m
[32m+[m
[32m+[m[32m        // 3) Build a signing key for valid-token tests[m
[32m+[m[32m        key = Keys.hmacShaKeyFor(SECRET.getBytes(StandardCharsets.UTF_8));[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    @Test[m
[32m+[m[32m    void excludedPaths_areAllowed() {[m
[32m+[m[32m        var exchange = MockServerWebExchange.from([m
[32m+[m[32m            MockServerHttpRequest.get("/auth/login").build()[m
[32m+[m[32m        );[m
[32m+[m[32m        AtomicBoolean called = new AtomicBoolean(false);[m
[32m+[m[32m        GatewayFilterChain chain = ex -> {[m
[32m+[m[32m            called.set(true);[m
[32m+[m[32m            return Mono.empty();[m
[32m+[m[32m        };[m
[32m+[m
[32m+[m[32m        StepVerifier.create(filter.filter(exchange, chain))[m
[32m+[m[32m                    .verifyComplete();[m
[32m+[m
[32m+[m[32m        assert called.get() : "Excluded path should pass through";[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    @Test[m
[32m+[m[32m    void missingAuthHeader_returns401() {[m
[32m+[m[32m        var exchange = MockServerWebExchange.from([m
[32m+[m[32m            MockServerHttpRequest.get(PROTECTED_URI).build()[m
[32m+[m[32m        );[m
[32m+[m[32m        GatewayFilterChain chain = ex -> Mono.error(new IllegalStateException("should not be called"));[m
[32m+[m
[32m+[m[32m        StepVerifier.create(filter.filter(exchange, chain))[m
[32m+[m[32m                    .verifyComplete();[m
[32m+[m
[32m+[m[32m        assert exchange.getResponse().getStatusCode() == HttpStatus.UNAUTHORIZED;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    @Test[m
[32m+[m[32m    void malformedAuthHeader_returns401() {[m
[32m+[m[32m        var request = MockServerHttpRequest[m
[32m+[m[32m                          .get(PROTECTED_URI)[m
[32m+[m[32m                          .header(HttpHeaders.AUTHORIZATION, "Bearer not.a.jwt")[m
[32m+[m[32m                          .build();[m
[32m+[m[32m        var exchange = MockServerWebExchange.from(request);[m
[32m+[m[32m        GatewayFilterChain chain = ex -> Mono.error(new IllegalStateException("should not be called"));[m
[32m+[m
[32m+[m[32m        StepVerifier.create(filter.filter(exchange, chain))[m
[32m+[m[32m                    .verifyComplete();[m
[32m+[m
[32m+[m[32m        var statusCode = exchange.getResponse().getStatusCode();[m
[32m+[m[32m        HttpStatus status = statusCode != null ? HttpStatus.valueOf(statusCode.value()) : null;[m
[32m+[m[32m        assert status == HttpStatus.UNAUTHORIZED || status == HttpStatus.UNSUPPORTED_MEDIA_TYPE :[m
[32m+[m[32m               "Expected 401 or 415, got " + status;[m
[32m+[m[32m    }[m
[32m+[m
[32m+[m[32m    @Test[m
[32m+[m[32m    void validToken_passesFilter() {[m
[32m+[m[32m        String jwt = Jwts.builder()[m
[32m+[m[32m                         .setSubject("test-user")[m
[32m+[m[32m                         .signWith(key)[m
[32m+[m[32m                         .compact();[m
[32m+[m
[32m+[m[32m        var request = MockServerHttpRequest[m
[32m+[m[32m                          .get(PROTECTED_URI)[m
[32m+[m[32m                          .header(HttpHeaders.AUTHORIZATION, "Bearer " + jwt)[m
[32m+[m[32m                          .build();[m
[32m+[m[32m        var exchange = MockServerWebExchange.from(request);[m
[32m+[m[32m        AtomicBoolean called = new AtomicBoolean(false);[m
[32m+[m[32m        GatewayFilterChain chain = ex -> {[m
[32m+[m[32m            called.set(true);[m
[32m+[m[32m            return Mono.empty();[m
[32m+[m[32m        };[m
[32m+[m
[32m+[m[32m        StepVerifier.create(filter.filter(exchange, chain))[m
[32m+[m[32m                    .verifyComplete();[m
[32m+[m
[32m+[m[32m        assert called.get() : "Valid token should pass through";[m
[32m+[m[32m    }[m
[32m+[m[32m}[m
[1mdiff --git a/target/api-gateway-0.0.1-SNAPSHOT.jar b/target/api-gateway-0.0.1-SNAPSHOT.jar[m
[1mindex 9e69a70..a4c6ad1 100644[m
Binary files a/target/api-gateway-0.0.1-SNAPSHOT.jar and b/target/api-gateway-0.0.1-SNAPSHOT.jar differ
[1mdiff --git a/target/api-gateway-0.0.1-SNAPSHOT.jar.original b/target/api-gateway-0.0.1-SNAPSHOT.jar.original[m
[1mindex 3c1b73a..609c95d 100644[m
Binary files a/target/api-gateway-0.0.1-SNAPSHOT.jar.original and b/target/api-gateway-0.0.1-SNAPSHOT.jar.original differ
[1mdiff --git a/target/classes/application.yml b/target/classes/application.yml[m
[1mindex d6dbd4d..c363d4f 100644[m
[1m--- a/target/classes/application.yml[m
[1m+++ b/target/classes/application.yml[m
[36m@@ -4,50 +4,79 @@[m [mserver:[m
 spring:[m
   application:[m
     name: api-gateway[m
[32m+[m
   cloud:[m
     gateway:[m
       globalcors:[m
         corsConfigurations:[m
           '[/**]':[m
[31m-            allowedOrigins: "*"[m
[31m-            allowedMethods: "*"[m
[31m-            allowedHeaders: "*"[m
[32m+[m[32m            allowedOrigins:[m
[32m+[m[32m              - "http://localhost:3000"[m
[32m+[m[32m            allowedMethods:[m
[32m+[m[32m              - GET[m
[32m+[m[32m              - POST[m
[32m+[m[32m              - PUT[m
[32m+[m[32m              - DELETE[m
[32m+[m[32m              - OPTIONS[m
[32m+[m[32m            allowedHeaders:[m
[32m+[m[32m              - "*"[m
[32m+[m[32m            allowCredentials: true[m
[32m+[m[32m            maxAge: 3600[m
[32m+[m
       routes:[m
[31m-        # Auth Service Routes - now preserving the /auth/ prefix[m
         - id: auth-service[m
           uri: http://localhost:8081[m
           predicates:[m
             - Path=/auth/**[m
 [m
[31m-        # Document Service Routes[m
         - id: document-service[m
           uri: http://localhost:8082[m
           predicates:[m
[31m-            - Path=/documents/**, /categories/**, /departments/**[m
[32m+[m[32m            - Path=/documents/**[m
[32m+[m
[32m+[m[32m        - id: category-service[m
[32m+[m[32m          uri: http://localhost:8082[m
[32m+[m[32m          predicates:[m
[32m+[m[32m            - Path=/categories/**[m
 [m
[31m-        # Translation Service Routes [m
[31m-        - id: translation-service-direct[m
[31m-          uri: http://localhost:8083[m
[32m+[m[32m        - id: department-service[m
[32m+[m[32m          uri: http://localhost:8082[m
[32m+[m[32m          predicates:[m
[32m+[m[32m            - Path=/departments/**[m
[32m+[m
[32m+[m[32m        - id: translation-service[m
[32m+[m[32m          uri: http://localhost:9083[m
           predicates:[m
             - Path=/api/translate/**[m
 [m
[31m-        # Storage Service Routes[m
         - id: storage-service[m
           uri: http://localhost:8090[m
           predicates:[m
             - Path=/storage/**[m
 [m
[31m-# JWT Configuration[m
[32m+[m[32m        - id: user-service[m
[32m+[m[32m          uri: http://localhost:8082[m
[32m+[m[32m          predicates:[m
[32m+[m[32m            - Path=/users/**   # this one line covers both list & detail[m
[32m+[m
[32m+[m
[32m+[m[41m        [m
[32m+[m
 jwt:[m
   secret: abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789AB[m
[31m-  expiration: 86400000 # 24 hours in milliseconds[m
[32m+[m[32m  expiration: 86400000[m
 [m
[31m-# Actuator Configuration[m
 management:[m
[32m+[m[32m  endpoint:[m
[32m+[m[32m    gateway:[m
[32m+[m[32m      enabled: true[m
[32m+[m[32m    health:[m
[32m+[m[32m      show-details: always[m
   endpoints:[m
     web:[m
       exposure:[m
[31m-        include: health,info,metrics,gateway[m
[31m-  endpoint:[m
[31m-    health:[m
[31m-      show-details: always[m
\ No newline at end of file[m
[32m+[m[32m        include: health, info, metrics, gateway[m
[32m+[m
[32m+[m[32mlogging:[m
[32m+[m[32m  level:[m
[32m+[m[32m    org.springframework.cloud.gateway: DEBUG[m
[1mdiff --git a/target/classes/com/docmgmt/gateway/filter/JwtAuthenticationFilter$Config.class b/target/classes/com/docmgmt/gateway/filter/JwtAuthenticationFilter$Config.class[m
[1mdeleted file mode 100644[m
[1mindex c3b9392..0000000[m
Binary files a/target/classes/com/docmgmt/gateway/filter/JwtAuthenticationFilter$Config.class and /dev/null differ
[1mdiff --git a/target/classes/com/docmgmt/gateway/filter/JwtAuthenticationFilter.class b/target/classes/com/docmgmt/gateway/filter/JwtAuthenticationFilter.class[m
[1mdeleted file mode 100644[m
[1mindex 42d287a..0000000[m
Binary files a/target/classes/com/docmgmt/gateway/filter/JwtAuthenticationFilter.class and /dev/null differ
[1mdiff --git a/target/classes/com/docmgmt/gateway/filter/ReactiveJwtAuthenticationFilter.class b/target/classes/com/docmgmt/gateway/filter/ReactiveJwtAuthenticationFilter.class[m
[1mindex 62ab582..d3af299 100644[m
Binary files a/target/classes/com/docmgmt/gateway/filter/ReactiveJwtAuthenticationFilter.class and b/target/classes/com/docmgmt/gateway/filter/ReactiveJwtAuthenticationFilter.class differ
[1mdiff --git a/target/maven-status/maven-compiler-plugin/compile/default-compile/createdFiles.lst b/target/maven-status/maven-compiler-plugin/compile/default-compile/createdFiles.lst[m
[1mindex 866d189..33e689b 100644[m
[1m--- a/target/maven-status/maven-compiler-plugin/compile/default-compile/createdFiles.lst[m
[1m+++ b/target/maven-status/maven-compiler-plugin/compile/default-compile/createdFiles.lst[m
[36m@@ -1,7 +1,5 @@[m
[31m-com\docmgmt\gateway\filter\JwtAuthenticationFilter$Config.class[m
[31m-com\docmgmt\gateway\filter\ReactiveJwtAuthenticationFilter.class[m
[31m-com\docmgmt\gateway\filter\JwtAuthenticationFilter.class[m
[31m-com\docmgmt\gateway\filter\GlobalFilterConfig.class[m
[31m-com\docmgmt\gateway\config\SecurityConfig.class[m
[31m-com\docmgmt\gateway\ApiGatewayApplication.class[m
[31m-com\docmgmt\gateway\security\JwtUtil.class[m
[32m+[m[32mcom/docmgmt/gateway/filter/GlobalFilterConfig.class[m
[32m+[m[32mcom/docmgmt/gateway/config/SecurityConfig.class[m
[32m+[m[32mcom/docmgmt/gateway/security/JwtUtil.class[m
[32m+[m[32mcom/docmgmt/gateway/filter/ReactiveJwtAuthenticationFilter.class[m
[32m+[m[32mcom/docmgmt/gateway/ApiGatewayApplication.class[m
[1mdiff --git a/target/maven-status/maven-compiler-plugin/compile/default-compile/inputFiles.lst b/target/maven-status/maven-compiler-plugin/compile/default-compile/inputFiles.lst[m
[1mindex 957e509..ffc23d2 100644[m
[1m--- a/target/maven-status/maven-compiler-plugin/compile/default-compile/inputFiles.lst[m
[1m+++ b/target/maven-status/maven-compiler-plugin/compile/default-compile/inputFiles.lst[m
[36m@@ -1,6 +1,5 @@[m
[31m-C:\Users\hp\Desktop\dms_micros\api_gateway\src\main\java\com\docmgmt\gateway\ApiGatewayApplication.java[m
[31m-C:\Users\hp\Desktop\dms_micros\api_gateway\src\main\java\com\docmgmt\gateway\filter\ReactiveJwtAuthenticationFilter.java[m
[31m-C:\Users\hp\Desktop\dms_micros\api_gateway\src\main\java\com\docmgmt\gateway\filter\JwtAuthenticationFilter.java[m
[31m-C:\Users\hp\Desktop\dms_micros\api_gateway\src\main\java\com\docmgmt\gateway\security\JwtUtil.java[m
[31m-C:\Users\hp\Desktop\dms_micros\api_gateway\src\main\java\com\docmgmt\gateway\filter\GlobalFilterConfig.java[m
[31m-C:\Users\hp\Desktop\dms_micros\api_gateway\src\main\java\com\docmgmt\gateway\config\SecurityConfig.java[m
[32m+[m[32m/Users/lilia/Desktop/deliverable/dms-gateway-main/src/main/java/com/docmgmt/gateway/filter/ReactiveJwtAuthenticationFilter.java[m
[32m+[m[32m/Users/lilia/Desktop/deliverable/dms-gateway-main/src/main/java/com/docmgmt/gateway/security/JwtUtil.java[m
[32m+[m[32m/Users/lilia/Desktop/deliverable/dms-gateway-main/src/main/java/com/docmgmt/gateway/filter/GlobalFilterConfig.java[m
[32m+[m[32m/Users/lilia/Desktop/deliverable/dms-gateway-main/src/main/java/com/docmgmt/gateway/ApiGatewayApplication.java[m
[32m+[m[32m/Users/lilia/Desktop/deliverable/dms-gateway-main/src/main/java/com/docmgmt/gateway/config/SecurityConfig.java[m
[1mdiff --git a/target/maven-status/maven-compiler-plugin/testCompile/default-testCompile/createdFiles.lst b/target/maven-status/maven-compiler-plugin/testCompile/default-testCompile/createdFiles.lst[m
[1mnew file mode 100644[m
[1mindex 0000000..0652197[m
[1m--- /dev/null[m
[1m+++ b/target/maven-status/maven-compiler-plugin/testCompile/default-testCompile/createdFiles.lst[m
[36m@@ -0,0 +1,2 @@[m
[32m+[m[32mcom/docmgmt/gateway/filter/ReactiveJwtAuthenticationFilterTest.class[m
[32m+[m[32mcom/docmgmt/gateway/ApiGatewayApplicationTest.class[m
[1mdiff --git a/target/maven-status/maven-compiler-plugin/testCompile/default-testCompile/inputFiles.lst b/target/maven-status/maven-compiler-plugin/testCompile/default-testCompile/inputFiles.lst[m
[1mnew file mode 100644[m
[1mindex 0000000..f12d2a2[m
[1m--- /dev/null[m
[1m+++ b/target/maven-status/maven-compiler-plugin/testCompile/default-testCompile/inputFiles.lst[m
[36m@@ -0,0 +1,2 @@[m
[32m+[m[32m/Users/lilia/Desktop/deliverable/dms-gateway-main/src/test/java/com/docmgmt/gateway/ApiGatewayApplicationTest.java[m
[32m+[m[32m/Users/lilia/Desktop/deliverable/dms-gateway-main/src/test/java/com/docmgmt/gateway/filter/ReactiveJwtAuthenticationFilterTest.java[m
[1mdiff --git a/target/surefire-reports/TEST-com.docmgmt.gateway.ApiGatewayApplicationTest.xml b/target/surefire-reports/TEST-com.docmgmt.gateway.ApiGatewayApplicationTest.xml[m
[1mnew file mode 100644[m
[1mindex 0000000..abdc9da[m
[1m--- /dev/null[m
[1m+++ b/target/surefire-reports/TEST-com.docmgmt.gateway.ApiGatewayApplicationTest.xml[m
[36m@@ -0,0 +1,127 @@[m
[32m+[m[32m<?xml version="1.0" encoding="UTF-8"?>[m
[32m+[m[32m<testsuite xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="https://maven.apache.org/surefire/maven-surefire-plugin/xsd/surefire-test-report-3.0.xsd" version="3.0" name="com.docmgmt.gateway.ApiGatewayApplicationTest" time="2.846" tests="1" errors="0" skipped="0" failures="0">[m
[32m+[m[32m  <properties>[m
[32m+[m[32m    <property name="java.specification.version" value="23"/>[m
[32m+[m[32m    <property name="sun.jnu.encoding" value="UTF-8"/>[m
[32m+[m[32m    <property name="java.class.path" value="/Users/lilia/Desktop/deliverable/dms-gateway-main/target/test-classes:/Users/lilia/Desktop/deliverable/dms-gateway-main/target/classes:/Users/lilia/.m2/repository/org/springframework/cloud/spring-cloud-starter-gateway/4.1.0/spring-cloud-starter-gateway-4.1.0.jar:/Users/lilia/.m2/repository/org/springframework/cloud/spring-cloud-starter/4.1.0/spring-cloud-starter-4.1.0.jar:/Users/lilia/.m2/repository/org/springframework/cloud/spring-cloud-context/4.1.0/spring-cloud-context-4.1.0.jar:/Users/lilia/.m2/repository/org/springframework/security/spring-security-crypto/6.2.0/spring-security-crypto-6.2.0.jar:/Users/lilia/.m2/repository/org/springframework/cloud/spring-cloud-commons/4.1.0/spring-cloud-commons-4.1.0.jar:/Users/lilia/.m2/repository/org/springframework/security/spring-security-rsa/1.1.1/spring-security-rsa-1.1.1.jar:/Users/lilia/.m2/repository/org/bouncycastle/bcprov-jdk18on/1.74/bcprov-jdk18on-1.74.jar:/Users/lilia/.m2/repository/org/springframework/cloud/spring-cloud-gateway-server/4.1.0/spring-cloud-gateway-server-4.1.0.jar:/Users/lilia/.m2/repository/org/springframework/boot/spring-boot-starter-validation/3.2.0/spring-boot-starter-validation-3.2.0.jar:/Users/lilia/.m2/repository/org/apache/tomcat/embed/tomcat-embed-el/10.1.16/tomcat-embed-el-10.1.16.jar:/Users/lilia/.m2/repository/org/hibernate/validator/hibernate-validator/8.0.1.Final/hibernate-validator-8.0.1.Final.jar:/Users/lilia/.m2/repository/jakarta/validation/jakarta.validation-api/3.0.2/jakarta.validation-api-3.0.2.jar:/Users/lilia/.m2/repository/org/jboss/logging/jboss-logging/3.5.3.Final/jboss-logging-3.5.3.Final.jar:/Users/lilia/.m2/repository/com/fasterxml/classmate/1.6.0/classmate-1.6.0.jar:/Users/lilia/.m2/repository/io/projectreactor/addons/reactor-extra/3.5.1/reactor-extra-3.5.1.jar:/Users/lilia/.m2/repository/org/springframework/boot/spring-boot-starter-webflux/3.2.0/spring-boot-starter-webflux-3.2.0.jar:/Users/lilia/.m2/repository/org/springframework/boot/spring-boot-starter-json/3.2.0/spring-boot-starter-json-3.2.0.jar:/Users/lilia/.m2/repository/com/fasterxml/jackson/datatype/jackson-datatype-jdk8/2.15.3/jackson-datatype-jdk8-2.15.3.jar:/Users/lilia/.m2/repository/com/fasterxml/jackson/module/jackson-module-parameter-names/2.15.3/jackson-module-parameter-names-2.15.3.jar:/Users/lilia/.m2/repository/org/springframework/boot/spring-boot-starter-reactor-netty/3.2.0/spring-boot-starter-reactor-netty-3.2.0.jar:/Users/lilia/.m2/repository/io/projectreactor/netty/reactor-netty-http/1.1.13/reactor-netty-http-1.1.13.jar:/Users/lilia/.m2/repository/io/netty/netty-codec-http/4.1.101.Final/netty-codec-http-4.1.101.Final.jar:/Users/lilia/.m2/repository/io/netty/netty-common/4.1.101.Final/netty-common-4.1.101.Final.jar:/Users/lilia/.m2/repository/io/netty/netty-buffer/4.1.101.Final/netty-buffer-4.1.101.Final.jar:/Users/lilia/.m2/repository/io/netty/netty-transport/4.1.101.Final/netty-transport-4.1.101.Final.jar:/Users/lilia/.m2/repository/io/netty/netty-codec/4.1.101.Final/netty-codec-4.1.101.Final.jar:/Users/lilia/.m2/repository/io/netty/netty-handler/4.1.101.Final/netty-handler-4.1.101.Final.jar:/Users/lilia/.m2/repository/io/netty/netty-codec-http2/4.1.101.Final/netty-codec-http2-4.1.101.Final.jar:/Users/lilia/.m2/repository/io/netty/netty-resolver-dns/4.1.101.Final/netty-resolver-dns-4.1.101.Final.jar:/Users/lilia/.m2/repository/io/netty/netty-resolver/4.1.101.Final/netty-resolver-4.1.101.Final.jar:/Users/lilia/.m2/repository/io/netty/netty-codec-dns/4.1.101.Final/netty-codec-dns-4.1.101.Final.jar:/Users/lilia/.m2/repository/io/netty/netty-resolver-dns-native-macos/4.1.101.Final/netty-resolver-dns-native-macos-4.1.101.Final-osx-x86_64.jar:/Users/lilia/.m2/repository/io/netty/netty-resolver-dns-classes-macos/4.1.101.Final/netty-resolver-dns-classes-macos-4.1.101.Final.jar:/Users/lilia/.m2/repository/io/netty/netty-transport-native-epoll/4.1.101.Final/netty-transport-native-epoll-4.1.101.Final-linux-x86_64.jar:/Users/lilia/.m2/repository/io/netty/netty-transport-native-unix-common/4.1.101.Final/netty-transport-native-unix-common-4.1.101.Final.jar:/Users/lilia/.m2/repository/io/netty/netty-transport-classes-epoll/4.1.101.Final/netty-transport-classes-epoll-4.1.101.Final.jar:/Users/lilia/.m2/repository/io/projectreactor/netty/reactor-netty-core/1.1.13/reactor-netty-core-1.1.13.jar:/Users/lilia/.m2/repository/io/netty/netty-handler-proxy/4.1.101.Final/netty-handler-proxy-4.1.101.Final.jar:/Users/lilia/.m2/repository/io/netty/netty-codec-socks/4.1.101.Final/netty-codec-socks-4.1.101.Final.jar:/Users/lilia/.m2/repository/org/springframework/spring-web/6.1.1/spring-web-6.1.1.jar:/Users/lilia/.m2/repository/org/springframework/spring-webflux/6.1.1/spring-webflux-6.1.1.jar:/Users/lilia/.m2/repository/org/springframework/boot/spring-boot-starter-actuator/3.2.0/spring-boot-starter-actuator-3.2.0.jar:/Users/lilia/.m2/repository/org/springframework/boot/spring-boot-starter/3.2.0/spring-boot-starter-3.2.0.jar:/Users/lilia/.m2/repository/org/springframework/boot/spring-boot/3.2.0/spring-boot-3.2.0.jar:/Users/lilia/.m2/repository/org/springframework/boot/spring-boot-autoconfigure/3.2.0/spring-boot-autoconfigure-3.2.0.jar:/Users/lilia/.m2/repository/org/springframework/boot/spring-boot-starter-logging/3.2.0/spring-boot-starter-logging-3.2.0.jar:/Users/lilia/.m2/repository/ch/qos/logback/logback-classic/1.4.11/logback-classic-1.4.11.jar:/Users/lilia/.m2/repository/ch/qos/logback/logback-core/1.4.11/logback-core-1.4.11.jar:/Users/lilia/.m2/repository/org/apache/logging/log4j/log4j-to-slf4j/2.21.1/log4j-to-slf4j-2.21.1.jar:/Users/lilia/.m2/repository/org/apache/logging/log4j/log4j-api/2.21.1/log4j-api-2.21.1.jar:/Users/lilia/.m2/repository/org/slf4j/jul-to-slf4j/2.0.9/jul-to-slf4j-2.0.9.jar:/Users/lilia/.m2/repository/jakarta/annotation/jakarta.annotation-api/2.1.1/jakarta.annotation-api-2.1.1.jar:/Users/lilia/.m2/repository/org/yaml/snakeyaml/2.2/snakeyaml-2.2.jar:/Users/lilia/.m2/repository/org/springframework/boot/spring-boot-actuator-autoconfigure/3.2.0/spring-boot-actuator-autoconfigure-3.2.0.jar:/Users/lilia/.m2/repository/org/springframework/boot/spring-boot-actuator/3.2.0/spring-boot-actuator-3.2.0.jar:/Users/lilia/.m2/repository/com/fasterxml/jackson/datatype/jackson-datatype-jsr310/2.15.3/jackson-datatype-jsr310-2.15.3.jar:/Users/lilia/.m2/repository/io/micrometer/micrometer-observation/1.12.0/micrometer-observation-1.12.0.jar:/Users/lilia/.m2/repository/io/micrometer/micrometer-commons/1.12.0/micrometer-commons-1.12.0.jar:/Users/lilia/.m2/repository/io/micrometer/micrometer-jakarta9/1.12.0/micrometer-jakarta9-1.12.0.jar:/Users/lilia/.m2/repository/io/micrometer/micrometer-core/1.12.0/micrometer-core-1.12.0.jar:/Users/lilia/.m2/repository/org/hdrhistogram/HdrHistogram/2.1.12/HdrHistogram-2.1.12.jar:/Users/lilia/.m2/repository/org/latencyutils/LatencyUtils/2.0.3/LatencyUtils-2.0.3.jar:/Users/lilia/.m2/repository/org/springframework/boot/spring-boot-starter-security/3.2.0/spring-boot-starter-security-3.2.0.jar:/Users/lilia/.m2/repository/org/springframework/spring-aop/6.1.1/spring-aop-6.1.1.jar:/Users/lilia/.m2/repository/org/springframework/spring-beans/6.1.1/spring-beans-6.1.1.jar:/Users/lilia/.m2/repository/org/springframework/security/spring-security-config/6.2.0/spring-security-config-6.2.0.jar:/Users/lilia/.m2/repository/org/springframework/security/spring-security-core/6.2.0/spring-security-core-6.2.0.jar:/Users/lilia/.m2/repository/org/springframework/spring-context/6.1.1/spring-context-6.1.1.jar:/Users/lilia/.m2/repository/org/springframework/security/spring-security-web/6.2.0/spring-security-web-6.2.0.jar:/Users/lilia/.m2/repository/org/springframework/spring-expression/6.1.1/spring-expression-6.1.1.jar:/Users/lilia/.m2/repository/io/jsonwebtoken/jjwt-api/0.11.5/jjwt-api-0.11.5.jar:/Users/lilia/.m2/repository/io/jsonwebtoken/jjwt-impl/0.11.5/jjwt-impl-0.11.5.jar:/Users/lilia/.m2/repository/io/jsonwebtoken/jjwt-jackson/0.11.5/jjwt-jackson-0.11.5.jar:/Users/lilia/.m2/repository/com/fasterxml/jackson/core/jackson-databind/2.15.3/jackson-databind-2.15.3.jar:/Users/lilia/.m2/repository/com/fasterxml/jackson/core/jackson-annotations/2.15.3/jackson-annotations-2.15.3.jar:/Users/lilia/.m2/repository/com/fasterxml/jackson/core/jackson-core/2.15.3/jackson-core-2.15.3.jar:/Users/lilia/.m2/repository/org/projectlombok/lombok/1.18.32/lombok-1.18.32.jar:/Users/lilia/.m2/repository/org/springframework/boot/spring-boot-starter-test/3.2.0/spring-boot-starter-test-3.2.0.jar:/Users/lilia/.m2/repository/org/springframework/boot/spring-boot-test/3.2.0/spring-boot-test-3.2.0.jar:/Users/lilia/.m2/repository/org/springframework/boot/spring-boot-test-autoconfigure/3.2.0/spring-boot-test-autoconfigure-3.2.0.jar:/Users/lilia/.m2/repository/com/jayway/jsonpath/json-path/2.8.0/json-path-2.8.0.jar:/Users/lilia/.m2/repository/org/slf4j/slf4j-api/2.0.9/slf4j-api-2.0.9.jar:/Users/lilia/.m2/repository/jakarta/xml/bind/jakarta.xml.bind-api/4.0.1/jakarta.xml.bind-api-4.0.1.jar:/Users/lilia/.m2/repository/jakarta/activation/jakarta.activation-api/2.1.2/jakarta.activation-api-2.1.2.jar:/Users/lilia/.m2/repository/net/minidev/json-smart/2.5.0/json-smart-2.5.0.jar:/Users/lilia/.m2/repository/net/minidev/accessors-smart/2.5.0/accessors-smart-2.5.0.jar:/Users/lilia/.m2/repository/org/ow2/asm/asm/9.3/asm-9.3.jar:/Users/lilia/.m2/repository/org/assertj/assertj-core/3.24.2/assertj-core-3.24.2.jar:/Users/lilia/.m2/repository/net/bytebuddy/byte-buddy/1.14.10/byte-buddy-1.14.10.jar:/Users/lilia/.m2/repository/org/awaitility/awaitility/4.2.0/awaitility-4.2.0.jar:/Users/lilia/.m2/repository/org/hamcrest/hamcrest/2.2/hamcrest-2.2.jar:/Users/lilia/.m2/repository/org/junit/jupiter/junit-jupiter/5.10.1/junit-jupiter-5.10.1.jar:/Users/lilia/.m2/repository/org/junit/jupiter/junit-jupiter-params/5.10.1/junit-jupiter-params-5.10.1.jar:/Users/lilia/.m2/repository/org/junit/jupiter/junit-jupiter-engine/5.10.1/junit-jupiter-engine-5.10.1.jar:/Users/lilia/.m2/repository/org/junit/platform/junit-platform-engine/1.10.1/junit-platform-engine-1.10.1.jar:/Users/lilia/.m2/repository/org/mockito/mockito-core/5.5.0/mockito-core-5.5.0.jar:/Users/lilia/.m2/repository/net/bytebuddy/byte-buddy-agent/1.14.10/byte-buddy-agent-1.14.10.jar:/Users/lilia/.m2/rep