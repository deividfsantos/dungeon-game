#!/bin/bash

echo "Starting Dungeon Game API..."

echo "Cleaning up existing containers..."
docker compose down -v 2>/dev/null || true

mvn clean package -q

if [ $? -eq 0 ]; then
    echo "✅ Build successful"
    docker compose up -d
    
    if [ $? -eq 0 ]; then
        echo "✅ Services started"
        echo ""
        echo "🔗 API: http://localhost:8080/api/dungeon/calculate"
        echo "🔍 Health: http://localhost:8080/actuator/health"
        echo ""
        echo "🛑 To stop: docker compose down"
    else
        echo "❌ Failed to start services"
        exit 1
    fi
else
    echo "❌ Build failed"
    exit 1
fi
