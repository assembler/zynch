(function () {
  var BrowserDetect = function() {
    var searchString = function (data) {
      for (var i=0;i<data.length;i++)  {
        var dataString = data[i].string;
        var dataProp = data[i].prop;
        this.versionSearchString = data[i].versionSearch || data[i].identity;
        if (dataString) {
          if (dataString.indexOf(data[i].subString) != -1)
            return data[i].identity;
        }
        else if (dataProp)
          return data[i].identity;
      }
    },
    searchVersion = function (dataString) {
      var index = dataString.indexOf(this.versionSearchString);
      if (index == -1) return;
      return parseFloat(dataString.substring(index+this.versionSearchString.length+1));
    },
    dataBrowser = [
      { string: navigator.userAgent, subString: "Chrome", identity: "Chrome" },
      { string: navigator.userAgent, subString: "OmniWeb", versionSearch: "OmniWeb/", identity: "OmniWeb" },
      { string: navigator.vendor, subString: "Apple", identity: "Safari", versionSearch: "Version" },
      { prop: window.opera, identity: "Opera" },
      { string: navigator.vendor, subString: "iCab", identity: "iCab" },
      { string: navigator.vendor, subString: "KDE", identity: "Konqueror" },
      { string: navigator.userAgent, subString: "Firefox", identity: "Firefox" },
      { string: navigator.vendor, subString: "Camino", identity: "Camino" },
      // for newer Netscapes (6+)
      { string: navigator.userAgent, subString: "Netscape", identity: "Netscape" },
      { string: navigator.userAgent, subString: "MSIE", identity: "Explorer", versionSearch: "MSIE" },
      { string: navigator.userAgent, subString: "Gecko", identity: "Mozilla", versionSearch: "rv" },
      // for older Netscapes (4-)
      { string: navigator.userAgent, subString: "Mozilla", identity: "Netscape", versionSearch: "Mozilla" }
    ],
    dataOS = [
      { string: navigator.platform, subString: "Win", identity: "Windows" },
      { string: navigator.platform, subString: "Mac", identity: "Mac" },
      { string: navigator.userAgent, subString: "iPhone", identity: "iPhone/iPod" },
      { string: navigator.platform, subString: "Linux", identity: "Linux" }
    ];
    
    return {
      browser: searchString(dataBrowser) || "-",
      version: searchVersion(navigator.userAgent) || searchVersion(navigator.appVersion) || "-",
      OS: searchString(dataOS) || "-"
    }
  }();
  var FlashDetect = function() {
    var getFlashVersion = function(){
      var flashVer = { 
        major: '-', 
        minor: '-', 
        revision: '-',
        signature: function() {
          if(this.major == '-') return '-';
          return this.major + '.' + this.minor + '.' + this.revision;
        }
      };
      var isIE  = (navigator.appVersion.indexOf("MSIE") != -1) ? true : false;
      var isWin = (navigator.appVersion.toLowerCase().indexOf("win") != -1) ? true : false;
      var isOpera = (navigator.userAgent.indexOf("Opera") != -1) ? true : false;

      if (navigator.plugins != null && navigator.plugins.length > 0) {
        if (navigator.plugins["Shockwave Flash 2.0"] || navigator.plugins["Shockwave Flash"]) {
          var swVer2 = navigator.plugins["Shockwave Flash 2.0"] ? " 2.0" : "";
          var flashDescription = navigator.plugins["Shockwave Flash" + swVer2].description;
          var descArray = flashDescription.split(" ");
          var tempArrayMajor = descArray[2].split(".");      
          var versionMajor = tempArrayMajor[0];
          var versionMinor = tempArrayMajor[1];
          var versionRevision = descArray[3];
          if (versionRevision == "") {
            versionRevision = descArray[4];
          }
          if (versionRevision[0] == "d") {
            versionRevision = versionRevision.substring(1);
          } else if (versionRevision[0] == "r") {
            versionRevision = versionRevision.substring(1);
            if (versionRevision.indexOf("d") > 0) {
              versionRevision = versionRevision.substring(0, versionRevision.indexOf("d"));
            }
          }
          flashVer.major = versionMajor;
          flashVer.minor = versionMinor;
          flashVer.revision = versionRevision;
        }
      }
      // MSN/WebTV 2.6 supports Flash 4
      else if (navigator.userAgent.toLowerCase().indexOf("webtv/2.6") != -1) flashVer = 4;
      // WebTV 2.5 supports Flash 3
      else if (navigator.userAgent.toLowerCase().indexOf("webtv/2.5") != -1) flashVer = 3;
      // older WebTV supports Flash 2
      else if (navigator.userAgent.toLowerCase().indexOf("webtv") != -1) flashVer = 2;
      else if ( isIE && isWin && !isOpera ) {
        var axo, d, e;
        try {
          // version will be set for 7.X or greater players
          axo = new ActiveXObject("ShockwaveFlash.ShockwaveFlash");
          d = axo.GetVariable("$version");
          if(d) {
            d = d.split(" ")[1].split(",");
            flashVer.major = parseInt(d[0]);
            flashVer.minor = parseInt(d[1]);
            flashVer.revision = parseInt(d[2]);
          }
        } catch (e) { }
      }  
      return flashVer;
    };
    return getFlashVersion();
  }();
  var getCookie = function(key) {
    var value, re = new RegExp('(?:^|; )' + encodeURIComponent(key) + '=([^;]*)');
    value = re.exec(document.cookie);
    return value ? decodeURIComponent(value[1]) : null;
  };
  
  var data = {
   id: getCookie('__zysid') || '-',
   cl: _zys.id,
   hn: window.location.hostname,
   pn: window.location.pathname,
   ss: window.location.search,
   pt: document.title,
   sw: screen.width,
   sh: screen.height,
   cd: screen.colorDepth,
   fv: FlashDetect.signature(),
   la: navigator.language || navigator.browserLanguage,
   je: navigator.javaEnabled() ? 1 : 0,
   cs: document.characterSet || document.charset,
   br: BrowserDetect.browser,
   bv: BrowserDetect.version,
   os: BrowserDetect.OS
  };
  
  (function(d, t) {
    var g = d.createElement(t), s = d.getElementsByTagName(t)[0], params = [];
    for(var item in data) params.push(item + '=' + encodeURIComponent(data[item]));
    g.async = true;
    g.src = ('https:' == location.protocol ? 'https://' : 'http://') + 'localhost:3000/track?' + params.join("&");
    s.parentNode.insertBefore(g, s);
  })(document, 'script');
  
})();