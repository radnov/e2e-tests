module.exports = () => {
  let retries = 5;
  let maxRetries = 50;
  
  const pageSource = () => {
    return browser.getPageSource().length;
  }

  let source = pageSource();
  const check = () => {
    maxRetries--;
    let newSource = pageSource();
    
    if (maxRetries < 1) {
      console.log(`max retry count reached. Won't resume waiting`)
      return true;
    }

    if (newSource === source) {
      console.log('its a match, retry' + retries)
      if (retries <= 0) {
        console.log('finished waiting')
        return true;
      }
      retries--;
      return false;
    }
    
    else {
      console.log('not a match')
      retries = 5;
      source = newSource;
      return false;
    }
  }

  browser.waitUntil(() => {
    return check()
  }, 40000, 'Page didnt load in 40s', 400)
}
