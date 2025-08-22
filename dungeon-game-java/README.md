# Dungeon Game API

A Java 23 Spring Boot solution for the [LeetCode Dungeon Game problem](https://leetcode.com/problems/dungeon-game/description/) with REST API, PostgreSQL persistence, and comprehensive stress testing capabilities.

## Challenge Overview

**Testing Kata**: Implement the Dungeon Game algorithm in Java 23, containerize with Docker, provide REST interface, save results in PostgreSQL, and enable Red Team stress testing.

The Dungeon Game calculates the minimum initial health required for a knight to rescue a princess, using dynamic programming to work backwards from the destination.

## Quick Start

1. **Build and start services:**
```bash
./start.sh
```

2. **Test the API:**
```bash
./test-api.sh
```

3. **Run stress tests:**
```bash
./run-gatling-tests.sh
```

## API Usage

**Calculate minimum HP:**
```bash
curl -X POST http://localhost:8080/api/dungeon/calculate \
  -H "Content-Type: application/json" \
  -d '{"dungeon": [[-2, -3, 3], [-5, -10, 1], [10, 30, -5]]}'
```

**Get results:** `GET /api/dungeon/results?hours=24`  
**Get stats:** `GET /api/dungeon/stats?hours=24`

## Stress Testing

The application includes comprehensive Gatling tests designed for Red Team scenarios:

- **Basic Load Test**: Normal operation validation (10-20 users, 2 minutes)
- **Stress Test**: Scalability limits (up to 200 users, 10 minutes) 
- **Red Team Tests**: DoS simulation and extreme load with large matrices

**Run tests:** `./run-gatling-tests.sh`  
**Reports:** Generated in `target/gatling/` with detailed performance metrics

## Technical Details

**Algorithm Complexity:**
- Time: O(m × n)
- Space: O(m × n)

**Docker Environment:**
- Java 23 application
- PostgreSQL database
- Configurable via environment variables

**Database:** Auto-created `game_results` table stores dungeon inputs, results, and performance metrics.
