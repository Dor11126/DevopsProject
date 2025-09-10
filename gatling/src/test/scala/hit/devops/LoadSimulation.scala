package hit.devops

import scala.concurrent.duration._
import io.gatling.core.Predef._
import io.gatling.http.Predef._

class LoadSimulation extends Simulation {

  val baseUrl = System.getProperty("BASE_URL", "http://localhost:8080/HIT_GroupApp")
  val httpProtocol = http.baseUrl(baseUrl)

  val scn = scenario("Load5m")
    .exec(
      http("home")
        .get("/index.jsp?name=tester")
        .check(status.is(200))
    )

  setUp(
    scn.inject(
      constantUsersPerSec(20).during(5.minutes) // adjust RPS for your app
    )
  ).protocols(httpProtocol)
   .assertions(
      global.failedRequests.percent.lt(1),
      global.responseTime.mean.lt(500)
   )
}
