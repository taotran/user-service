# Build stage
FROM maven:3.8.2 AS build
WORKDIR /workspace
COPY pom.xml ./
COPY src ./src
RUN mvn -DskipTests package -q

# Runtime stage
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app
COPY --from=build /workspace/target/user-service-0.0.1-SNAPSHOT.jar ./app.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
