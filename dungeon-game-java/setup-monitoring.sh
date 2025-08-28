#!/bin/bash

echo "🎮 Starting Dungeon Game Monitoring Stack..."

# Check Docker
if ! docker info &> /dev/null; then
    echo "❌ Docker is not running"
    exit 1
fi

# Install Python requests if needed
python3 -c "import requests" 2>/dev/null || pip3 install requests

# Clean up any existing containers
echo "Cleaning up existing containers..."
docker compose down -v 2>/dev/null || true

# Build application
echo "Building application..."
mvn clean install

# Start services
echo "Starting services..."
docker compose up -d

# Wait for services
echo "Waiting for services..."
sleep 20

echo ""
echo "✅ Setup complete!"
echo ""
echo "📊 Dashboards:"
echo "   Grafana: http://localhost:3000 (admin/admin)"
echo "   Prometheus: http://localhost:9090"
echo ""
echo "🔍 Application:"
echo "   API: http://localhost:8080/api/dungeon/calculate"
echo "   Health: http://localhost:8080/actuator/health"
echo ""

read -p "Run load test now? (y/N): " run_test

if [[ $run_test =~ ^[Yy]$ ]]; then
    echo "Running Gatling test..."
    mvn gatling:test -Dgatling.simulationClass=DungeonGameBasicLoadTestWithMetrics -q
    
    if [ $? -eq 0 ]; then
        echo "Exporting metrics..."
        python3 export-gatling-metrics.py
    fi
fi

echo ""
echo "🛑 To stop: docker compose down"
