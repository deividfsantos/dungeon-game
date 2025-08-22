#!/bin/bash

echo "Building and starting Dungeon Game API..."

mvn clean package

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "Starting services..."
    
    if command -v docker &> /dev/null; then
        if docker compose version &> /dev/null; then
            docker compose up -d
        elif command -v docker-compose &> /dev/null; then
            docker-compose up -d
        else
            echo "❌ Docker Compose not found"
            exit 1
        fi
    else
        echo "❌ Docker not found"
        exit 1
    fi
    
    sleep 15
    echo "🚀 API ready at http://localhost:8080"
else
    echo "❌ Build failed!"
    exit 1
fi
