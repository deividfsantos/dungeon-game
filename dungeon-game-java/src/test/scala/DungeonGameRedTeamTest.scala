import io.gatling.core.Predef._
import io.gatling.http.Predef._
import scala.concurrent.duration._

class DungeonGameRedTeamTest extends Simulation {

  val httpProtocol = http
    .baseUrl("http://localhost:8080")
    .acceptHeader("application/json")
    .contentTypeHeader("application/json")
    .userAgentHeader("RedTeam-Gatling-Attack")
    .disableFollowRedirect

  // Payloads maliciosos e de teste de limites
  val maliciousPayloads = List(
    """{"dungeon": null}""",
    """{"dungeon": []}""",
    """{"dungeon": [[]]}""",
    """{"invalid": "payload"}""",
    """{"dungeon": [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]]}""", // Large array
    """{"dungeon": [[-999999, 999999, -999999], [999999, -999999, 999999], [-999999, 999999, -999999]]}""" // Extreme values
  )

  val validPayload = """{"dungeon": [[-2, -3, 3], [-5, -10, 1], [10, 30, -5]]}"""

  // Teste de bombardeio rápido
  val rapidFireAttack = scenario("Rapid Fire Attack")
    .repeat(100) {
      exec(
        http("Rapid Request")
          .post("/api/dungeon/calculate")
          .body(StringBody(validPayload))
          .check(status.in(200, 400, 429, 500, 503))
      )
    }

  // Teste com payloads maliciosos
  val maliciousPayloadAttack = scenario("Malicious Payload Attack")
    .repeat(50) {
      exec(
        http("Malicious Request")
          .post("/api/dungeon/calculate")
          .body(StringBody(session => maliciousPayloads(scala.util.Random.nextInt(maliciousPayloads.length))))
          .check(status.in(200, 400, 422, 500))
      )
      .pause(100.milliseconds, 500.milliseconds)
    }

  // Teste de recursos simultâneos
  val resourceExhaustionAttack = scenario("Resource Exhaustion")
    .repeat(200) {
      exec(
        http("Heavy Calculation")
          .post("/api/dungeon/calculate")
          .body(StringBody("""{"dungeon": [[-1, -2, -3, -4, -5], [-6, -7, -8, -9, -10], [-11, -12, -13, -14, -15], [-16, -17, -18, -19, -20], [-21, -22, -23, -24, -25]]}"""))
          .check(status.in(200, 429, 500, 503))
      )
    }

  // Teste de endpoints simultâneos
  val multiEndpointAttack = scenario("Multi-Endpoint Attack")
    .repeat(30) {
      exec(
        http("Calculate")
          .post("/api/dungeon/calculate")
          .body(StringBody(validPayload))
          .check(status.in(200, 429, 500))
      )
      .exec(
        http("Get Results")
          .get("/api/dungeon/results?hours=24")
          .check(status.in(200, 429, 500))
      )
      .exec(
        http("Get Stats")
          .get("/api/dungeon/stats?hours=24")
          .check(status.in(200, 429, 500))
      )
      .exec(
        http("Health Check")
          .get("/api/dungeon/health")
          .check(status.in(200, 429, 500))
      )
      .pause(50.milliseconds, 200.milliseconds)
    }

  // Teste de conexões longas
  val slowLorisAttack = scenario("Slow Loris Style")
    .repeat(10) {
      exec(
        http("Slow Request")
          .post("/api/dungeon/calculate")
          .body(StringBody(validPayload))
          .check(status.in(200, 408, 429, 500, 503))
      )
      .pause(30.seconds)
    }

  setUp(
    // Ataques simultâneos em múltiplas frentes
    rapidFireAttack.inject(
      atOnceUsers(50),
      nothingFor(10.seconds),
      atOnceUsers(100),
      nothingFor(10.seconds),
      atOnceUsers(200)
    ),
    
    maliciousPayloadAttack.inject(
      constantUsersPerSec(10) during (2.minutes)
    ),
    
    resourceExhaustionAttack.inject(
      nothingFor(30.seconds),
      rampUsers(100) during (1.minute),
      constantUsersPerSec(50) during (2.minutes)
    ),
    
    multiEndpointAttack.inject(
      constantUsersPerSec(20) during (3.minutes)
    ),
    
    slowLorisAttack.inject(
      constantUsersPerSec(5) during (5.minutes)
    )
  ).protocols(httpProtocol)
    .maxDuration(5.minutes)
    .assertions(
      // Assertions mais relaxadas para teste de resistência
      global.responseTime.max.lt(30000),
      global.responseTime.mean.lt(10000),
      global.successfulRequests.percent.gt(70), // Aceita até 30% de falhas sob ataque
      details("Rapid Request").responseTime.percentile3.lt(15000),
      details("Calculate").successfulRequests.percent.gt(80)
    )
}
