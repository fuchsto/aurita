
/** XHConn - Simple XMLHTTP Interface - bfults@gmail.com - 2005-04-08        **
 ** Code licensed under Creative Commons Attribution-ShareAlike License      **
 ** http://creativecommons.org/licenses/by-sa/2.0/                           **/
function XHConn()
{
  var xmlhttp, bComplete = false;
  var request_url = false; 

  try {
      //    netscape.security.PrivilegeManager.enablePrivilege("UniversalBrowserRead");
  } catch (eperm) {
    alert("Permission UniversalBrowserRead denied.");
  }

  this.req_url = function() { 
    return request_url;
  };

  try { xmlhttp = new ActiveXObject("Msxml2.XMLHTTP"); }
  catch (ea) { try { xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); }
  catch (eb) { try { xmlhttp = new XMLHttpRequest(); }
  catch (ec) { xmlhttp = false; }}}
  if (!xmlhttp) { return null; }

  this.abort = function() { 
    xmlhttp.abort(); 
  }
  
  //this.connect = function(sURL, sVars, fnDone, element)
  this.connect = function(sURL, sMethod, fnDone, element, postVars, onload_fun) {
  
      var request_url = sURL; 

      if(postVars === undefined) { postVars = ""; }
      if (!xmlhttp) { return false; } 
      bComplete = false;

      try {
        if(sMethod == 'GET') { 
        //  sURL += '&randseed='+Math.round(Math.random()*100000);
            //    sMethod = sMethod.toUpperCase();
            //    xmlhttp.open(sMethod, sURL+"?"+sVars, true);
            xmlhttp.open(sMethod, sURL, true);
            sVars = ""; 
        }
        else {
            xmlhttp.open(sMethod, sURL, true);
            xmlhttp.setRequestHeader("Method", "POST "+sURL+" HTTP/1.1");
            xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        }
        xmlhttp.onreadystatechange = function() {
          if (xmlhttp.readyState == 4 && !bComplete) {
            bComplete = true;
            try { 
              Aurita.Tracker.track(request_url); // closure var
            } catch(e) { 
              log_debug("could not resolve tracker"); 
            } 
            if(fnDone) { 
//            fnDone(xmlhttp, element, sMethod, onload_fun);
              fnDone(xmlhttp, { element: element, onload: onload_fun, method: sMethod });
            }
          }
        };
        xmlhttp.send(postVars); 
      }
      catch(z) { 
        alert(z);  
        return false; 
      }
      return true;
  };

  this.get_string = function(sURL, responseFun, sMethod, postVars) {

   result = '';
   if(postVars == undefined) { postVars = ""; }
   if(sMethod == undefined) { sMethod = 'GET'; }
      if (!xmlhttp) return false;
      bComplete = false;

      try {
        if(sMethod == 'GET') { 
            //    sMethod = sMethod.toUpperCase();
            //    xmlhttp.open(sMethod, sURL+"?"+sVars, true);
            xmlhttp.open(sMethod, sURL, true);
            sVars = ""; 
        }
        else {
            xmlhttp.open(sMethod, sURL, true);
            xmlhttp.setRequestHeader("Method", "POST "+sURL+" HTTP/1.1");
            xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        }
        xmlhttp.onreadystatechange = function() {
          if (xmlhttp.readyState == 4 && !bComplete) {
            bComplete = true;
            responseFun(xmlhttp.responseText);
          }
        };
        xmlhttp.send(postVars); 
      }
      catch(z) { 
        alert(z);  
        return false; 
      }
      return result;
  };
  
  return this;
}

