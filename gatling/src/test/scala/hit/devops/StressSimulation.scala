package hit.devops

import scala.concurrent.duration._
import io.gatling.core.Predef._
import io.gatling.http.Predef._

class StressSimulation extends Simulation {

  val baseUrl = System.getProperty("BASE_URL", "http://localhost:8080/DevOps")
  val httpProtocol = http.baseUrl(baseUrl)

  val scn = scenario("Stress")
    .exec(
      http("home")
        .get("/index.jsp")
        .check(status.is(200))
    )

  setUp(
    scn.inject(
      rampUsersPerSec(1).to(150).during(210.seconds) // ~3.5 minutes
    )
  ).protocols(httpProtocol)
   .assertions(
      global.failedRequests.percent.lt(5)
   )
}
