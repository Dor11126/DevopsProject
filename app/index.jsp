<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>HIT DevOps App</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 2rem; }
    header { display: flex; justify-content: space-between; align-items: center; }
    .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(260px,1fr)); gap: 16px; }
    .card { border: 1px solid #ddd; border-radius: 12px; padding: 1rem 1.25rem; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
    label { display: block; margin: .4rem 0 .2rem; }
    input[type=text], select { width: 100%; padding: .5rem; border-radius: 8px; border: 1px solid #ccc; }
    .row { margin: .6rem 0; }
    .btn { padding: .55rem .95rem; border: 0; border-radius: 8px; background:#2d6cdf; color:#fff; cursor:pointer; }
    .muted { color: #666; }
    .ok { color: #0b8a00; }
    .warn { color: #b30000; }
    footer { margin-top: 2rem; color: #666; font-size: .9rem; }
    ul { margin: .3rem 0 .8rem 1.2rem; }
    .kpi { display:inline-block; padding:.3rem .6rem; border-radius:8px; background:#f5f7fb; margin:.15rem .25rem; }
  </style>
</head>
<body>
<%-- ===== Helpers ===== --%>
<%!
  private static String esc(String s) {
    if (s == null) return "";
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
            .replace("\"","&quot;").replace("'", "&#39;");
  }
  private static boolean has(String[] arr, String v){
    if(arr==null) return false;
    for(String s:arr) if(v.equals(s)) return true;
    return false;
  }
  private static String join(String[] arr, String sep){
    if(arr==null || arr.length==0) return "";
    StringBuilder b=new StringBuilder();
    for(int i=0;i<arr.length;i++){ if(i>0) b.append(sep); b.append(arr[i]); }
    return b.toString();
  }
%>

<%
  // ===== Read params =====
  String name = request.getParameter("name");
  String lang = request.getParameter("lang");                 // en/he
  String action = request.getParameter("action");             // greet/upper/reverse/lucky/count
  String[] features = request.getParameterValues("features"); // monitoring,cicd,docker,gatling
  if (lang == null) lang = "en"; // default
  boolean submitted = (request.getParameter("name") != null) ||
                      (request.getParameter("lang") != null) ||
                      (request.getParameter("action") != null) ||
                      (features != null);
%>

<header>
  <h1>HIT DevOps App</h1>
  <nav>
    <a id="docsLink" href="docs.jsp">Docs</a>
  </nav>
</header>

<main class="grid">
  <section class="card">
    <h2>Form</h2>
    <form method="get" action="index.jsp">
      <div class="row">
        <label for="name">Enter your name:</label>
        <input type="text" id="name" name="name" placeholder="Your name..." value="<%= esc(name) %>" required />
      </div>

      <div class="row">
        <label>Greeting language:</label>
        <label><input type="radio" name="lang" value="en" <%= "en".equals(lang)?"checked":"" %> /> English</label>
        <label><input type="radio" name="lang" value="he" <%= "he".equals(lang)?"checked":"" %> /> Hebrew</label>
      </div>

      <div class="row">
        <label for="action">Action on submit:</label>
        <select id="action" name="action">
          <option value="greet"   <%= "greet".equals(action)?"selected":"" %>>Greet</option>
          <option value="upper"   <%= "upper".equals(action)?"selected":"" %>>Uppercase name</option>
          <option value="reverse" <%= "reverse".equals(action)?"selected":"" %>>Reverse name</option>
          <option value="count"   <%= "count".equals(action)?"selected":"" %>>Count letters</option>
          <option value="lucky"   <%= "lucky".equals(action)?"selected":"" %>>Lucky number</option>
        </select>
      </div>

      <div class="row">
        <label>Features you’re interested in:</label>
        <label><input type="checkbox" name="features" value="monitoring" <%= has(features,"monitoring")?"checked":"" %> /> Monitoring</label>
        <label><input type="checkbox" name="features" value="cicd"      <%= has(features,"cicd")?"checked":"" %> /> CI/CD</label>
        <label><input type="checkbox" name="features" value="docker"    <%= has(features,"docker")?"checked":"" %> /> Docker</label>
        <label><input type="checkbox" name="features" value="gatling"   <%= has(features,"gatling")?"checked":"" %> /> Gatling</label>
      </div>

      <div class="row">
        <button id="submitBtn" class="btn" type="submit">Submit</button>
      </div>
    </form>
    <p class="muted">Tip: default language is English so <strong>#result</strong> includes “Hello” בשביל בדיקת Selenium.</p>
  </section>

  <section class="card">
    <h2>Result</h2>
    <div id="result">
      <%
        if (!submitted) {
      %>
          <p class="warn">Fill the form and press Submit.</p>
      <%
        } else {
          String nm = (name==null?"":name.trim());
          boolean hasName = !nm.isEmpty();
          String greeting = "en".equals(lang) ? "Hello" : "שלום";
          String line1;
          if (hasName) line1 = greeting + " " + esc(nm) + " 👋";
          else         line1 = "en".equals(lang) ? "No name provided." : "לא סופק שם.";
      %>
          <p class="ok"><%= line1 %></p>

          <%
            // Action output
            String actionOut = "";
            if ("upper".equals(action) && hasName)      actionOut = nm.toUpperCase();
            else if ("reverse".equals(action) && hasName) actionOut = new StringBuilder(nm).reverse().toString();
            else if ("count".equals(action) && hasName)   actionOut = "Letters: " + nm.length();
            else if ("lucky".equals(action))              actionOut = "Your lucky number: " + (1 + new java.util.Random().nextInt(100));
            else                                          actionOut = "Greet selected.";
          %>
          <p><strong>Action result:</strong> <span class="kpi"><%= esc(actionOut) %></span></p>

          <%
            // Features list
            String pretty = "";
            if (features != null && features.length > 0) {
              // Make them nicer to read
              java.util.Map<String,String> map = new java.util.HashMap<>();
              map.put("monitoring","Monitoring");
              map.put("cicd","CI/CD");
              map.put("docker","Docker");
              map.put("gatling","Gatling");
              StringBuilder sb = new StringBuilder();
              for (int i=0;i<features.length;i++){
                if (i>0) sb.append(", ");
                sb.append(map.getOrDefault(features[i], features[i]));
              }
              pretty = sb.toString();
          %>
              <p><strong>Selected features:</strong> <%= esc(pretty) %></p>
          <%
            } else {
          %>
              <p><strong>Selected features:</strong> none</p>
          <%
            }
          %>
      <%
        }
      %>
    </div>
  </section>
</main>

<footer>
  <p>App is running.</p>
  <p class="muted">Health: <span id="health">OK</span></p>
</footer>
</body>
</html>
