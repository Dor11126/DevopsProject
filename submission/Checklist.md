# Submission Checklist (copy into your email)

a) Attach the **index.jsp** you used (from `app/`).
b) Screenshot of your GitHub repo showing the JSP.
c) Screenshot in the browser: `http://localhost:8080/<YourGroupName>App/index.jsp`.
d) Monitoring tool name + what you monitored + screenshot of **passed** availability (UptimeRobot/SiteMonitorLite or Jenkins `monitor-uptime` success).
e) Attach your Selenium IDE file (`.side`).
f) Selenium IDE **passed** run screenshot + list the 3 validations (title/text/url) and why you chose them.
g) Describe your HAR scenario in words (e.g., type name -> click Submit -> navigate to Docs).
h) Attach the HAR file you exported.
i) State your app **max limit** (users/sec or req/sec) and explain how you found it (Gatling MaxLimitSimulation + assertions).
j) Attach 3 screenshots of Gatling run summaries (CMD): max limit, load, stress.
k) Attach 3 PDFs (print Gatling `index.html` to PDF) for max, load, stress + explain **why** the graphs look as they do (CPU/GC/DB/Thread saturation hypothesis).
