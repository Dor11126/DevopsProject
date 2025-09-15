<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>HIT DevOps App</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <style>
    body { font-family: system-ui, Arial, sans-serif; margin: 24px; }
    h1 { margin-top: 0; }
    .card { border: 1px solid #ddd; border-radius: 12px; padding: 16px; max-width: 720px; }
    fieldset { border: none; margin: 0; padding: 0 0 12px; }
    legend { font-weight: 600; margin-bottom: 6px; }
    label { margin-right: 12px; }
    select { padding: 6px 8px; }
    .row { display: flex; gap: 24px; flex-wrap: wrap; }
    .actions { margin-top: 12px; }
    button { padding: 8px 16px; border-radius: 10px; border: 1px solid #ccc; cursor: pointer; }
    #result { margin-top: 16px; white-space: pre-line; }
    #result .ok { color: #0a7c2f; font-weight: 700; }
    #result .bin { color: #555; }
    nav a { text-decoration: none; }
  </style>
</head>
<body>
  <header class="row" style="align-items:center; justify-content:space-between; max-width:720px;">
    <h1>HIT DevOps App</h1>
    <!-- קישור לתיעוד/דף משני: חובה עבור הולידציה 3 -->
    <nav><a id="docsLink" href="docs.jsp">Docs</a></nav>
  </header>

  <main class="card">
    <!-- בחירת שפה (למען הולידציה: נבחר EN כדי שהטקסט יתחיל ב-Hello) -->
    <fieldset>
      <legend>Language</legend>
      <label><input type="radio" name="lang" value="en" checked> English</label>
      <label><input type="radio" name="lang" value="he"> עברית</label>
    </fieldset>

    <!-- ללא הקלדה: בחירת "שם" מרשימה -->
    <fieldset>
      <legend>Select user</legend>
      <select id="userSelect" aria-label="User">
        <option value="alice">Alice</option>
        <option value="bob">Bob</option>
        <option value="charlie">Charlie</option>
      </select>
    </fieldset>

    <div class="row">
      <!-- בחירת קורסים (צ'קבוקסים) -->
      <fieldset>
        <legend>Courses</legend>
        <label><input type="checkbox" name="courses" value="DevOps 101"> DevOps 101</label>
        <label><input type="checkbox" name="courses" value="Cloud Basics"> Cloud Basics</label>
        <label><input type="checkbox" name="courses" value="Kubernetes"> Kubernetes</label>
        <label><input type="checkbox" name="courses" value="Jenkins CI"> Jenkins CI</label>
        <label><input type="checkbox" name="courses" value="Monitoring"> Monitoring</label>
      </fieldset>

      <!-- סוג טלפון (ללא כתיבה, רק בחירה) -->
      <fieldset>
        <legend>Phone type</legend>
        <label><input type="radio" name="phoneType" value="Mobile" checked> Mobile</label>
        <label><input type="radio" name="phoneType" value="Landline"> Landline</label>
      </fieldset>
    </div>

    <div class="actions">
      <button id="submitBtn" type="button">SUBMIT</button>
    </div>

    <!-- תוצאות -->
    <div id="result" aria-live="polite" role="status">
      <!-- יתמלא לאחר SUBMIT -->
    </div>
  </main>

  <script>
    (function () {
      const $ = (sel, ctx=document) => ctx.querySelector(sel);
      const $$ = (sel, ctx=document) => Array.from(ctx.querySelectorAll(sel));

      $('#submitBtn').addEventListener('click', function () {
        const lang = $('input[name="lang"]:checked').value;
        const userSel = $('#userSelect');
        const userName = userSel.options[userSel.selectedIndex].text;

        const courses = $$('input[name="courses"]:checked').map(x => x.value);
        const coursesText = courses.length ? courses.join(', ') : 'none';

        const phoneTypeEl = $('input[name="phoneType"]:checked');
        const phoneType = phoneTypeEl ? phoneTypeEl.value : 'N/A';

        const hello = (lang === 'he' ? 'שלום ' : 'Hello ') + userName;

        const res = $('#result');
        res.innerHTML =
          `<p class="ok" id="greet">${hello}</p>` +
          `<p class="bin">Action result: Submit selected.</p>` +
          `<p>ID: N/A</p>` +
          `<p>Phone: ${phoneType}</p>` +
          `<p>Selected courses: ${coursesText}</p>`;
      });
    })();
  </script>
</body>
</html>
