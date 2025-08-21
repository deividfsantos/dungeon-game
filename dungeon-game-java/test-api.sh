#!/bin/bash

echo "Testing Dungeon Game API locally..."

# Test calculation endpoint with small dungeon
echo -e "\n2. Testing small dungeon calculation..."
curl -s -X POST http://localhost:8080/api/dungeon/calculate \
  -H "Content-Type: application/json" \
  -d '{"dungeon": [[-2, -3, 3], [-5, -10, 1], [10, 30, -5]]}' | jq . || echo "Small dungeon test"

# Test calculation endpoint with medium dungeon (5x5)
echo -e "\n3. Testing medium dungeon calculation (5x5)..."
curl -s -X POST http://localhost:8080/api/dungeon/calculate \
  -H "Content-Type: application/json" \
  -d '{"dungeon": [[-1, -3, 3, 2, -4], [-5, -10, 1, 6, -2], [10, 30, -5, 1, 3], [-2, 4, -1, 5, -3], [1, -2, 3, -4, 5]]}' | jq . || echo "Medium dungeon test"

# Test calculation endpoint with large dungeon (8x8)
echo -e "\n4. Testing large dungeon calculation (8x8)..."
curl -s -X POST http://localhost:8080/api/dungeon/calculate \
  -H "Content-Type: application/json" \
  -d '{"dungeon": [[-1, -2, -3, -4, -5, -6, -7, -8], [-9, -10, 1, 2, 3, 4, 5, 6], [7, 8, 9, 10, -1, -2, -3, -4], [-5, -6, -7, -8, -9, -10, 1, 2], [3, 4, 5, 6, 7, 8, 9, 10], [-1, -2, -3, -4, -5, -6, -7, -8], [1, 2, 3, 4, 5, 6, 7, 8], [-9, -10, -11, -12, -13, -14, -15, 16]]}' | jq . || echo "Large dungeon test"

# Test calculation endpoint with massive dungeon (12x12) - High resource consumption
echo -e "\n5. Testing massive dungeon calculation (12x12) - This may take longer..."
curl -s -X POST http://localhost:8080/api/dungeon/calculate \
  -H "Content-Type: application/json" \
  -d '{"dungeon": [[-5, 10, -15, 20, -25, 30, -35, 40, -45, 50, -55, 60], [5, -10, 15, -20, 25, -30, 35, -40, 45, -50, 55, -60], [-10, 20, -30, 40, -50, 60, -70, 80, -90, 100, -110, 120], [15, -25, 35, -45, 55, -65, 75, -85, 95, -105, 115, -125], [-20, 30, -40, 50, -60, 70, -80, 90, -100, 110, -120, 130], [25, -35, 45, -55, 65, -75, 85, -95, 105, -115, 125, -135], [-30, 40, -50, 60, -70, 80, -90, 100, -110, 120, -130, 140], [35, -45, 55, -65, 75, -85, 95, -105, 115, -125, 135, -145], [-40, 50, -60, 70, -80, 90, -100, 110, -120, 130, -140, 150], [45, -55, 65, -75, 85, -95, 105, -115, 125, -135, 145, -155], [-50, 60, -70, 80, -90, 100, -110, 120, -130, 140, -150, 160], [55, -65, 75, -85, 95, -105, 115, -125, 135, -145, 155, -165]]}' | jq . || echo "Massive dungeon test"

# Test results endpoint
echo -e "\n6. Testing results endpoint..."
curl -s http://localhost:8080/api/dungeon/results?hours=1 | jq . || echo "Results test"

# Test stats endpoint
echo -e "\n7. Testing stats endpoint..."
curl -s http://localhost:8080/api/dungeon/stats?hours=1 | jq . || echo "Stats test"

echo "Local API testing completed!"
