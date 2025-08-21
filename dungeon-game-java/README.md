# Dungeon Game API

A Java 23 Spring Boot application that solves the LeetCode Dungeon Game problem with REST API and PostgreSQL integration.

## Problem Description

The Dungeon Game is a classic dynamic programming problem where you need to calculate the minimum initial health required for a knight to rescue a princess in a dungeon.

## Features

- **Java 23** with preview features enabled
- **REST API** endpoints for dungeon calculations
- **PostgreSQL** database for storing results
- **Docker** containerization
- **Performance metrics** and execution tracking
- **Stress test ready** for Gatling testing

## API Endpoints

### Calculate Minimum HP
```
POST /api/dungeon/calculate
Content-Type: application/json

{
  "dungeon": [
    [-2, -3, 3],
    [-5, -10, 1],
    [10, 30, -5]
  ]
}
```

Response:
```json
{
  "id": 1,
  "dungeonInput": "[[-2, -3, 3], [-5, -10, 1], [10, 30, -5]]",
  "minimumHp": 7,
  "executionTimeMs": 2,
  "createdAt": "2025-08-21T10:30:00"
}
```

### Get Recent Results
```
GET /api/dungeon/results?hours=24
```

### Get Performance Stats
```
GET /api/dungeon/stats?hours=24
```

### Health Check
```
GET /api/dungeon/health
```

## Quick Start

### Using Docker Compose (Recommended)

1. Build the application:
```bash
mvn clean package -DskipTests
```

2. Start the services:
```bash
docker-compose up -d
```

3. The API will be available at `http://localhost:8080`

### Local Development

1. Start PostgreSQL locally
2. Update `application.yml` with your database credentials
3. Run the application:
```bash
mvn spring-boot:run
```

## Testing

### Unit Tests
```bash
mvn test
```

### API Testing with curl
```bash
# Test the health endpoint
curl http://localhost:8080/api/dungeon/health

# Test calculation endpoint
curl -X POST http://localhost:8080/api/dungeon/calculate \
  -H "Content-Type: application/json" \
  -d '{"dungeon": [[-2, -3, 3], [-5, -10, 1], [10, 30, -5]]}'

# Get recent results
curl http://localhost:8080/api/dungeon/results?hours=1

# Get performance stats
curl http://localhost:8080/api/dungeon/stats?hours=1
```

## Stress Testing with Gatling

The application is designed to handle high load and provides performance metrics. Key endpoints for stress testing:

- `/api/dungeon/calculate` - Main calculation endpoint
- `/api/dungeon/health` - Health check for load balancer
- `/api/dungeon/stats` - Performance monitoring

## Database Schema

The application automatically creates the following table:

```sql
CREATE TABLE game_results (
    id BIGSERIAL PRIMARY KEY,
    dungeon_input TEXT,
    minimum_hp INTEGER,
    execution_time_ms BIGINT,
    created_at TIMESTAMP
);
```

## Configuration

Environment variables for Docker deployment:

- `DB_HOST` - Database host (default: localhost)
- `DB_PORT` - Database port (default: 5432)
- `DB_NAME` - Database name (default: dungeon_game)
- `DB_USERNAME` - Database username (default: postgres)
- `DB_PASSWORD` - Database password (default: postgres)
- `SERVER_PORT` - Application port (default: 8080)
- `SHOW_SQL` - Show SQL queries (default: false)
- `LOG_LEVEL` - Logging level (default: INFO)

## Algorithm Complexity

- **Time Complexity**: O(m × n) where m and n are the dimensions of the dungeon
- **Space Complexity**: O(m × n) for the DP table

The algorithm uses dynamic programming working backwards from the princess to the knight's starting position.
