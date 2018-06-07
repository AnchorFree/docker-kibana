'use strict';

const puppeteer = require('puppeteer');

(async () => {
  try {
    const kibanaPort = process.env.SERVER_PORT || "5601"
    const browser = await puppeteer.launch({executablePath: '/usr/bin/chromium-browser', args: ['--no-sandbox']});
    const page = await browser.newPage();

    await page.goto('http://127.0.0.1:' + kibanaPort);

    await page.waitFor(10000);

    const result = await page.evaluate(() => {
      let links = document.querySelector('div.global-nav__links').innerText;
      return links.includes('Discover');
    });

    await browser.close();

    process.exit(!result);
  } catch(e) {
    console.log(e);
    process.exit(1);
  }
})();
