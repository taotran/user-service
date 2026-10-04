# Project instructions

## Overview

`user-service` is a Java 17 / Spring Boot 3.1.6 REST service built with Maven.
It serves static mock user data; there is currently no persistence layer.

## Project structure

- `src/main/java/com/example/userservice/UserServiceApplication.java` — application entry point and `/health` endpoint.
- `src/main/java/com/example/userservice/controller/UserController.java` — `/users` endpoint.
- `src/main/java/com/example/userservice/model/User.java` — JSON user model.
- `src/main/resources/application.properties` — server configuration (port `8081`, bound to `0.0.0.0`).
- `Dockerfile` — multi-stage Maven build and Java 17 runtime image.
- `Jenkinsfile`, `deploy.sh` — CI and Kind-based deployment.

The application explicitly disables Spring JDBC and JPA auto-configuration.
Although the JPA dependency is present in `pom.xml`, do not assume a database is
configured or that user data is persisted.

## Common commands

- Run locally: `mvn spring-boot:run`
- Run tests: `mvn test`
- Package the executable JAR: `mvn package`
- Run the packaged service: `java -jar target/user-service-0.0.1-SNAPSHOT.jar`
- Build the container image: `docker build -t user-service .`

The service listens on port `8081`; check it at `GET /health` and retrieve the
mock users at `GET /users`.

## Change guidance

- Keep Java code under the existing `com.example.userservice` package hierarchy.
- Follow the existing Spring MVC controller and plain Java model patterns.
- Preserve the current mock-data behavior unless a task explicitly calls for a
  backing store or API behavior change.
- Update or add tests under `src/test/java` when changing endpoint behavior.
- Deployment scripts assume specific Kind cluster and Kubernetes deployment
  names. Review those environment-specific values before changing or running
  deployment steps.
