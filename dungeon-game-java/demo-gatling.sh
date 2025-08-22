#!/bin/bash

echo "🎯 Gatling Demo - Dungeon Game API"
echo "=================================="

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

print_color() {
    printf "${1}${2}${NC}\n"
}

print_color $BLUE "📋 Checking prerequisites..."

java_version=$(java -version 2>&1 | head -n 1)
if [[ $java_version == *"23"* ]]; then
    print_color $GREEN "✅ Java 23 detected"
else
    print_color $RED "❌ Java 23 not found"
    exit 1
fi

if command -v mvn &> /dev/null; then
    print_color $GREEN "✅ Maven detected"
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
    exit 1
fi

print_color $BLUE "\n📦 Building JAR..."
if mvn package -DskipTests -q; then
    print_color $GREEN "✅ JAR built successfully"
else
    print_color $RED "❌ JAR build failed"
    exit 1
fi

print_color $BLUE "\n🚀 Starting application..."
java --enable-preview -jar target/dungeon-game-1.0-SNAPSHOT.jar > app.log 2>&1 &
APP_PID=$!

print_color $BLUE "⏳ Waiting for application..."
sleep 20

print_color $BLUE "\n🧪 Testing API..."
response=$(curl -s -X POST http://localhost:8080/api/dungeon/calculate \
    -H "Content-Type: application/json" \
    -d '{"dungeon": [[-2, -3, 3], [-5, -10, 1], [10, 30, -5]]}')

if echo "$response" | grep -q "minimumHp.*7"; then
    print_color $GREEN "✅ API test passed (Minimum HP: 7)"
else
    print_color $RED "❌ API test failed: $response"
fi

print_color $BLUE "\n⚡ Running Gatling test..."
if mvn gatling:test -Dgatling.simulationClass=DungeonGameBasicLoadTest -q; then
    print_color $GREEN "✅ Gatling test completed!"
    
    latest_report=$(find target/gatling -name "index.html" -type f -exec ls -t1 {} + | head -1)
    if [ -n "$latest_report" ]; then
        print_color $BLUE "📊 Report: $latest_report"
    fi
else
    print_color $RED "❌ Gatling test failed"
fi

print_color $BLUE "\n🛑 Stopping application..."
kill $APP_PID 2>/dev/null

print_color $GREEN "\n🎉 Demo completed!"
print_color $BLUE "📋 Next: Run ./run-gatling-tests.sh for full Red Team tests"
