FROM openjdk:23-jdk-slim

WORKDIR /app

# Copy the jar file
COPY target/dungeon-game-1.0-SNAPSHOT.jar app.jar

# Expose the port
EXPOSE 8080

# Set JVM options for Java 23
ENV JAVA_OPTS="-Xmx512m -Xms256m --enable-preview"

# Run the application
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
