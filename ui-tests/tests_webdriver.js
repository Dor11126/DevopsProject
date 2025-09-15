// Simple Selenium WebDriver runner (Firefox headless) for HIT DevOps App
const fs = require('fs');
const {Builder, By, until} = require('selenium-webdriver');
const firefox = require('selenium-webdriver/firefox');

const BASE = 'http://localhost:8080/DevOps/index.jsp';
const TIMEOUT = 10000; // 10s per wait

async function buildDriver() {
  const opts = new firefox.Options().headless().windowSize({width: 1280, height: 900});
  // אם מוכרחים כרום, אפשר להחליף ל: forBrowser('chrome') עם אופציות headless.
  return await new Builder().forBrowser('firefox').setFirefoxOptions(opts).build();
}

async function openHome(driver) {
  await driver.get(BASE);
  await driver.wait(until.titleIs('HIT DevOps App'), TIMEOUT);
}

async function clickCss(driver, css) {
  const el = await driver.wait(until.elementLocated(By.css(css)), TIMEOUT);
  await driver.wait(until.elementIsVisible(el), TIMEOUT);
  await el.click();
}

async function selectByLabel(driver, selectId, label) {
  const opt = await driver.wait(
    until.elementLocated(By.xpath(`//select[@id='${selectId}']/option[normalize-space(text())='${label}']`)),
    TIMEOUT
  );
  await opt.click();
}

async function getText(driver, css) {
  const el = await driver.wait(until.elementLocated(By.css(css)), TIMEOUT);
  await driver.wait(until.elementIsVisible(el), TIMEOUT);
  return await el.getText();
}

async function testHomeEN() {
  const driver = await buildDriver();
  try {
    await openHome(driver);
    await clickCss(driver, "input[name='lang'][value='en']");
    await selectByLabel(driver, "userSelect", "Alice");
    await selectByLabel(driver, "streetSelect", "Herzl St.");
    await selectByLabel(driver, "referralSelect", "Google");
    await clickCss(driver, "input[name='courses'][value='DevOps 101']");
    await clickCss(driver, "input[name='courses'][value='Kubernetes']");
    await clickCss(driver, "#submitBtn");

    const greet = await getText(driver, "#result .ok");
    if (greet !== "Hello Alice") throw new Error(`Expected "Hello Alice", got "${greet}"`);

    const street = await getText(driver, "#result ul li:nth-child(1)");
    const courses = await getText(driver, "#result ul li:nth-child(5)");
    if (street !== "Street: Herzl St.") throw new Error(`Bad street: ${street}`);
    if (courses !== "Selected courses: DevOps 101, Kubernetes") throw new Error(`Bad courses: ${courses}`);

    // ניווט ל־Docs ואימות H1
    await clickCss(driver, "#docsLink");
    const h1 = await getText(driver, "h1");
    if (h1 !== "Docs") throw new Error(`Docs h1 mismatch: ${h1}`);

    return {name: "Home Flow EN - 3 validations", ok: true};
  } finally {
    await driver.quit();
  }
}

async function testHE() {
  const driver = await buildDriver();
  try {
    await openHome(driver);
    await clickCss(driver, "input[name='lang'][value='he']");
    await selectByLabel(driver, "userSelect", "Bob");
    await clickCss(driver, "#submitBtn");

    const greet = await getText(driver, "#result .ok");
    if (greet !== "שלום Bob") throw new Error(`Expected "שלום Bob", got "${greet}"`);

    return {name: "Greeting HE (שלום)", ok: true};
  } finally {
    await driver.quit();
  }
}

async function testNoCourses() {
  const driver = await buildDriver();
  try {
    await openHome(driver);
    await clickCss(driver, "#submitBtn");

    const greet = await getText(driver, "#result .ok");
    const last = await getText(driver, "#result ul li:nth-child(5)");
    if (greet !== "Hello Alice") throw new Error(`Expected "Hello Alice", got "${greet}"`);
    if (last !== "Selected courses: none") throw new Error(`Expected no courses, got "${last}"`);

    return {name: "Default no courses", ok: true};
  } finally {
    await driver.quit();
  }
}

async function testRefresh() {
  const driver = await buildDriver();
  try {
    await openHome(driver);
    await selectByLabel(driver, "streetSelect", "Herzl St.");
    await clickCss(driver, "#submitBtn");
    let street = await getText(driver, "#result ul li:nth-child(1)");
    if (street !== "Street: Herzl St.") throw new Error(`Bad street #1: ${street}`);

    await selectByLabel(driver, "streetSelect", "Bialik St.");
    await clickCss(driver, "#submitBtn");
    street = await getText(driver, "#result ul li:nth-child(1)");
    if (street !== "Street: Bialik St.") throw new Error(`Bad street #2: ${street}`);

    return {name: "Submit twice updates result", ok: true};
  } finally {
    await driver.quit();
  }
}

(async () => {
  const results = [];
  let failed = false;

  // בדיקת אפליקציה חיה לפני הכל (כמו ב־Jenkins)
  // נוותר על curl כאן; אם טעינת BASE נופלת, ייזרק שגיאה מה־wait.

  for (const fn of [testHomeEN, testHE, testNoCourses, testRefresh]) {
    try {
      const r = await fn();
      results.push(r);
      console.log(`[OK] ${r.name}`);
    } catch (e) {
      failed = true;
      const name = fn.name;
      console.error(`[FAIL] ${name}: ${e.message}`);
      results.push({name, ok: false, error: e.message});
    }
  }

  const lines = results.map(r => `${r.ok ? 'OK' : 'FAIL'} - ${r.name}${r.error ? ' - ' + r.error : ''}`);
  try { fs.writeFileSync('report.txt', lines.join('\n')); } catch (_) {}

  process.exit(failed ? 1 : 0);
})();
