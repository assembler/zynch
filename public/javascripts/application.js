var setCookie = function(key, value, expiresIn, path, domain, secure) {
  var cookie = [], expires;
  if(value === null) expiresIn = -1;
  if(typeof expiresIn === 'number') {
    expires = new Date();
    expires.setDate(expires.getDate() + expiresIn);
  } 

  cookie.push(encodeURIComponent(key) + "=" + encodeURIComponent(value.toString()));
  if(expires) cookie.push('expires=' + expires.toUTCString());
  if(path) cookie.push('path=' + path);
  if(domain) cookie.push('domain=' + domain);
  if(secure === true) cookie.push('secure');
  document.cookie = cookie.join(';');
};