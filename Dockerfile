# Build stage
FROM ubuntu:latest AS build

# Update and install dependencies
RUN apt-get update && apt-get install openjdk-17-jdk -y

# Set the working directory
WORKDIR /app

# Copy the entire project to the working directory
COPY . .

# Build the application
RUN ./gradlew bootJar --no-daemon

# Final stage
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Expose the port the application will run on
EXPOSE 8080

# Copy the JAR file from the build stage
COPY --from=build /app/build/libs/demo-1.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
