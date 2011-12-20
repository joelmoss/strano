$.extend({
  
  // returns a hash of URL query parameters
  getUrlVars: function(){
    var vars = {}, hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for (var i = 0; i < hashes.length; i++) {
      hash = hashes[i].split('=');
      vars[hash[0]] = hash[1];
    }
    return vars;
  },
  
  // returns a single URL query parameter
  getUrlVar: function(name){
    return $.getUrlVars()[name];
  }
  
});