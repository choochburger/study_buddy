// Environment specific shit
var SB = window.SB || {}
SB.Env = (function() {
  var url = window.location.href;
  if (url.indexOf('localhost') > -1) {
    // local dev
    return {
      redirectUri: 'http://localhost:8888/'
    }
  } else {
    // cldn
    return {
      redirectUri: 'http://www.chrislyons.net/sandbox/study_buddy/www/'
    }
  }
})();
