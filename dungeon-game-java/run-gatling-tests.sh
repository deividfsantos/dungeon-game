#!/bin/bash

echo "🎯 Dungeon Game Gatling Tests"
echo "============================"

run_test() {
    local test_name=$1
    local description=$2
    
    echo ""
    echo "🚀 Running: $description"
    echo "================================"
    
    mvn gatling:test -Dgatling.simulationClass=$test_name
    
    if [ $? -eq 0 ]; then
        echo "✅ Test $test_name completed!"
    else
        echo "❌ Test $test_name failed!"
        return 1
    fi
}

show_menu() {
    echo ""
    echo "Choose test type:"
    echo "1) Basic Load Test"
    echo "2) Stress Test"
    echo "3) Red Team Attack Test"
    echo "4) Red Team Extreme Test"
    echo "5) Run ALL tests"
    echo "0) Exit"
    echo ""
    read -p "Enter option [0-5]: " choice
}

while true; do
    show_menu
    
    case $choice in
        1)
            run_test "DungeonGameBasicLoadTest" "Basic Load Test"
            ;;
        2)
            run_test "DungeonGameStressTest" "Stress Test"
            ;;
        3)
            run_test "DungeonGameRedTeamTest" "Red Team Attack Test"
            ;;
        4)
            run_test "DungeonGameRedTeamTestNew" "Red Team Extreme Test"
            ;;
        5)
            echo "🎯 Running ALL tests..."
            run_test "DungeonGameBasicLoadTest" "1/4 - Basic"
            sleep 30
            run_test "DungeonGameStressTest" "2/4 - Stress"
            sleep 60
            run_test "DungeonGameRedTeamTest" "3/4 - Red Team"
            sleep 10
            run_test "DungeonGameRedTeamTestNew" "4/4 - Extreme"
            echo "🏁 All tests completed!"
            ;;
        0)
            echo "👋 Exiting..."
            exit 0
            ;;
        *)
            echo "❌ Invalid option."
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
done
