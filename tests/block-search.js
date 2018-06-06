'use strict';

const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch({executablePath: '/usr/bin/chromium-browser', args: ['--no-sandbox']});
  const page = await browser.newPage();

  await page.goto('http://127.0.0.1:5601');

  await page.waitFor(10000);

  const result = await page.evaluate(() => {
    let links = document.querySelector('div.global-nav__links').innerText;
    return links.includes('Discover');
  });

  await browser.close();

  process.exit(!result)
})();
