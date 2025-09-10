# HIT DevOps Final

This repo is (Tomcat + Jenkins + Monitoring + Selenium + Gatling).

## Structure
```
app/                    # JSP app (copy to Tomcat webapps/<GroupNameApp>)
  index.jsp
  docs.jsp
gatling/
  src/test/scala/hit/devops/   # Gatling simulations
monitor/
  check.ps1            # Jenkins monitor job script (runs every 5 minutes)
har/
  README.txt           # Place your exported HAR here
submission/
  Checklist.md         # What to send
Jenkinsfile            # Pipeline for deploy + perf (Windows-friendly)
```

## Quick Start
1. Create a public GitHub repo and push the files.
2. Install Tomcat (8.5/9/10) locally and ensure `http://localhost:8080` works.
3. Create a folder under `webapps/` named **<YourGroupName>App** and copy files from `app/` into it.
4. Browse: `http://localhost:8080/<YourGroupName>App/index.jsp`
5. Configure Jenkins (Windows agent), and create a pipeline with this `Jenkinsfile`.
6. Create a **freestyle** Jenkins job named `monitor-uptime` that runs `monitor/check.ps1` on a 5-minute CRON (`H/5 * * * *`).

## Selenium IDE
Record a `.side` with 3 validations:
- Page title is `HIT DevOps App`
- Type a name and submit → `#result` contains `Hello`
- Click `Docs` link → URL contains `docs.jsp`

Run headless from Jenkins (requires NodeJS + Chrome):
```
npm i -g selenium-side-runner
selenium-side-runner -c "browserName=chrome headless=true" path/to/tests.side
```

## Gatling (Java 17 recommended)
Place Gatling in `C:\Gatling` (or use a tool env var). From Jenkins, call `bin\gatling.bat -s hit.devops.LoadSimulation` etc.
Results are in `results/` – open `index.html` and print to PDF for submission.
