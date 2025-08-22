#!/bin/bash

echo "Testing Dungeon Game API..."

# Small dungeon test
echo "1. Small dungeon (3x3)..."
curl -s -X POST http://localhost:8080/api/dungeon/calculate \
  -H "Content-Type: application/json" \
  -d '{"dungeon": [[-2, -3, 3], [-5, -10, 1], [10, 30, -5]]}' | jq . || echo "Test completed"

# Medium dungeon test
echo -e "\n2. Medium dungeon (5x5)..."
curl -s -X POST http://localhost:8080/api/dungeon/calculate \
  -H "Content-Type: application/json" \
  -d '{"dungeon": [[-1, -3, 3, 2, -4], [-5, -10, 1, 6, -2], [10, 30, -5, 1, 3], [-2, 4, -1, 5, -3], [1, -2, 3, -4, 5]]}' | jq . || echo "Test completed"

# Large dungeon test
echo -e "\n3. Large dungeon (8x8)..."
curl -s -X POST http://localhost:8080/api/dungeon/calculate \
  -H "Content-Type: application/json" \
  -d '{"dungeon": [[-1, -2, -3, -4, -5, -6, -7, -8], [-9, -10, 1, 2, 3, 4, 5, 6], [7, 8, 9, 10, -1, -2, -3, -4], [-5, -6, -7, -8, -9, -10, 1, 2], [3, 4, 5, 6, 7, 8, 9, 10], [-1, -2, -3, -4, -5, -6, -7, -8], [1, 2, 3, 4, 5, 6, 7, 8], [-9, -10, -11, -12, -13, -14, -15, 16]]}' | jq . || echo "Test completed"

# Results endpoint
echo -e "\n4. Testing results endpoint..."
curl -s http://localhost:8080/api/dungeon/results?hours=1 | jq . || echo "Test completed"

# Stats endpoint
echo -e "\n5. Testing stats endpoint..."
curl -s http://localhost:8080/api/dungeon/stats?hours=1 | jq . || echo "Test completed"

echo -e "\n✅ API testing completed!"
