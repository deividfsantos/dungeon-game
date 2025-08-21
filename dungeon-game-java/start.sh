#!/bin/bash

echo "Building Dungeon Game API..."

# Clean and build the project
mvn clean package

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "Build successful!"
    echo "Starting services with Docker Compose..."
    
    # Try docker compose first (newer), then docker-compose (older)
    if command -v docker &> /dev/null; then
        if docker compose version &> /dev/null; then
            docker compose up -d
        elif command -v docker-compose &> /dev/null; then
            docker-compose up -d
        else
            echo "Neither 'docker compose' nor 'docker-compose' found. Please install Docker Compose."
            exit 1
        fi
    else
        echo "Docker not found. Please install Docker."
        exit 1
    fi
    
    echo "Waiting for services to start..."
    sleep 15
    
    echo "API is ready at http://localhost:8080"
    echo "PostgreSQL is ready at localhost:5432"
else
    echo "Build failed!"
    exit 1
fi
