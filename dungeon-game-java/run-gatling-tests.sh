#!/bin/bash

echo "🎯 Gatling Performance Tests"

run_test() {
    local test_name=$1
    local description=$2
    
    echo "Running: $description"
    mvn gatling:test -Dgatling.simulationClass=$test_name -q
    
    if [ $? -eq 0 ]; then
        echo "✅ $test_name completed"
    else
        echo "❌ $test_name failed"
        return 1
    fi
}

echo ""
echo "Available tests:"
echo "1. Basic Load Test (recommended)"
echo "2. Stress Test"
echo "3. Both tests"
echo ""
read -p "Choose option (1-3): " choice

case $choice in
    1)
        run_test "DungeonGameBasicLoadTest" "Basic Load Test"
        ;;
    2)
        run_test "DungeonGameStressTest" "Stress Test"
        ;;
    3)
        run_test "DungeonGameBasicLoadTest" "Basic Load Test"
        if [ $? -eq 0 ]; then
            run_test "DungeonGameStressTest" "Stress Test"
        fi
        ;;
    *)
        echo "Invalid option"
        exit 1
        ;;
esac

echo ""
echo "📊 Reports available in: target/gatling/"
echo "🔗 For monitoring: ./start-monitoring.sh"
