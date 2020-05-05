module.exports = () => {
  let retries = 5;
  let maxRetries = 25;
  
  const pageSource = () => {
    return browser.getPageSource();
  }

  let source = pageSource();
  const check = () => {
    maxRetries--;
    let newsource = pageSource();
    if (maxRetries < 1) {
      console.log(`max retry count reached. Won't resume waiting`)
      newsource = null;
      return true;
    }

    if (newsource === source) {
      if (retries <= 0) {
        console.log('finished waiting')
        newsource = null;
        return true;
      }
      retries--;
      return false;
    }
    
    else {
      retries = 5;
      source = newsource;
      return false;
    }
  }

  browser.waitUntil(() => {
    return check()
  }, 40000, 'Page didnt load in 40s', 400)

  source = null
}
