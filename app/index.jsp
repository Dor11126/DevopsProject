<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>HIT DevOps App</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 2rem; }
    header { display: flex; justify-content: space-between; align-items: center; }
    .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px,1fr)); gap: 16px; }
    .card { border: 1px solid #ddd; border-radius: 12px; padding: 1rem 1.25rem; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
    label { display: block; margin: .4rem 0 .2rem; }
    input[type=text], input[type=tel], select { width: 100%; padding: .5rem; border-radius: 8px; border: 1px solid #ccc; }
    .row { margin: .6rem 0; }
    .btn { padding: .55rem .95rem; border: 0; border-radius: 8px; background:#2d6cdf; color:#fff; cursor:pointer; }
    .muted { color: #666; }
    .ok { color: #0b8a00; }
    .warn { color: #b30000; }
    footer { margin-top: 2rem; color: #666; font-size: .9rem; }
    .kpi { display:inline-block; padding:.3rem .6rem; border-radius:8px; background:#f5f7fb; margin:.15rem .25rem; }
  </style>
</head>
<body>
<%-- ===== Helpers ===== --%>
<%!
  private static String esc(String s) {
    if (s == null) return "";
    return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;")
            .replace("\"","&quot;").replace("'","&#39;");
  }
  private static boolean has(String[] arr, String v){
    if(arr==null) return false;
    for(String s:arr) if(v.equals(s)) return true;
    return false;
  }
%>

<%
  // ===== Read params =====
  String name      = request.getParameter("name");
  String tz        = request.getParameter("tz");         // ת"ז
  String phone     = request.getParameter("phone");      // טלפון
  String phoneType = request.getParameter("phoneType");  // mobile/landline
  String lang      = request.getParameter("lang");       // en/he
  String action    = request.getParameter("action");     // greet/upper/reverse/count
  String[] courses = request.getParameterValues("courses"); // devops,cicd,docker,monitoring,gatling,java

  if (lang == null)   lang = "en";
  if (action == null) action = "greet";

  boolean submitted =
      (name != null) || (tz != null) || (phone != null) ||
      (phoneType != null) || (lang != null) || (action != null) ||
      (courses != null);
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
        <label for="tz">ID (Teudat Zehut):</label>
        <input type="text" id="tz" name="tz" placeholder="9 digits" value="<%= esc(tz) %>" />
      </div>

      <div class="row">
        <label for="phone">Phone:</label>
        <input type="tel" id="phone" name="phone" placeholder="e.g. 05x-xxxxxxx" value="<%= esc(phone) %>" />
        <label><input type="radio" name="phoneType" value="mobile"   <%= "mobile".equals(phoneType)?"checked":"" %> /> נייד (Mobile)</label>
        <label><input type="radio" name="phoneType" value="landline" <%= "landline".equals(phoneType)?"checked":"" %> /> נייח (Landline)</label>
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
        </select>
      </div>

      <div class="row">
        <label>Courses you’re interested in:</label>
        <label><input type="checkbox" name="courses" value="devops"     <%= has(courses,"devops")?"checked":"" %> /> DevOps Basics</label>
        <label><input type="checkbox" name="courses" value="cicd"       <%= has(courses,"cicd")?"checked":"" %> /> CI/CD Pipelines</label>
        <label><input type="checkbox" name="courses" value="docker"     <%= has(courses,"docker")?"checked":"" %> /> Docker & Kubernetes</label>
        <label><input type="checkbox" name="courses" value="monitoring" <%= has(courses,"monitoring")?"checked":"" %> /> Monitoring & Logging</label>
        <label><input type="checkbox" name="courses" value="gatling"    <%= has(courses,"gatling")?"checked":"" %> /> Performance Testing (Gatling)</label>
        <label><input type="checkbox" name="courses" value="java"       <%= has(courses,"java")?"checked":"" %> /> Java Fundamentals</label>
      </div>

      <div class="row">
        <button id="submitBtn" class="btn" type="submit">Submit</button>
      </div>
    </form>
    <p class="muted">Tip: default language is English so <strong>#result</strong> includes “Hello” אחרי מילוי שם (טוב ל-Selenium).</p>
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
          String line1 = hasName ? (greeting + " " + esc(nm) + " 👋") :
                                   ("en".equals(lang) ? "No name provided." : "לא סופק שם.");
      %>
          <p class="ok"><%= line1 %></p>

          <%-- Action output --%>
          <%
            String actionOut = "";
            if ("upper".equals(action) && hasName)        actionOut = nm.toUpperCase();
            else if ("reverse".equals(action) && hasName) actionOut = new StringBuilder(nm).reverse().toString();
            else if ("count".equals(action) && hasName)   actionOut = "Letters: " + nm.length();
            else                                          actionOut = "Greet selected.";
          %>
          <p><strong>Action result:</strong> <span class="kpi"><%= esc(actionOut) %></span></p>

          <%-- ID & Phone --%>
          <p><strong>ID:</strong> <span class="kpi"><%= esc(tz==null?"":tz.trim()) %></span></p>
          <p><strong>Phone:</strong> <span class="kpi"><%= esc(phone==null?"":phone.trim()) %></span>
             <%= (phoneType!=null && !"".equals(phoneType)) ? ("<span class='kpi'>"+("mobile".equals(phoneType)?"Mobile":"Landline")+"</span>") : "" %>
          </p>

          <%-- Courses list --%>
          <%
            if (courses != null && courses.length > 0) {
              java.util.Map<String,String> map = new java.util.HashMap<>();
              map.put("devops","DevOps Basics");
              map.put("cicd","CI/CD Pipelines");
              map.put("docker","Docker & Kubernetes");
              map.put("monitoring","Monitoring & Logging");
              map.put("gatling","Performance Testing (Gatling)");
              map.put("java","Java Fundamentals");
              StringBuilder sb = new StringBuilder();
              for (int i=0;i<courses.length;i++){
                if (i>0) sb.append(", ");
                sb.append(map.getOrDefault(courses[i], courses[i]));
              }
          %>
              <p><strong>Selected courses:</strong> <span class="kpi"><%= esc(sb.toString()) %></span></p>
          <%
            } else {
          %>
              <p><strong>Selected courses:</strong> none</p>
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
