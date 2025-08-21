#!/bin/bash

echo "🎯 Gatling Stress Tests Demo - Dungeon Game API"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print with color
print_color() {
    printf "${1}${2}${NC}\n"
}

print_color $BLUE "📋 Checking prerequisites..."

# Check if Java 23 is installed
java_version=$(java -version 2>&1 | head -n 1)
if [[ $java_version == *"23"* ]]; then
    print_color $GREEN "✅ Java 23 detected: $java_version"
else
    print_color $RED "❌ Java 23 not found. Current version: $java_version"
    exit 1
fi

# Check if Maven is installed
if command -v mvn &> /dev/null; then
    mvn_version=$(mvn -version | head -n 1)
    print_color $GREEN "✅ Maven detected: $mvn_version"
else
    print_color $RED "❌ Maven not found"
    exit 1
fi

print_color $BLUE "\n🔨 Compiling project..."
if mvn clean compile -q; then
    print_color $GREEN "✅ Compilation successful"
else
    print_color $RED "❌ Compilation failed"
    exit 1
fi

print_color $BLUE "\n🧪 Running unit tests..."
if mvn test -q; then
    print_color $GREEN "✅ Unit tests passed"
else
    print_color $RED "❌ Unit tests failed"
    exit 1
fi

print_color $BLUE "\n📦 Building JAR..."
if mvn package -DskipTests -q; then
    print_color $GREEN "✅ JAR built successfully"
else
    print_color $RED "❌ JAR build failed"
    exit 1
fi

print_color $BLUE "\n🚀 Starting application in test mode..."
export SPRING_PROFILES_ACTIVE=test
export SPRING_DATASOURCE_URL=jdbc:h2:mem:testdb
export SPRING_DATASOURCE_DRIVER_CLASS_NAME=org.h2.Driver
export SPRING_JPA_HIBERNATE_DDL_AUTO=create-drop

# Start application in background
java --enable-preview -jar target/dungeon-game-1.0-SNAPSHOT.jar > app.log 2>&1 &
APP_PID=$!

print_color $YELLOW "⏳ Waiting for application to initialize (PID: $APP_PID)..."

# Wait for application to start
max_attempts=30
attempt=1
while [ $attempt -le $max_attempts ]; do
    if curl -s http://localhost:8080/api/dungeon/health > /dev/null 2>&1; then
        print_color $GREEN "✅ Application is responding!"
        break
    fi
    print_color $YELLOW "   Attempt $attempt/$max_attempts..."
    sleep 2
    ((attempt++))
done

if [ $attempt -gt $max_attempts ]; then
    print_color $RED "❌ Application did not start within expected time"
    kill $APP_PID 2>/dev/null
    exit 1
fi

print_color $BLUE "\n🧪 Testing API endpoints..."

# Basic endpoint testing
print_color $YELLOW "1. Testing health check..."
if curl -s http://localhost:8080/api/dungeon/health | grep -q "UP"; then
    print_color $GREEN "   ✅ Health check OK"
else
    print_color $RED "   ❌ Health check failed"
fi

print_color $YELLOW "2. Testing dungeon calculation..."
response=$(curl -s -X POST http://localhost:8080/api/dungeon/calculate \
    -H "Content-Type: application/json" \
    -d '{"dungeon": [[-2, -3, 3], [-5, -10, 1], [10, 30, -5]]}')

if echo "$response" | grep -q "minimumHp.*7"; then
    print_color $GREEN "   ✅ Calculation correct (Minimum HP: 7)"
else
    print_color $RED "   ❌ Calculation incorrect: $response"
fi

print_color $YELLOW "3. Testing results endpoint..."
if curl -s http://localhost:8080/api/dungeon/results | grep -q "\[\]"; then
    print_color $GREEN "   ✅ Results endpoint OK"
else
    print_color $RED "   ❌ Results endpoint failed"
fi

print_color $BLUE "\n⚡ Running basic Gatling test..."
print_color $YELLOW "   Starting DungeonGameBasicLoadTest..."

if mvn gatling:test -Dgatling.simulationClass=DungeonGameBasicLoadTest -q; then
    print_color $GREEN "✅ Basic Gatling test completed successfully!"
    
    # Find the most recent report
    latest_report=$(find target/gatling -name "index.html" -type f -exec ls -t1 {} + | head -1)
    if [ -n "$latest_report" ]; then
        print_color $BLUE "📊 Report available at: $latest_report"
        print_color $YELLOW "   To view: open $latest_report"
    fi
else
    print_color $RED "❌ Gatling test failed"
fi

print_color $BLUE "\n🛑 Stopping application..."
kill $APP_PID 2>/dev/null
wait $APP_PID 2>/dev/null

print_color $GREEN "\n🎉 Demo completed successfully!"
print_color $BLUE "\n📋 Next steps for Red Team:"
print_color $YELLOW "   1. Run: ./run-gatling-tests.sh"
print_color $YELLOW "   2. Choose Red Team test (option 3)"
print_color $YELLOW "   3. Analyze reports in target/gatling/"
print_color $YELLOW "   4. Use docker compose up -d for full environment"

print_color $BLUE "\n📚 Complete documentation available in README.md"
