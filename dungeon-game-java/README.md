# Dungeon Game API

A Java 23 Spring Boot solution for the [LeetCode Dungeon Game problem](https://leetcode.com/problems/dungeon-game/description/) with REST API, PostgreSQL persistence, and comprehensive stress testing capabilities.

## Challenge Overview

**Testing Kata**: Implement the Dungeon Game algorithm in Java 23, containerize with Docker, provide REST interface, save results in PostgreSQL, and enable Red Team stress testing.

The Dungeon Game calculates the minimum initial health required for a knight to rescue a princess, using dynamic programming to work backwards from the destination.

## Quick Start

1. **Setup basic application:**
```bash
./setup.sh
```

2. **Run tests:**
```bash
./test.sh
```

3. **Setup with monitoring (Grafana + Prometheus):**
```bash
./setup-monitoring.sh
```

## API Usage

**Calculate minimum HP:**
```bash
curl -X POST http://localhost:8080/api/dungeon/calculate \
  -H "Content-Type: application/json" \
  -d '{"dungeon": [[-2, -3, 3], [-5, -10, 1], [10, 30, -5]]}'
```

**Get execution history:** `GET /api/dungeon/results?hours=24`  
**Get performance stats:** `GET /api/dungeon/stats?hours=24`

## Stress Testing

The application includes comprehensive Gatling-based performance tests designed to evaluate system behavior under various load conditions:

### Test Scenarios

**1. Basic Load Test (`DungeonGameBasicLoadTest.scala`)**
- **Purpose**: Validates normal operation and baseline performance
- **Load Pattern**: 10-20 concurrent users over 5 minutes
- **Dungeon Sizes**: Mixed small (3x3), medium (5x5), and large (8x8) dungeons
- **Assertions**: >95% success rate, <10s max response time, <3s mean response time
- **Use Case**: Functional validation and performance baseline establishment

**2. Stress Test (`DungeonGameStressTest.scala`)**
- **Purpose**: Tests system limits and performance degradation under high load
- **Load Pattern**: Up to 75 concurrent users over 5 minutes with sustained load phases
- **Dungeon Sizes**: Small (3x3), medium (5x5), and large (10x10) dungeons
- **Test Phases**:
  - High Load: Ramp to 50 users, sustain 25 RPS for 2 minutes
  - Sustained Load: 10 RPS for 3 minutes with medium dungeons
- **Assertions**: >80% success rate, <35s max response time, <10s mean response time
- **Use Case**: Capacity planning and stress testing under realistic high-load scenarios

### Running Tests

Execute all performance tests:
```bash
./run-gatling-tests.sh
```

Run individual test classes:
```bash
mvn gatling:test -Dgatling.simulationClass=DungeonGameBasicLoadTest
mvn gatling:test -Dgatling.simulationClass=DungeonGameStressTest
```

**Reports**: Detailed HTML reports generated in `target/gatling/` with response time percentiles, throughput metrics, and error analysis.

## Performance Monitoring

Complete monitoring stack with Gatling metrics integration:

### Quick Setup
```bash
./setup-monitoring.sh
```

### What You Get
- **Prometheus**: Metrics collection (http://localhost:9090)
- **Grafana**: Performance dashboards (http://localhost:3000 - admin/admin)
- **PushGateway**: Gatling metrics aggregation (http://localhost:9091)
- **Spring Actuator**: Application metrics (http://localhost:8080/actuator/prometheus)

### Manual Testing
```bash
# Run specific tests
./test.sh

# Or run performance tests directly
mvn gatling:test -Dgatling.simulationClass=DungeonGameBasicLoadTest

# Export metrics (if monitoring is running)
python3 export-gatling-metrics.py

# Stop services
docker compose down
```

### Monitored Metrics
- **Gatling**: Request rates, response times (P50, P95, P99), error rates
- **Application**: JVM metrics, HTTP requests, database connections

## Technical Implementation

**Algorithm Complexity:**
- Time Complexity: O(m × n) - Single pass through dungeon grid
- Space Complexity: O(m × n) - Dynamic programming table storage

**Architecture:**
- **Framework**: Java 23 with Spring Boot 3.x
- **Algorithm**: Dynamic Programming (bottom-up approach)
- **Database**: PostgreSQL with JPA/Hibernate
- **Testing**: Gatling for performance testing
- **Containerization**: Docker with multi-stage builds

**Performance Features:**
- Optimized DP algorithm with minimal memory allocations
- Database connection pooling for concurrent requests  
- Execution metrics tracking for performance analysis
- Configurable via environment variables for different environments

**Database Schema:** 
Auto-created `game_results` table stores dungeon configurations, calculated results, execution timestamps, and performance metrics for historical analysis.
