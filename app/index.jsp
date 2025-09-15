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
    .card { border: 1px solid #ddd; border-radius: 12px; padding: 16px; max-width: 820px; }
    fieldset { border: none; margin: 0; padding: 0 0 12px; }
    legend { font-weight: 600; margin-bottom: 6px; }
    label { margin-right: 12px; display: inline-flex; align-items: center; gap: 6px; }
    select { padding: 6px 8px; }
    .grid { display: grid; grid-template-columns: repeat(2, minmax(280px,1fr)); gap: 18px 24px; }
    .actions { margin-top: 12px; }
    button { padding: 8px 16px; border-radius: 10px; border: 1px solid #ccc; cursor: pointer; }
    #result { margin-top: 16px; white-space: pre-line; }
    #result .ok { color: #0a7c2f; font-weight: 700; }
    #result .bin { color: #555; }
    nav a { text-decoration: none; }
    ul { margin: 6px 0 0 20px; }
  </style>
</head>
<body>
  <header style="display:flex;align-items:center;justify-content:space-between;max-width:820px;">
    <h1>HIT DevOps App</h1>
    <nav><a id="docsLink" href="docs.jsp">Docs</a></nav>
  </header>

  <main class="card">
    <div class="grid">
      <!-- שפה -->
      <fieldset>
        <legend>Language</legend>
        <label><input type="radio" name="lang" value="en" checked> English</label>
        <label><input type="radio" name="lang" value="he"> עברית</label>
      </fieldset>

      <!-- בחירת משתמש (במקום שדה כתיבה) -->
      <fieldset>
        <legend>Select user</legend>
        <select id="userSelect" aria-label="User">
          <option value="alice">Alice</option>
          <option value="bob">Bob</option>
          <option value="charlie">Charlie</option>
        </select>
      </fieldset>

      <!-- קורסים -->
      <fieldset>
        <legend>Courses</legend>
        <label><input type="checkbox" name="courses" value="DevOps 101"> DevOps 101</label>
        <label><input type="checkbox" name="courses" value="Cloud Basics"> Cloud Basics</label>
        <label><input type="checkbox" name="courses" value="Kubernetes"> Kubernetes</label>
        <label><input type="checkbox" name="courses" value="Jenkins CI"> Jenkins CI</label>
        <label><input type="checkbox" name="courses" value="Monitoring"> Monitoring</label>
      </fieldset>

      <!-- סוג טלפון -->
      <fieldset>
        <legend>Phone type</legend>
        <label><input type="radio" name="phoneType" value="Mobile" checked> Mobile</label>
        <label><input type="radio" name="phoneType" value="Landline"> Landline</label>
      </fieldset>

      <!-- רחוב (בחירה בלבד) -->
      <fieldset>
        <legend>Street</legend>
        <select id="streetSelect" aria-label="Street">
          <option value="Herzl St.">Herzl St.</option>
          <option value="Bialik St.">Bialik St.</option>
          <option value="Rothschild Blvd.">Rothschild Blvd.</option>
          <option value="Weizmann St.">Weizmann St.</option>
        </select>
      </fieldset>

      <!-- איך הגעת אלינו (Referral) -->
      <fieldset>
        <legend>How did you hear about us?</legend>
        <select id="referralSelect" aria-label="Referral">
          <option value="Google">Google</option>
          <option value="Friend">Friend</option>
          <option value="Facebook">Facebook</option>
          <option value="Campus board">Campus board</option>
        </select>
      </fieldset>

      <!-- העדפה נוספת (עוד משהו) -->
      <fieldset>
        <legend>Preferred contact time</legend>
        <label><input type="radio" name="contactTime" value="Morning" checked> Morning</label>
        <label><input type="radio" name="contactTime" value="Afternoon"> Afternoon</label>
        <label><input type="radio" name="contactTime" value="Evening"> Evening</label>
      </fieldset>
    </div>

    <div class="actions">
      <button id="submitBtn" type="button">SUBMIT</button>
    </div>

    <div id="result" aria-live="polite" role="status"></div>
  </main>

<script>
  document.addEventListener('DOMContentLoaded', function () {
    const $  = (sel, ctx=document) => ctx.querySelector(sel);
    const $$ = (sel, ctx=document) => Array.from(ctx.querySelectorAll(sel));

    // חשוב: לוודא שהכפתור הוא type="button" ב-HTML. נגן גם מפני submit של form:
    $('#submitBtn').addEventListener('click', function (e) {
      e.preventDefault();

      const lang = $('input[name="lang"]:checked').value;

      const userSel  = $('#userSelect');
      const userName = userSel && userSel.options.length
        ? userSel.options[userSel.selectedIndex].text
        : 'N/A';

      const streetSel = $('#streetSelect');
      const street = streetSel && streetSel.options.length
        ? streetSel.options[streetSel.selectedIndex].text
        : 'N/A';

      const refSel = $('#referralSelect');
      const referral = refSel && refSel.options.length
        ? refSel.options[refSel.selectedIndex].text
        : 'N/A';

      const courses = $$("input[name='courses']:checked").map(x => x.value);
      const coursesText = courses.length ? courses.join(', ') : 'none';

      const phoneTypeEl = $("input[name='phoneType']:checked");
      const phoneType = phoneTypeEl ? phoneTypeEl.value : 'N/A';

      const contactTimeEl = $("input[name='contactTime']:checked");
      const contactTime = contactTimeEl ? contactTimeEl.value : 'N/A';

      const hello = (lang === 'he' ? 'שלום ' : 'Hello ') + userName;

      var resHtml = ''
        + '<p class="ok" id="greet">' + hello + '</p>'
        + '<p class="bin">Action result: Submit selected.</p>'
        + '<ul>'
        +   '<li><strong>Street:</strong> ' + street + '</li>'
        +   '<li><strong>Heard about us via:</strong> ' + referral + '</li>'
        +   '<li><strong>Phone type:</strong> ' + phoneType + '</li>'
        +   '<li><strong>Preferred contact time:</strong> ' + contactTime + '</li>'
        +   '<li><strong>Selected courses:</strong> ' + coursesText + '</li>'
        + '</ul>';

      $('#result').innerHTML = resHtml; // כל לחיצה מחליפה פלט — עובד שוב ושוב
    });
  });
</script>

</body>
</html>
