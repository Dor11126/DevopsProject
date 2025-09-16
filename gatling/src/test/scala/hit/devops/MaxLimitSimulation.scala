package hit.devops

import scala.concurrent.duration._
import io.gatling.core.Predef._
import io.gatling.http.Predef._

class MaxLimitSimulation extends Simulation {
  val baseUrl   = sys.props.getOrElse("BASE_URL", "http://localhost:8080/DevOps")
  val targetRps = sys.props.getOrElse("RAMP_MAX",  "3500").toDouble
  val rampSecs  = sys.props.getOrElse("RAMP_SECS", "60").toInt
  val holdSecs  = sys.props.getOrElse("HOLD_SECS", "300").toInt

  val httpProtocol = http.baseUrl(baseUrl).shareConnections

  val scn = scenario("home").exec(
    http("home").get("/index.jsp")
  )

  setUp(
    scn.inject(
      rampUsersPerSec(0).to(targetRps) during (rampSecs.seconds),
      constantUsersPerSec(targetRps)    during (holdSecs.seconds)
    )
  ).protocols(httpProtocol)
   .assertions(
     global.failedRequests.percent.lt(2.0),     // KO < 2%
     global.responseTime.percentile3.lt(1200)   // p95 < 1200ms
   )
   .maxDuration((rampSecs + holdSecs).seconds)
}
