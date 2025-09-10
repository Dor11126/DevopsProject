<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>HIT DevOps App</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 2rem; }
    header { display: flex; justify-content: space-between; align-items: center; }
    .card { border: 1px solid #ddd; border-radius: 12px; padding: 1rem 1.5rem; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
    input[type=text]{ padding: .5rem; border-radius: 8px; border: 1px solid #ccc; }
    button{ padding: .5rem .9rem; border: 0; border-radius: 8px; cursor: pointer; }
    a{ text-decoration: none; }
    .ok { color: #0b8a00; }
    .warn { color: #b30000; }
    footer { margin-top: 2rem; color: #666; font-size: .9rem; }
    .row { margin: .5rem 0; }
  </style>
</head>
<body>
  <header>
    <h1>HIT DevOps App</h1>
    <nav>
      <a id="docsLink" href="docs.jsp">Docs</a>
    </nav>
  </header>

  <main class="card">
    <h2>Echo Form</h2>
    <form method="get" action="index.jsp">
      <div class="row">
        <label for="name">Enter your name:</label>
        <input type="text" id="name" name="name" placeholder="Your name..." required />
        <button id="submitBtn" type="submit">Submit</button>
      </div>
    </form>
    <div id="result" class="row">
      <%
        String name = request.getParameter("name");
        if (name != null && !name.trim().isEmpty()) {
      %>
        <p class="ok">Hello <strong><%= name.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;") %></strong> 👋</p>
      <%
        } else {
      %>
        <p class="warn">No name provided yet.</p>
      <%
        }
      %>
    </div>
  </main>

  <footer>
    <p>App is running. <span id="health">/</span></p>
    <script>
      // tiny client-side "health" indicator
      document.getElementById('health').textContent = 'OK';
    </script>
  </footer>
</body>
</html>
