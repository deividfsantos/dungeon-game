import io.gatling.core.Predef._
import io.gatling.core.structure.ScenarioBuilder
import io.gatling.http.Predef._
import io.gatling.http.protocol.HttpProtocolBuilder

import scala.concurrent.duration._

class DungeonGameStressTest extends Simulation {

  val httpProtocol: HttpProtocolBuilder = http
    .baseUrl("http://localhost:8080")
    .acceptHeader("application/json")
    .contentTypeHeader("application/json")
    .userAgentHeader("Gatling-StressTest")

  // Valid payloads for stress testing
  val smallDungeon = """{"dungeon": [[-2, -3, 3], [-5, -10, 1], [10, 30, -5]]}"""
  val mediumDungeon = """{"dungeon": [[-1, -3, 3, 2, -4], [-5, -10, 1, 6, -2], [10, 30, -5, 1, 3], [-2, 4, -1, 5, -3], [1, -2, 3, -4, 5]]}"""

  // Large dungeon for stress testing (10x10)
  val largeDungeon = """{"dungeon": [[-10, -20, 30, 15, -25, 40, -5, 12, 8, -18], [22, -30, 35, -8, 20, -15, -12, 25, -40, 50], [-10, 18, -22, 30, 35, -45, 20, -25, 40, -12], [15, -35, -20, 30, -50, 25, -15, 35, -40, 20], [10, -25, 40, -30, 15, -20, 35, -10, -30, 45], [-20, 25, -40, 15, -25, 50, 20, -35, 40, -15], [25, -30, 10, -45, -50, 35, -20, 25, -40, 15], [-25, 30, -35, 20, -15, 40, -30, 10, -25, 35], [40, -20, 15, -35, 25, -40, 30, -10, 20, -45], [-30, 35, -25, 40, -15, 25, -50, 20, -35, 30]]}"""

  // High-load scenario with rapid requests
  val highLoadScenario: ScenarioBuilder = scenario("High Load Test")
    .repeat(50) {
      exec(
        http("Calculate Request")
          .post("/api/dungeon/calculate")
          .body(StringBody(session => {
            scala.util.Random.nextInt(10) match {
              case n if n < 5 => smallDungeon
              case n if n < 8 => mediumDungeon  
              case _ => largeDungeon
            }
          }))
          .check(status.in(200, 429, 500))
          .check(responseTimeInMillis.lt(30000))
      )
      .pause(100.milliseconds, 500.milliseconds)
    }

  // Sustained load scenario with concurrent users
  val sustainedLoadScenario: ScenarioBuilder = scenario("Sustained Load Test")
    .repeat(25) {
      exec(
        http("Sustained Request")
          .post("/api/dungeon/calculate")
          .body(StringBody(mediumDungeon))
          .check(status.in(200, 429, 500))
      )
      .pause(1, 3)
    }

  setUp(
    // Phase 1: High load with mixed payloads
    highLoadScenario.inject(
      rampUsers(50) during (1.minute),
      constantUsersPerSec(25) during (2.minutes)
    ),
    
    // Phase 2: Sustained load test
    sustainedLoadScenario.inject(
      constantUsersPerSec(10) during (3.minutes)
    )
  ).protocols(httpProtocol)
    .maxDuration(5.minutes)
    .assertions(
      global.responseTime.max.lt(35000),
      global.responseTime.mean.lt(10000),
      global.successfulRequests.percent.gt(80)
    )
}
