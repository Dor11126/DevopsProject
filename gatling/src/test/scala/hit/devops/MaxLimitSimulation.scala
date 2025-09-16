import scala.concurrent.duration._
import io.gatling.core.Predef._
import io.gatling.http.Predef._

class MaxLimitSimulation extends Simulation {
  val baseUrl  = sys.props.getOrElse("BASE_URL", "http://localhost:8080/DevOps")
  // קרא כטקסט והמרה מפורשת כדי לשלוט בטיפוסים:
  val rampMax  = sys.props.getOrElse("RAMP_MAX",  "200").toDouble  // Double
  val rampMins = sys.props.getOrElse("RAMP_MINS", "6").toInt       // Int

  val httpProtocol = http.baseUrl(baseUrl)

  val scn = scenario("home").exec(
    http("home").get("/index.jsp")
  )

  setUp(
    scn.inject(
      rampUsersPerSec(1.0).to(rampMax).during(rampMins.minutes) // 1.0 ו-rampMax כ-Double
    )
  ).protocols(httpProtocol)
  // השאר את ה-assertions כפי שהיו
}
