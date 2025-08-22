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
    .acceptEncodingHeader("gzip, deflate")
    .userAgentHeader("Gatling Stress Test")

  // Small dungeons (1x1 to 3x3)
  val smallDungeon = """{"dungeon": [[0]]}"""
  val mediumDungeon = """{"dungeon": [[-2, -3, 3], [-5, -10, 1], [10, 30, -5]]}"""
  
  // Large dungeons (8x8 to 10x10) - More resource intensive
  val largeDungeon = """{"dungeon": [[-3, 5, 1, 3, -2, 4, -1, 2], [-2, -3, 1, 5, 0, -1, 3, -4], [1, -3, -3, 4, 1, 2, -5, 6], [0, -2, -1, 2, -1, 3, 4, -7], [3, -5, 0, 1, -2, 4, -3, 8], [-1, 2, -3, 4, -5, 6, 1, -9], [4, -6, 2, -7, 3, -8, 5, 10], [-2, 7, -4, 8, -6, 9, -3, 11]]}"""
  
  // Extra large dungeons (12x12) - High resource consumption
  val extraLargeDungeon = """{"dungeon": [[-5, 10, -15, 20, -25, 30, -35, 40, -45, 50, -55, 60], [5, -10, 15, -20, 25, -30, 35, -40, 45, -50, 55, -60], [-10, 20, -30, 40, -50, 60, -70, 80, -90, 100, -110, 120], [15, -25, 35, -45, 55, -65, 75, -85, 95, -105, 115, -125], [-20, 30, -40, 50, -60, 70, -80, 90, -100, 110, -120, 130], [25, -35, 45, -55, 65, -75, 85, -95, 105, -115, 125, -135], [-30, 40, -50, 60, -70, 80, -90, 100, -110, 120, -130, 140], [35, -45, 55, -65, 75, -85, 95, -105, 115, -125, 135, -145], [-40, 50, -60, 70, -80, 90, -100, 110, -120, 130, -140, 150], [45, -55, 65, -75, 85, -95, 105, -115, 125, -135, 145, -155], [-50, 60, -70, 80, -90, 100, -110, 120, -130, 140, -150, 160], [55, -65, 75, -85, 95, -105, 115, -125, 135, -145, 155, -165]]}"""
  
  // Massive dungeons (15x15) - Maximum stress test
  val massiveDungeon = """{"dungeon": [[-1, -2, -3, -4, -5, -6, -7, -8, -9, -10, -11, -12, -13, -14, -15], [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], [-2, -4, -6, -8, -10, -12, -14, -16, -18, -20, -22, -24, -26, -28, -30], [3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45], [-4, -8, -12, -16, -20, -24, -28, -32, -36, -40, -44, -48, -52, -56, -60], [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75], [-6, -12, -18, -24, -30, -36, -42, -48, -54, -60, -66, -72, -78, -84, -90], [7, 14, 21, 28, 35, 42, 49, 56, 63, 70, 77, 84, 91, 98, 105], [-8, -16, -24, -32, -40, -48, -56, -64, -72, -80, -88, -96, -104, -112, -120], [9, 18, 27, 36, 45, 54, 63, 72, 81, 90, 99, 108, 117, 126, 135], [-10, -20, -30, -40, -50, -60, -70, -80, -90, -100, -110, -120, -130, -140, -150], [11, 22, 33, 44, 55, 66, 77, 88, 99, 110, 121, 132, 143, 154, 165], [-12, -24, -36, -48, -60, -72, -84, -96, -108, -120, -132, -144, -156, -168, -180], [13, 26, 39, 52, 65, 78, 91, 104, 117, 130, 143, 156, 169, 182, 195], [-14, -28, -42, -56, -70, -84, -98, -112, -126, -140, -154, -168, -182, -196, -210]]}"""

  // Giant dungeons (20x20) - Extreme stress test
  val giantDungeon = """{"dungeon": [[-100, 200, -300, 400, -500, 600, -700, 800, -900, 1000, -1100, 1200, -1300, 1400, -1500, 1600, -1700, 1800, -1900, 2000], [100, -200, 300, -400, 500, -600, 700, -800, 900, -1000, 1100, -1200, 1300, -1400, 1500, -1600, 1700, -1800, 1900, -2000], [-200, 400, -600, 800, -1000, 1200, -1400, 1600, -1800, 2000, -2200, 2400, -2600, 2800, -3000, 3200, -3400, 3600, -3800, 4000], [300, -600, 900, -1200, 1500, -1800, 2100, -2400, 2700, -3000, 3300, -3600, 3900, -4200, 4500, -4800, 5100, -5400, 5700, -6000], [-400, 800, -1200, 1600, -2000, 2400, -2800, 3200, -3600, 4000, -4400, 4800, -5200, 5600, -6000, 6400, -6800, 7200, -7600, 8000], [500, -1000, 1500, -2000, 2500, -3000, 3500, -4000, 4500, -5000, 5500, -6000, 6500, -7000, 7500, -8000, 8500, -9000, 9500, -10000], [-600, 1200, -1800, 2400, -3000, 3600, -4200, 4800, -5400, 6000, -6600, 7200, -7800, 8400, -9000, 9600, -10200, 10800, -11400, 12000], [700, -1400, 2100, -2800, 3500, -4200, 4900, -5600, 6300, -7000, 7700, -8400, 9100, -9800, 10500, -11200, 11900, -12600, 13300, -14000], [-800, 1600, -2400, 3200, -4000, 4800, -5600, 6400, -7200, 8000, -8800, 9600, -10400, 11200, -12000, 12800, -13600, 14400, -15200, 16000], [900, -1800, 2700, -3600, 4500, -5400, 6300, -7200, 8100, -9000, 9900, -10800, 11700, -12600, 13500, -14400, 15300, -16200, 17100, -18000], [-1000, 2000, -3000, 4000, -5000, 6000, -7000, 8000, -9000, 10000, -11000, 12000, -13000, 14000, -15000, 16000, -17000, 18000, -19000, 20000], [1100, -2200, 3300, -4400, 5500, -6600, 7700, -8800, 9900, -11000, 12100, -13200, 14300, -15400, 16500, -17600, 18700, -19800, 20900, -22000], [-1200, 2400, -3600, 4800, -6000, 7200, -8400, 9600, -10800, 12000, -13200, 14400, -15600, 16800, -18000, 19200, -20400, 21600, -22800, 24000], [1300, -2600, 3900, -5200, 6500, -7800, 9100, -10400, 11700, -13000, 14300, -15600, 16900, -18200, 19500, -20800, 22100, -23400, 24700, -26000], [-1400, 2800, -4200, 5600, -7000, 8400, -9800, 11200, -12600, 14000, -15400, 16800, -18200, 19600, -21000, 22400, -23800, 25200, -26600, 28000], [1500, -3000, 4500, -6000, 7500, -9000, 10500, -12000, 13500, -15000, 16500, -18000, 19500, -21000, 22500, -24000, 25500, -27000, 28500, -30000], [-1600, 3200, -4800, 6400, -8000, 9600, -11200, 12800, -14400, 16000, -17600, 19200, -20800, 22400, -24000, 25600, -27200, 28800, -30400, 32000], [1700, -3400, 5100, -6800, 8500, -10200, 11900, -13600, 15300, -17000, 18700, -20400, 22100, -23800, 25500, -27200, 28900, -30600, 32300, -34000], [-1800, 3600, -5400, 7200, -9000, 10800, -12600, 14400, -16200, 18000, -19800, 21600, -23400, 25200, -27000, 28800, -30600, 32400, -34200, 36000], [1900, -3800, 5700, -7600, 9500, -11400, 13300, -15200, 17100, -19000, 20900, -22800, 24700, -26600, 28500, -30400, 32300, -34200, 36100, -38000]]}"""

  val feeder: Iterator[Map[String, String]] = Iterator.continually(Map(
    "dungeonSize" -> List("small", "medium", "large", "extraLarge", "massive", "giant")(scala.util.Random.nextInt(6)),
    "payload" -> {
      scala.util.Random.nextInt(100) match {
        case n if n < 20 => smallDungeon        // 20% small
        case n if n < 35 => mediumDungeon       // 15% medium  
        case n if n < 55 => largeDungeon        // 20% large
        case n if n < 75 => extraLargeDungeon   // 20% extra large
        case n if n < 90 => massiveDungeon      // 15% massive
        case _ => giantDungeon                  // 10% giant (most resource intensive)
      }
    }
  ))

  // Normal user scenario - mixed dungeon sizes
  val normalUser: ScenarioBuilder = scenario("Normal User")
    .feed(feeder)
    .exec(
      http("Calculate Dungeon - ${dungeonSize}")
        .post("/api/dungeon/calculate")
        .body(StringBody("${payload}"))
        .check(status.is(200))
        .check(responseTimeInMillis.lt(15000)) // Increased timeout for larger dungeons
        .check(jsonPath("$.minimumHp").exists)
    )
    .pause(2, 5)

  // Resource intensive user - focuses on larger dungeons
  val intensiveUser: ScenarioBuilder = scenario("Resource Intensive User")
    .feed(Iterator.continually(Map(
      "payload" -> List(extraLargeDungeon, massiveDungeon, giantDungeon)(scala.util.Random.nextInt(3))
    )))
    .repeat(3) {
      exec(
        http("Heavy Calculation")
          .post("/api/dungeon/calculate")
          .body(StringBody("${payload}"))
          .check(status.is(200))
          .check(responseTimeInMillis.lt(30000)) // Much longer timeout for massive dungeons
          .check(jsonPath("$.minimumHp").exists)
      )
      .pause(1.second, 3.seconds)
    }

  // Memory stress user - rapid large dungeons
  val memoryStressUser: ScenarioBuilder = scenario("Memory Stress User")
    .feed(Iterator.continually(Map(
      "payload" -> massiveDungeon
    )))
    .repeat(10) {
      exec(
        http("Memory Intensive Calculation")
          .post("/api/dungeon/calculate")
          .body(StringBody("${payload}"))
          .check(status.in(200, 429, 500, 503)) // Allow server errors under extreme load
      )
      .pause(500.milliseconds, 1.second)
    }

  val monitoringUser: ScenarioBuilder = scenario("Monitoring User")
    .repeat(20) {
      exec(
        http("Get Stats")
          .get("/api/dungeon/stats?hours=1")
          .check(status.is(200))
          .check(jsonPath("$.totalExecutions").exists)
      )
      .pause(10.seconds)
    }

  setUp(
    // Phase 1: Warm-up with small dungeons
    normalUser.inject(rampUsers(30) during (1.minute)),
    
    // Phase 2: Normal load with mixed sizes
    normalUser.inject(
      nothingFor(1.minute),
      constantUsersPerSec(15) during (3.minutes)
    ),
    
    // Phase 3: Resource intensive load
    intensiveUser.inject(
      nothingFor(2.minutes),
      rampUsers(50) during (1.minute),
      constantUsersPerSec(25) during (2.minutes)
    ),
    
    // Phase 4: Memory stress test
    memoryStressUser.inject(
      nothingFor(3.minutes),
      rampUsers(20) during (30.seconds),
      constantUsersPerSec(10) during (1.minute)
    ),
    
    // Phase 5: Maximum stress with giant dungeons
    normalUser.inject(
      nothingFor(5.minutes),
      rampUsers(100) during (2.minutes),
      constantUsersPerSec(50) during (3.minutes)
    )
  ).protocols(httpProtocol)
    .maxDuration(12.minutes)
    .assertions(
      global.responseTime.max.lt(45000), // Increased for giant dungeons
      global.responseTime.mean.lt(8000),
      global.responseTime.percentile3.lt(20000),
      global.successfulRequests.percent.gt(85), // Lowered due to extreme stress
      forAll.failedRequests.percent.lt(15)
    )
}
