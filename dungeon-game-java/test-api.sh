#!/bin/bash

echo "Testing Dungeon Game API locally..."

# Start the Spring Boot application in the background
echo "Starting Spring Boot application..."
cd /Users/dsantos/Documents/projects/dsantos/dungeon-game/dungeon-game-java

# Set environment variables for H2 in-memory database (for testing without PostgreSQL)
export SPRING_PROFILES_ACTIVE=test
export SPRING_DATASOURCE_URL=jdbc:h2:mem:testdb
export SPRING_DATASOURCE_DRIVER_CLASS_NAME=org.h2.Driver
export SPRING_JPA_HIBERNATE_DDL_AUTO=create-drop

java --enable-preview -jar target/dungeon-game-1.0-SNAPSHOT.jar &
APP_PID=$!

echo "Waiting for application to start..."
sleep 10

echo "Testing API endpoints..."

# Test health endpoint
echo "1. Testing health endpoint..."
curl -s http://localhost:8080/api/dungeon/health | jq . || echo "Health endpoint test"

# Test calculation endpoint
echo -e "\n2. Testing dungeon calculation..."
curl -s -X POST http://localhost:8080/api/dungeon/calculate \
  -H "Content-Type: application/json" \
  -d '{"dungeon": [[-2, -3, 3], [-5, -10, 1], [10, 30, -5]]}' | jq . || echo "Calculation test"

# Test results endpoint
echo -e "\n3. Testing results endpoint..."
curl -s http://localhost:8080/api/dungeon/results?hours=1 | jq . || echo "Results test"

# Test stats endpoint
echo -e "\n4. Testing stats endpoint..."
curl -s http://localhost:8080/api/dungeon/stats?hours=1 | jq . || echo "Stats test"

echo -e "\nStopping application..."
kill $APP_PID

echo "Local API testing completed!"
