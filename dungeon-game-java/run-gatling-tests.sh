#!/bin/bash

echo "🎯 Dungeon Game Gatling Stress Tests"
echo "===================================="

# Function to run specific test
run_test() {
    local test_name=$1
    local description=$2
    
    echo ""
    echo "🚀 Running: $description"
    echo "================================================"
    
    mvn gatling:test -Dgatling.simulationClass=$test_name
    
    if [ $? -eq 0 ]; then
        echo "✅ Test $test_name completed successfully!"
    else
        echo "❌ Test $test_name failed!"
        return 1
    fi
}

# Main menu
show_menu() {
    echo ""
    echo "Choose the type of test:"
    echo "1) Basic Load Test (DungeonGameBasicLoadTest)"
    echo "2) Intensive Stress Test (DungeonGameStressTest)"
    echo "3) Red Team - DoS Attack Test (DungeonGameRedTeamTest)"
    echo "4) Red Team - Extreme Stress Test with Large Matrices (DungeonGameRedTeamTestNew)"
    echo "5) Run ALL tests in sequence"
    echo "0) Exit"
    echo ""
    read -p "Enter your option [0-6]: " choice
}

# Main menu loop
while true; do
    show_menu
    
    case $choice in
        1)
            run_test "DungeonGameBasicLoadTest" "Basic Load Test - 10-20 users for 2 minutes"
            ;;
        2)
            run_test "DungeonGameStressTest" "Intensive Stress Test - up to 200 users for 10 minutes"
            ;;
        3)
            echo "⚠️  WARNING: This is a Red Team attack test!"
            echo "   It may intentionally overload the application."
            read -p "   Are you sure you want to continue? (y/N): " confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                run_test "DungeonGameRedTeamTest" "Red Team Test - DoS Attack Simulation"
            else
                echo "🛑 Test cancelled by user."
            fi
            ;;
        4)
            echo "⚠️  WARNING: This is a Red Team extreme stress test!"
            echo "   It will use large matrices and may crash the application."
            read -p "   Are you sure you want to continue? (y/N): " confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                run_test "DungeonGameRedTeamTestNew" "Red Team Extreme Test - Large Matrices"
            else
                echo "🛑 Test cancelled by user."
            fi
            ;;
        5)
            echo "🎯 Running ALL tests in sequence..."
            echo "⚠️  WARNING: This may take more than 20 minutes!"
            read -p "Continue? (y/N): " confirm
            if [[ $confirm =~ ^[Yy]$ ]]; then
                run_test "DungeonGameBasicLoadTest" "1/4 - Basic Test"
                sleep 30  # Pause between tests
                run_test "DungeonGameStressTest" "2/4 - Stress Test"
                sleep 60  # Longer pause before attack
                run_test "DungeonGameRedTeamTest" "3/4 - Red Team Test"
                sleep 10  # Shorter pause before extreme test
                run_test "DungeonGameRedTeamTestNew" "4/4 - Red Team Extreme Test"
                echo "🏁 All tests completed!"
            else
                echo "🛑 Batch execution cancelled."
            fi
            ;;
        0)health
            echo "👋 Exiting..."
            exit 0
            ;;
        *)
            echo "❌ Invalid option. Please try again."
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
done
