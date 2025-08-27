#!/bin/bash

echo "Testing Dungeon Game API..."

# Test 1: Small dungeon
echo "1. Small dungeon test"
curl -s -X POST http://localhost:8080/api/dungeon/calculate \
  -H "Content-Type: application/json" \
  -d '{"dungeon": [[-2, -3, 3], [-5, -10, 1], [10, 30, -5]]}' | jq . 2>/dev/null || echo "Response received"

# Test 2: Medium dungeon  
echo -e "\n2. Medium dungeon test"
curl -s -X POST http://localhost:8080/api/dungeon/calculate \
  -H "Content-Type: application/json" \
  -d '{"dungeon": [[-1, -3, 3, 2, -4], [-5, -10, 1, 6, -2], [10, 30, -5, 1, 3], [-2, 4, -1, 5, -3], [1, -2, 3, -4, 5]]}' | jq . 2>/dev/null || echo "Response received"

# Test 3: Health check
echo -e "\n3. Health check"
curl -s http://localhost:8080/actuator/health | jq . 2>/dev/null || echo "Health check completed"

echo -e "\n✅ API tests completed"
