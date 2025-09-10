package hit.devops

import scala.concurrent.duration._
import io.gatling.core.Predef._
import io.gatling.http.Predef._

class MaxLimitSimulation extends Simulation {

  val baseUrl = System.getProperty("BASE_URL", "http://localhost:8080/HIT_GroupApp")
  val httpProtocol = http.baseUrl(baseUrl)

  val scn = scenario("MaxLimit")
    .exec(
      http("home")
        .get("/index.jsp")
        .check(status.is(200))
    )

  // Ramps up load to discover max limit (watch failures/latency)
  setUp(
    scn.inject(
      rampUsersPerSec(1).to(200).during(5.minutes), // adjust upper bound as needed
      constantUsersPerSec(200).during(1.minutes)
    )
  ).protocols(httpProtocol)
   .assertions(
      global.failedRequests.percent.lt(2),
      forAll.responseTime.percentile3.lt(1200)
   )
}
