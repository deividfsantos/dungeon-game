import io.gatling.core.Predef._
import io.gatling.core.structure.ScenarioBuilder
import io.gatling.http.Predef._
import io.gatling.http.protocol.HttpProtocolBuilder

import scala.concurrent.duration._

class DungeonGameBasicLoadTestWithMetrics extends Simulation {

  val httpProtocol: HttpProtocolBuilder = http
    .baseUrl("http://localhost:8080") // Use host.docker.internal to reach host from container
    .acceptHeader("application/json")
    .contentTypeHeader("application/json")

  val smallDungeonPayloads = List(
    """{"dungeon": [[-2, -3, 3], [-5, -10, 1], [10, 30, -5]]}""",
    """{"dungeon": [[0]]}""",
    """{"dungeon": [[-2, -3, 3], [-5, -10, 1]]}"""
  )

  val mediumDungeonPayloads = List(
    """{"dungeon": [[-1, -3, 3, 2, -4], [-5, -10, 1, 6, -2], [10, 30, -5, 1, 3], [-2, 4, -1, 5, -3], [1, -2, 3, -4, 5]]}""",
    """{"dungeon": [[-3, 5, 1, 3, -2, 4], [-2, -3, 1, 5, 0, -1], [1, -3, -3, 4, 1, 2], [0, -2, -1, 2, -1, 3], [3, -5, 0, 1, -2, 4], [-1, 2, -3, 4, -5, 6]]}"""
  )

  val largeDungeonPayloads = List(
    """{"dungeon": [[-1, -2, -3, -4, -5, -6, -7, -8], [-9, -10, 1, 2, 3, 4, 5, 6], [7, 8, 9, 10, -1, -2, -3, -4], [-5, -6, -7, -8, -9, -10, 1, 2], [3, 4, 5, 6, 7, 8, 9, 10], [-1, -2, -3, -4, -5, -6, -7, -8], [1, 2, 3, 4, 5, 6, 7, 8], [-9, -10, -11, -12, -13, -14, -15, 16]]}""",
    """{"dungeon": [[-10, -20, 30, 15, -25, 40, -5, 12], [8, -18, 22, -30, 35, -8, 20, -15], [-12, 25, -40, 50, -10, 18, -22, 30], [35, -45, 20, -25, 40, -12, 15, -35], [-20, 30, -50, 25, -15, 35, -40, 20], [10, -25, 40, -30, 15, -20, 35, -10], [-30, 45, -20, 25, -40, 15, -25, 50], [20, -35, 40, -15, 25, -30, 10, -45]]}"""
  )

  def getRandomPayload: String = {
    val rand = scala.util.Random.nextInt(10)
    rand match {
      case n if n < 5 => smallDungeonPayloads(scala.util.Random.nextInt(smallDungeonPayloads.length))  // 50% small
      case n if n < 8 => mediumDungeonPayloads(scala.util.Random.nextInt(mediumDungeonPayloads.length)) // 30% medium
      case _ => largeDungeonPayloads(scala.util.Random.nextInt(largeDungeonPayloads.length))             // 20% large
    }
  }

  val scn: ScenarioBuilder = scenario("Basic Load Test with Metrics")
    .pause(1)
    .repeat(15) {
      exec(
        http("Calculate Dungeon")
          .post("/api/dungeon/calculate")
          .body(StringBody(_ => getRandomPayload))
          .check(status.is(200))
          .check(jsonPath("$.minimumHp").exists)
          .check(jsonPath("$.executionTimeMs").exists)
          .check(responseTimeInMillis.lt(5000))
      )
        .pause(1, 3)
    }

  setUp(
    scn.inject(
      nothingFor(5.seconds),
      rampUsers(10) during (30.seconds),
      constantUsersPerSec(5) during (60.seconds),
      rampUsers(20) during (30.seconds),
      constantUsersPerSec(10) during (60.seconds)
    )
  ).protocols(httpProtocol)
    .maxDuration(5.minutes)
    .assertions(
      global.responseTime.max.lt(5000),
      global.responseTime.mean.lt(1000),
      global.successfulRequests.percent.gt(95)
    )
}
