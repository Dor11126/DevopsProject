import scala.concurrent.duration._
import io.gatling.core.Predef._
import io.gatling.http.Predef._

class MaxLimitSimulation extends Simulation {
  val baseUrl   = sys.props.getOrElse("BASE_URL", "http://localhost:8080/DevOps")
  val rampMax   = Integer.getInteger("RAMP_MAX", 200)     // אפשר לעדכן מבחוץ
  val rampMins  = Integer.getInteger("RAMP_MINS", 6)      // דקות רמפה

  val httpProtocol = http.baseUrl(baseUrl)

  val scn = scenario("home").exec(
    http("home").get("/index.jsp")
  )

  setUp(
    scn.inject(rampUsersPerSec(1).to(rampMax).during(rampMins.minutes))
  ).protocols(httpProtocol)
   // השאר את ה-assertions שלך כמו שהם (p95<1200, failed<2%)
}
