# Build stage
FROM ubuntu:latest AS build
RUN apt-get update && apt-get install -y openjdk-17-jdk wget unzip

# Install Gradle
RUN wget https://services.gradle.org/distributions/gradle-7.6-bin.zip -P /tmp && \
    unzip -d /opt/gradle /tmp/gradle-*.zip && \
    ln -s /opt/gradle/gradle-7.6/bin/gradle /usr/bin/gradle

# Set the working directory
WORKDIR /app

# Copy source files
COPY . .

# Clean previous builds and build the project
RUN gradle clean bootJar --no-daemon

# Run stage
FROM openjdk:17-jdk-slim
WORKDIR /app

# Expose port
EXPOSE 8080

# Copy the jar file from the build stage
COPY --from=build /app/build/libs/demo-1.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
