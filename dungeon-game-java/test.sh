#!/bin/bash

echo "🧪 Dungeon Game Testing Suite"

show_menu() {
    echo ""
    echo "Available tests:"
    echo "1. API Tests - Test REST endpoints"
    echo "2. Load Test - Basic performance test"
    echo "3. Stress Test - High load capacity test"
    echo "4. All Tests - Run API + Performance tests"
    echo ""
    read -p "Choose option (1-4): " choice
}

run_api_tests() {
    echo "Running API tests..."
    
    # Test 1: Small dungeon
    echo "→ Small dungeon test"
    curl -s -X POST http://localhost:8080/api/dungeon/calculate \
      -H "Content-Type: application/json" \
      -d '{"dungeon": [[-2, -3, 3], [-5, -10, 1], [10, 30, -5]]}' | jq . 2>/dev/null || echo "  Response received"

    # Test 2: Medium dungeon  
    echo "→ Medium dungeon test"
    curl -s -X POST http://localhost:8080/api/dungeon/calculate \
      -H "Content-Type: application/json" \
      -d '{"dungeon": [[-1, -3, 3, 2, -4], [-5, -10, 1, 6, -2], [10, 30, -5, 1, 3], [-2, 4, -1, 5, -3], [1, -2, 3, -4, 5]]}' | jq . 2>/dev/null || echo "  Response received"

    # Test 3: Health check
    echo "→ Health check"
    curl -s http://localhost:8080/actuator/health | jq . 2>/dev/null || echo "  Health check completed"
    
    echo "✅ API tests completed"
}

run_performance_test() {
    local test_class=$1
    local description=$2
    
    echo "Running: $description"
    mvn gatling:test -Dgatling.simulationClass=$test_class -q
    
    if [ $? -eq 0 ]; then
        echo "✅ $description completed"
        
        # Try to export metrics if monitoring is available
        if curl -s http://localhost:9091/metrics > /dev/null 2>&1; then
            echo "→ Exporting metrics to monitoring..."
            python3 export-gatling-metrics.py
        fi
    else
        echo "❌ $description failed"
        return 1
    fi
}

show_menu

case $choice in
    1)
        run_api_tests
        ;;
    2)
        run_performance_test "DungeonGameBasicLoadTest" "Basic Load Test"
        ;;
    3)
        run_performance_test "DungeonGameStressTest" "Stress Test"
        ;;
    4)
        echo "Running all tests..."
        run_api_tests
        echo ""
        run_performance_test "DungeonGameBasicLoadTest" "Basic Load Test"
        if [ $? -eq 0 ]; then
            echo ""
            run_performance_test "DungeonGameStressTest" "Stress Test"
        fi
        ;;
    *)
        echo "Invalid option"
        exit 1
        ;;
esac

echo ""
if [[ $choice =~ ^[234]$ ]]; then
    echo "📊 Performance reports: target/gatling/"
fi
echo "🔗 For monitoring setup: ./setup-monitoring.sh"
