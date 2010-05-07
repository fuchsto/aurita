
///////////////////////////////////////////////////////
// BEGIN log
///////////////////////////////////////////////////////

function log_debug(message) { 
  if(window.console && window.console.log) { 
    window.console.log(message); 
  } 
  if(document.getElementById('developer_console')) { 
    document.getElementById('developer_console').innerHTML += (message + '<hr />');
  }
}

function clear_log() { 
  document.getElementById('developer_console').innerHTML = ''; 
}
function hide_log() { 
  app             = document.getElementById('app_body');
  console_element = document.getElementById('debug_box'); 
  app.removeChild(console_element); 
}

///////////////////////////////////////////////////////
// END log
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN helpers
///////////////////////////////////////////////////////

date_obj = new Date(); 

var Browser = {
    is_ie    : document.all&&document.getElementById,
    is_gecko : document.getElementById&&!document.all
};

function element_exists(id)
{
    return (document.getElementById(id) != undefined);
}
function add_event( obj, type, fn )
{
   if (obj.addEventListener) {
      obj.addEventListener( type, fn, false );
   } else if (obj.attachEvent) {
      obj["e"+type+fn] = fn;
      obj[type+fn] = function() { obj["e"+type+fn]( window.event ); }
      obj.attachEvent( "on"+type, obj[type+fn] );
   }
}

function remove_event( obj, type, fn )
{
   if (obj.removeEventListener) {
      obj.removeEventListener( type, fn, false );
   } else if (obj.detachEvent) {
      obj.detachEvent( "on"+type, obj[type+fn] );
      obj[type+fn] = null;
      obj["e"+type+fn] = null;
   }
}

function position_of(obj) 
{
    var curleft = curtop = 0;
    if (obj.offsetParent) {
      curleft = obj.offsetLeft
      curtop = obj.offsetTop
      while (obj = obj.offsetParent) {
        curleft += obj.offsetLeft
        curtop += obj.offsetTop
      }
    }
    return [curleft,curtop];
}

function getPageScroll(){

  var yScroll;

  if (self.pageYOffset) {
    yScroll = self.pageYOffset;
  } else if (document.documentElement && document.documentElement.scrollTop){  // Explorer 6 Strict
    yScroll = document.documentElement.scrollTop;
  } else if (document.body) {// all other Explorers
    yScroll = document.body.scrollTop;
  }

  arrayPageScroll = new Array('',yScroll) 
  return arrayPageScroll;
}

var mouse_x = 0; 
var mouse_y = 0; 
function capture_mouse(ev) 
{
    if(!ev) { ev = window.event; }
    if(!ev) { return ; }

// Is IE
    if(Browser.is_ie) { 
      mouse_x = ev.clientX;  // ignore horizontal scroll
      mouse_y = ev.clientY + getPageScroll()[1]; 
    }
// Is Gecko
    else if (Browser.is_gecko) { 
      mouse_x = ev.pageX; 
      mouse_y = ev.pageY; 
    }
//    Element.setStyle('context_menu_icon', { left: (mouse_x+5)+'px', top: (mouse_y+5)+'px' });
//    window.status = mouse_x + 'x' + mouse_y; 
}
function get_mouse(event) 
{
    return [mouse_x, mouse_y];
}

function get_style(el, style) 
{
    if(!document.getElementById) return;
    var value = el.style[style];
    
    if(!value) { 
      if(document.defaultView) {
        value = document.defaultView.getComputedStyle(el, "").getPropertyValue(style);
      } else if(el.currentStyle) { 
        value = el.currentStyle[style];
      }
    }
    return value; 
}

function is_mouse_over(obj)
{
    if(!obj) { return; } 
    width = parseInt(Element.getWidth(obj)); 
    height = parseInt(Element.getHeight(obj));
    if(!width) { width = obj.offsetWidth; }
    if(!height) { width = obj.offsetheight; }
    pos = position_of(obj);
    x = pos[0];
    y = pos[1];
    
    if(obj.style.x) { x = obj.style.x; }
    if(obj.style.y) { y = obj.style.y; }
    
    if(mouse_x >= x && mouse_x <= x+width &&
       mouse_y >= y && mouse_y <= y+height) {
      window.status = 'OVER MENU '+mouse_x+' '+mouse_y; 
      return true; 
    } 
    else {
      return false; 
    }
}

function rgb_to_hex(str)
{
    var pattern = /\([^\)]+\)/gi;
    var result = ''+str.match(pattern);

    result = result.replace(/\(/,'').replace(/\)/,'');

    var hex = '#';
    tmp = result.split(', ');

    for (m=0; m<3; m++) {
      value = (tmp[m]*1).toString(16);
      if(value.length < 2) { value = '0'+value; }
      hex += value;
    }
    return hex;
}

var last_hovered_element = false; 
function hover_element(elem_id) { 
  if(last_hovered_element) { 
    try { 
      Element.removeClassName($(last_hovered_element), 'hovered'); 
    } catch(e) { }
  }
  Element.addClassName($(elem_id), 'hovered'); 
  last_hovered_element = elem_id; 
}
function unhover_element(elem_id) { 
  Element.removeClassName($(elem_id), 'hovered'); 
}

function focus_element(element_id)
{
    Element.addClassName(element_id, 'highlighted'); 
    Element.setStyle(element_id, {zIndex: 301});
}
function unfocus_element(element_id)
{
    if(element_exists(element_id)) {
      Element.removeClassName(element_id, 'highlighted'); 
      Element.setStyle(element_id, {zIndex: 1});
    }
}

function swap_style(style, value_1, value_2, target)
{
    obj = document.getElementById(target); 
    style_curr = obj.style[style]; 
    
    obj.style[style] = value_1; 
    if(obj.style[style] == style_curr) {
      obj.style[style] = value_2; 
    }
}

function swap_value(element_id, value_1, value_2)
{
    obj = document.getElementById(element_id); 
    value_curr = obj.value; 
    
    obj.value = value_1; 
    if(obj.value == value_curr) {
      obj.value = value_2; 
    }
    
}


function resizeable_popup(w, h, url)
{
    LeftPosition = (screen.width) ? (screen.width-w)/2 : 0;
    TopPosition = (screen.height) ? (screen.height-h)/2 : 0;
    settings = 'height='+h+',width='+w+',top='+TopPosition+',left='+LeftPosition+',scrollbars=1,resizable=1,menubar=0,fullscreen=0,status=0';
    win = window.open(url,"popup",settings);
    win.focus();
}

function checkbox_swap(element)
{
    if(element.checked == true) {
      element.value = '1'; 
    }
    else {
      element.value = '0'; 
    }
}

function alert_array(arr) { 
  s = ''; 
  for(var e in arr) { 
    s += (e + ' | ' + arr[e]); 
  } 
  alert(s); 
}

function insert_at_cursor(textarea_element_id, text) { 
  textarea = $(textarea_element_id); 
  //IE 
  if (document.selection) {
    textarea.focus();
    sel = document.selection.createRange();
    sel.text = text;
  }
  //MOZILLA
  else if (textarea.selectionStart || textarea.selectionStart == 0) {
    var startPos = textarea.selectionStart;
    var endPos = textarea.selectionEnd;
    textarea.value = textarea.value.substring(0, startPos)
    + text
    + textarea.value.substring(endPos, textarea.value.length);
  } else {
    textarea.value += text;
  }
}


///////////////////////////////////////////////////////
// END helpers
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN cookie
///////////////////////////////////////////////////////

/**
 * Sets a Cookie with the given name and value.
 *
 * name       Name of the cookie
 * value      Value of the cookie
 * [expires]  Expiration date of the cookie (default: end of current session)
 * [path]     Path where the cookie is valid (default: path of calling document)
 * [domain]   Domain where the cookie is valid
 *              (default: domain of calling document)
 * [secure]   Boolean value indicating if the cookie transmission requires a
 *              secure transmission
 */
function setCookie(name, value, expires, path, domain, secure) {
    path = '/'; 
    document.cookie= name + "=" + escape(value) +
        ((expires) ? "; expires=" + expires.toGMTString() : "") +
        ((path) ? "; path=" + path : "") +
        ((domain) ? "; domain=" + domain : "") +
        ((secure) ? "; secure" : "");
}

/**
 * Gets the value of the specified cookie.
 *
 * name  Name of the desired cookie.
 *
 * Returns a string containing value of specified cookie,
 *   or null if cookie does not exist.
 */
function getCookie(name) {
    var dc = document.cookie;
    var prefix = name + "=";
    var begin = dc.indexOf("; " + prefix);
    if (begin == -1) {
        begin = dc.indexOf(prefix);
        if (begin != 0) return null;
    } else {
        begin += 2;
    }
    var end = document.cookie.indexOf(";", begin);
    if (end == -1) {
        end = dc.length;
    }
    return unescape(dc.substring(begin + prefix.length, end));
}

/**
 * Deletes the specified cookie.
 *
 * name      name of the cookie
 * [path]    path of the cookie (must be same as path used to create cookie)
 * [domain]  domain of the cookie (must be same as domain used to create cookie)
 */
function deleteCookie(name, path, domain) {
    path = '/'; 
    if (getCookie(name)) {
        document.cookie = name + "=" +
            ((path) ? "; path=" + path : "") +
            ((domain) ? "; domain=" + domain : "") +
            "; expires=Thu, 01-Jan-70 00:00:01 GMT";
    }
}

///////////////////////////////////////////////////////
// END cookie
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN xhconn
///////////////////////////////////////////////////////

/** XHConn - Simple XMLHTTP Interface - bfults@gmail.com - 2005-04-08        **
 ** Code licensed under Creative Commons Attribution-ShareAlike License      **
 ** http://creativecommons.org/licenses/by-sa/2.0/                           **/
function XHConn()
{
  var xmlhttp, bComplete = false;
  var request_url = false; 

  try {
      //    netscape.security.PrivilegeManager.enablePrivilege("UniversalBrowserRead");
  } catch (e) {
    alert("Permission UniversalBrowserRead denied.");
  }

  this.req_url = function() { 
    return request_url;
  }

  try { xmlhttp = new ActiveXObject("Msxml2.XMLHTTP"); }
  catch (e) { try { xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); }
  catch (e) { try { xmlhttp = new XMLHttpRequest(); }
  catch (e) { xmlhttp = false; }}}
  if (!xmlhttp) return null;

  this.abort = function() { 
    xmlhttp.abort(); 
  }
  
  //this.connect = function(sURL, sVars, fnDone, element)
  this.connect = function(sURL, sMethod, fnDone, element, postVars, onload_fun) {
  
      request_url = sURL; 

      if(postVars == undefined) { postVars = ""; }
      if (!xmlhttp) return false;
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
            if(fnDone) { 
              fnDone(xmlhttp, element, sMethod, onload_fun);
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


///////////////////////////////////////////////////////
// END xhconn
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN md5
///////////////////////////////////////////////////////
/*
 *  md5.js 1.0b 27/06/96
 *
 * Javascript implementation of the RSA Data Security, Inc. MD5
 * Message-Digest Algorithm.
 *
 * Copyright (c) 1996 Henri Torgemane. All Rights Reserved.
 *
 * Permission to use, copy, modify, and distribute this software
 * and its documentation for any purposes and without
 * fee is hereby granted provided that this copyright notice
 * appears in all copies.
 *
 * Of course, this soft is provided "as is" without express or implied
 * warranty of any kind.
 *
 *
 * Modified with german comments and some information about collisions.
 * (Ralf Mieke, ralf@miekenet.de, http://mieke.home.pages.de)
 */



function array(n) {
  for(i=0;i<n;i++) this[i]=0;
  this.length=n;
}



/* Einige grundlegenden Funktionen müssen wegen
 * Javascript Fehlern umgeschrieben werden.
 * Man versuche z.B. 0xffffffff >> 4 zu berechnen..
 * Die nun verwendeten Funktionen sind zwar langsamer als die Originale,
 * aber sie funktionieren.
 */

function integer(n) { return n%(0xffffffff+1); }

function shr(a,b) {
  a=integer(a);
  b=integer(b);
  if (a-0x80000000>=0) {
    a=a%0x80000000;
    a>>=b;
    a+=0x40000000>>(b-1);
  } else
    a>>=b;
  return a;
}

function shl1(a) {
  a=a%0x80000000;
  if (a&0x40000000==0x40000000)
  {
    a-=0x40000000;
    a*=2;
    a+=0x80000000;
  } else
    a*=2;
  return a;
}

function shl(a,b) {
  a=integer(a);
  b=integer(b);
  for (var i=0;i<b;i++) a=shl1(a);
  return a;
}

function and(a,b) {
  a=integer(a);
  b=integer(b);
  var t1=(a-0x80000000);
  var t2=(b-0x80000000);
  if (t1>=0)
    if (t2>=0)
      return ((t1&t2)+0x80000000);
    else
      return (t1&b);
  else
    if (t2>=0)
      return (a&t2);
    else
      return (a&b);
}

function or(a,b) {
  a=integer(a);
  b=integer(b);
  var t1=(a-0x80000000);
  var t2=(b-0x80000000);
  if (t1>=0)
    if (t2>=0)
      return ((t1|t2)+0x80000000);
    else
      return ((t1|b)+0x80000000);
  else
    if (t2>=0)
      return ((a|t2)+0x80000000);
    else
      return (a|b);
}

function xor(a,b) {
  a=integer(a);
  b=integer(b);
  var t1=(a-0x80000000);
  var t2=(b-0x80000000);
  if (t1>=0)
    if (t2>=0)
      return (t1^t2);
    else
      return ((t1^b)+0x80000000);
  else
    if (t2>=0)
      return ((a^t2)+0x80000000);
    else
      return (a^b);
}

function not(a) {
  a=integer(a);
  return (0xffffffff-a);
}

/* Beginn des Algorithmus */

    var state = new array(4);
    var count = new array(2);
        count[0] = 0;
        count[1] = 0;
    var buffer = new array(64);
    var transformBuffer = new array(16);
    var digestBits = new array(16);

    var S11 = 7;
    var S12 = 12;
    var S13 = 17;
    var S14 = 22;
    var S21 = 5;
    var S22 = 9;
    var S23 = 14;
    var S24 = 20;
    var S31 = 4;
    var S32 = 11;
    var S33 = 16;
    var S34 = 23;
    var S41 = 6;
    var S42 = 10;
    var S43 = 15;
    var S44 = 21;

    function F(x,y,z) {
        return or(and(x,y),and(not(x),z));
    }

    function G(x,y,z) {
        return or(and(x,z),and(y,not(z)));
    }

    function H(x,y,z) {
        return xor(xor(x,y),z);
    }

    function I(x,y,z) {
        return xor(y ,or(x , not(z)));
    }

    function rotateLeft(a,n) {
        return or(shl(a, n),(shr(a,(32 - n))));
    }

    function FF(a,b,c,d,x,s,ac) {
        a = a+F(b, c, d) + x + ac;
        a = rotateLeft(a, s);
        a = a+b;
        return a;
    }

    function GG(a,b,c,d,x,s,ac) {
        a = a+G(b, c, d) +x + ac;
        a = rotateLeft(a, s);
        a = a+b;
        return a;
    }

    function HH(a,b,c,d,x,s,ac) {
        a = a+H(b, c, d) + x + ac;
        a = rotateLeft(a, s);
        a = a+b;
        return a;
    }

    function II(a,b,c,d,x,s,ac) {
        a = a+I(b, c, d) + x + ac;
        a = rotateLeft(a, s);
        a = a+b;
        return a;
    }

    function transform(buf,offset) {
        var a=0, b=0, c=0, d=0;
        var x = transformBuffer;

        a = state[0];
        b = state[1];
        c = state[2];
        d = state[3];

        for (i = 0; i < 16; i++) {
            x[i] = and(buf[i*4+offset],0xff);
            for (j = 1; j < 4; j++) {
                x[i]+=shl(and(buf[i*4+j+offset] ,0xff), j * 8);
            }
        }

        /* Runde 1 */
        a = FF ( a, b, c, d, x[ 0], S11, 0xd76aa478); /* 1 */
        d = FF ( d, a, b, c, x[ 1], S12, 0xe8c7b756); /* 2 */
        c = FF ( c, d, a, b, x[ 2], S13, 0x242070db); /* 3 */
        b = FF ( b, c, d, a, x[ 3], S14, 0xc1bdceee); /* 4 */
        a = FF ( a, b, c, d, x[ 4], S11, 0xf57c0faf); /* 5 */
        d = FF ( d, a, b, c, x[ 5], S12, 0x4787c62a); /* 6 */
        c = FF ( c, d, a, b, x[ 6], S13, 0xa8304613); /* 7 */
        b = FF ( b, c, d, a, x[ 7], S14, 0xfd469501); /* 8 */
        a = FF ( a, b, c, d, x[ 8], S11, 0x698098d8); /* 9 */
        d = FF ( d, a, b, c, x[ 9], S12, 0x8b44f7af); /* 10 */
        c = FF ( c, d, a, b, x[10], S13, 0xffff5bb1); /* 11 */
        b = FF ( b, c, d, a, x[11], S14, 0x895cd7be); /* 12 */
        a = FF ( a, b, c, d, x[12], S11, 0x6b901122); /* 13 */
        d = FF ( d, a, b, c, x[13], S12, 0xfd987193); /* 14 */
        c = FF ( c, d, a, b, x[14], S13, 0xa679438e); /* 15 */
        b = FF ( b, c, d, a, x[15], S14, 0x49b40821); /* 16 */

        /* Runde 2 */
        a = GG ( a, b, c, d, x[ 1], S21, 0xf61e2562); /* 17 */
        d = GG ( d, a, b, c, x[ 6], S22, 0xc040b340); /* 18 */
        c = GG ( c, d, a, b, x[11], S23, 0x265e5a51); /* 19 */
        b = GG ( b, c, d, a, x[ 0], S24, 0xe9b6c7aa); /* 20 */
        a = GG ( a, b, c, d, x[ 5], S21, 0xd62f105d); /* 21 */
        d = GG ( d, a, b, c, x[10], S22,  0x2441453); /* 22 */
        c = GG ( c, d, a, b, x[15], S23, 0xd8a1e681); /* 23 */
        b = GG ( b, c, d, a, x[ 4], S24, 0xe7d3fbc8); /* 24 */
        a = GG ( a, b, c, d, x[ 9], S21, 0x21e1cde6); /* 25 */
        d = GG ( d, a, b, c, x[14], S22, 0xc33707d6); /* 26 */
        c = GG ( c, d, a, b, x[ 3], S23, 0xf4d50d87); /* 27 */
        b = GG ( b, c, d, a, x[ 8], S24, 0x455a14ed); /* 28 */
        a = GG ( a, b, c, d, x[13], S21, 0xa9e3e905); /* 29 */
        d = GG ( d, a, b, c, x[ 2], S22, 0xfcefa3f8); /* 30 */
        c = GG ( c, d, a, b, x[ 7], S23, 0x676f02d9); /* 31 */
        b = GG ( b, c, d, a, x[12], S24, 0x8d2a4c8a); /* 32 */

        /* Runde 3 */
        a = HH ( a, b, c, d, x[ 5], S31, 0xfffa3942); /* 33 */
        d = HH ( d, a, b, c, x[ 8], S32, 0x8771f681); /* 34 */
        c = HH ( c, d, a, b, x[11], S33, 0x6d9d6122); /* 35 */
        b = HH ( b, c, d, a, x[14], S34, 0xfde5380c); /* 36 */
        a = HH ( a, b, c, d, x[ 1], S31, 0xa4beea44); /* 37 */
        d = HH ( d, a, b, c, x[ 4], S32, 0x4bdecfa9); /* 38 */
        c = HH ( c, d, a, b, x[ 7], S33, 0xf6bb4b60); /* 39 */
        b = HH ( b, c, d, a, x[10], S34, 0xbebfbc70); /* 40 */
        a = HH ( a, b, c, d, x[13], S31, 0x289b7ec6); /* 41 */
        d = HH ( d, a, b, c, x[ 0], S32, 0xeaa127fa); /* 42 */
        c = HH ( c, d, a, b, x[ 3], S33, 0xd4ef3085); /* 43 */
        b = HH ( b, c, d, a, x[ 6], S34,  0x4881d05); /* 44 */
        a = HH ( a, b, c, d, x[ 9], S31, 0xd9d4d039); /* 45 */
        d = HH ( d, a, b, c, x[12], S32, 0xe6db99e5); /* 46 */
        c = HH ( c, d, a, b, x[15], S33, 0x1fa27cf8); /* 47 */
        b = HH ( b, c, d, a, x[ 2], S34, 0xc4ac5665); /* 48 */

        /* Runde 4 */
        a = II ( a, b, c, d, x[ 0], S41, 0xf4292244); /* 49 */
        d = II ( d, a, b, c, x[ 7], S42, 0x432aff97); /* 50 */
        c = II ( c, d, a, b, x[14], S43, 0xab9423a7); /* 51 */
        b = II ( b, c, d, a, x[ 5], S44, 0xfc93a039); /* 52 */
        a = II ( a, b, c, d, x[12], S41, 0x655b59c3); /* 53 */
        d = II ( d, a, b, c, x[ 3], S42, 0x8f0ccc92); /* 54 */
        c = II ( c, d, a, b, x[10], S43, 0xffeff47d); /* 55 */
        b = II ( b, c, d, a, x[ 1], S44, 0x85845dd1); /* 56 */
        a = II ( a, b, c, d, x[ 8], S41, 0x6fa87e4f); /* 57 */
        d = II ( d, a, b, c, x[15], S42, 0xfe2ce6e0); /* 58 */
        c = II ( c, d, a, b, x[ 6], S43, 0xa3014314); /* 59 */
        b = II ( b, c, d, a, x[13], S44, 0x4e0811a1); /* 60 */
        a = II ( a, b, c, d, x[ 4], S41, 0xf7537e82); /* 61 */
        d = II ( d, a, b, c, x[11], S42, 0xbd3af235); /* 62 */
        c = II ( c, d, a, b, x[ 2], S43, 0x2ad7d2bb); /* 63 */
        b = II ( b, c, d, a, x[ 9], S44, 0xeb86d391); /* 64 */

        state[0] +=a;
        state[1] +=b;
        state[2] +=c;
        state[3] +=d;

    }
    /* Mit der Initialisierung von Dobbertin:
       state[0] = 0x12ac2375;
       state[1] = 0x3b341042;
       state[2] = 0x5f62b97c;
       state[3] = 0x4ba763ed;
       gibt es eine Kollision:

       begin 644 Message1
       M7MH=JO6_>MG!X?!51$)W,CXV!A"=(!AR71,<X`Y-IIT9^Z&8L$2N'Y*Y:R.;
       39GIK9>TF$W()/MEHR%C4:G1R:Q"=
       `
       end

       begin 644 Message2
       M7MH=JO6_>MG!X?!51$)W,CXV!A"=(!AR71,<X`Y-IIT9^Z&8L$2N'Y*Y:R.;
       39GIK9>TF$W()/MEHREC4:G1R:Q"=
       `
       end
    */
    function init() {
        count[0]=count[1] = 0;
        state[0] = 0x67452301;
        state[1] = 0xefcdab89;
        state[2] = 0x98badcfe;
        state[3] = 0x10325476;
        for (i = 0; i < digestBits.length; i++)
            digestBits[i] = 0;
    }

    function update(b) {
        var index,i;

        index = and(shr(count[0],3) , 0x3f);
        if (count[0]<0xffffffff-7)
          count[0] += 8;
        else {
          count[1]++;
          count[0]-=0xffffffff+1;
          count[0]+=8;
        }
        buffer[index] = and(b,0xff);
        if (index  >= 63) {
            transform(buffer, 0);
        }
    }

    function finish() {
        var bits = new array(8);
        var        padding;
        var        i=0, index=0, padLen=0;

        for (i = 0; i < 4; i++) {
            bits[i] = and(shr(count[0],(i * 8)), 0xff);
        }
        for (i = 0; i < 4; i++) {
            bits[i+4]=and(shr(count[1],(i * 8)), 0xff);
        }
        index = and(shr(count[0], 3) ,0x3f);
        padLen = (index < 56) ? (56 - index) : (120 - index);
        padding = new array(64);
        padding[0] = 0x80;
        for (i=0;i<padLen;i++)
          update(padding[i]);
        for (i=0;i<8;i++)
          update(bits[i]);

        for (i = 0; i < 4; i++) {
            for (j = 0; j < 4; j++) {
                digestBits[i*4+j] = and(shr(state[i], (j * 8)) , 0xff);
            }
        }
    }

/* Ende des MD5 Algorithmus */

function hexa(n) {
 var hexa_h = "0123456789abcdef";
 var hexa_c="";
 var hexa_m=n;
 for (hexa_i=0;hexa_i<8;hexa_i++) {
   hexa_c=hexa_h.charAt(Math.abs(hexa_m)%16)+hexa_c;
   hexa_m=Math.floor(hexa_m/16);
 }
 return hexa_c;
}


var ascii="01234567890123456789012345678901" +
          " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ"+
          "[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";

function MD5(nachricht)
{
 var l,s,k,ka,kb,kc,kd;

 init();
 for (k=0;k<nachricht.length;k++) {
   l=nachricht.charAt(k);
   update(ascii.lastIndexOf(l));
 }
 finish();
 ka=kb=kc=kd=0;
 for (i=0;i<4;i++) ka+=shl(digestBits[15-i], (i*8));
 for (i=4;i<8;i++) kb+=shl(digestBits[15-i], ((i-4)*8));
 for (i=8;i<12;i++) kc+=shl(digestBits[15-i], ((i-8)*8));
 for (i=12;i<16;i++) kd+=shl(digestBits[15-i], ((i-12)*8));
 s=hexa(kd)+hexa(kc)+hexa(kb)+hexa(ka);
 return s;
}
///////////////////////////////////////////////////////
// END md5
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN aurita
///////////////////////////////////////////////////////

var Aurita = {
  last_username: '', 
  username_input_element: '0', 
  loading_icon: '<img src="/aurita/images/icons/loading.gif" />'
}; 

Aurita.check_if_internet_explorer = function() {
  var nAgt = navigator.userAgent;
  if (nAgt.indexOf("MSIE") != -1) {
    return 1;
  }
  else {
    return 0;
  }
};


Aurita.random = function(length) {
  if(!length) length = 4; 
  return Math.round(Math.random() * Math.exp(10,length)); 
}; 

Aurita.element = function(dom_id) { 
  try { 
    elem = $(dom_id); 
  } catch(e) { 
    elem = false; 
  }
  return elem; 
}; 

Aurita.eval_response = function(response) { 
  if(!response) return; 
  try { 
    return eval('('+response+')'); 
  } catch(excep) { 
    log_debug('Error in eval_response: ' + excep); 
    return; 
  }
}; 

Aurita.get_remote_string = function(action, response_fun, method, postVars) { 
  var xml_conn = new XHConn; 

  req_url = '/aurita/'+action+'&mode=none'; 
  if(method == 'POST') { 
    req_url = action; 
  }
  xml_conn.get_string(req_url, response_fun, method, postVars);
}; 

Aurita.check_username_available = function(result) { 
  if(result.match('true')) { 
      Element.setStyle(Aurita.username_input_element, { 'border-color': '#00ff00' });
  } else { 
      Element.setStyle(Aurita.username_input_element, { 'border-color': '#ff0000' });
  }
};

Aurita.username_available = function(input_element) { 
  if(input_element.value == Aurita.last_username) { return; }
  Aurita.username_input_element = input_element; 
  Aurita.last_username = input_element.value; 
  Aurita.get_remote_string('User_Group/username_available/user_group_name='+input_element.value, 
                           Aurita.check_username_available);
};

Aurita.async_form_submit = function(form_element, params) { 
  context_menu_autoclose = true; 
  target_url   = '/aurita/dispatch'; 
  postVars     = Form.serialize(form_element);

  postVars    += '&mode=async'; 
  // postVarsHash = Form.serialize(form_element, true); 
  
  var xml_conn = new XHConn; 
  element = Aurita.element('dispatcher'); 
  onload_fun = function() { };
  if(params) { onload_fun = params['onload']; }
  xml_conn.connect(target_url, 'POST', Aurita.update_element, element, postVars, onload_fun); 
};

Aurita.handle_form_error = function() { 
  for (var i=0; i < arguments.length; i++) {
    info = arguments[i];
    try { 
      // Get input element by attribute 'name' that is 
      // known from exception: 
      elm  = $$('input[name="' + info.field + '"]').first();
      // Get wrapper by DOM id, which is the same as 
      // the input field's id with '_wrap' appended: 
      wrapper = $(elm.id + '_wrap'); 
      Element.addClassName(wrapper, 'error'); 
      Element.removeClassName(warpper, 'invalid'); 
    } catch(e) { } 
  }
  try { 
    if(Aurita.context_menu_opened()) { 
      Element.setOpacity('context_menu', 1.0); 
    }
  } catch(e) { } 
};

Aurita.cancel_form = function(form) { 
  try { 
    Aurita.Editor.flush_all(); 
    if(Aurita.context_menu.is_opened()) { 
      Element.hide('context_menu'); 
      Aurita.context_menu_close(); 
    } 
    else { 
      history.back(); 
    }
  } catch(e) { } 
  return true; 
}; 

Aurita.submit_form = function(form, params) { 
  try { Aurita.Editor.flush_all(); } catch(e) { } 
  Aurita.async_form_submit(form, params); 
};

Aurita.waiting_for_file_upload = false; 
Aurita.submit_upload_form = function(form_id) { 
  if(Aurita.waiting_for_file_upload) { 
    alert('Ein anderer Upload ist noch aktiv');
    return false;
  }

  if($('public_media_asset_title') && $('autocomplete_tags') && 
//   ($('public_media_asset_title').value == '' || $('autocomplete_tags').value == '')) 
     ($('autocomplete_tags').value == '')) 
  { 
    alert('Bitte machen Sie alle erforderlichen Angaben'); 
    return false; 
  }
  Aurita.waiting_for_file_upload = true; 

  try { Aurita.Editor.save_all(); } catch(e) { } 
  Element.toggle(form_id); 
  
  Element.hide('context_menu'); 
  setTimeout('Aurita.context_menu_close()', 2000); 

  $(form_id).submit(); 
  // Delay closing context menu so form values 
  // remain intact at the moment of submit: 
  Aurita.close_info_badge(); 
  new Effect.SlideDown('file_upload_indicator'); 
  if(!Aurita.context_menu_opened()) { 
    setTimeout('Aurita.after_submit_upload_form()', 2000); 
  }
  return false; 
}; 

Aurita.after_submit_upload_form = function() { 
  Aurita.load({ action: 'Wiki::Media_Asset/after_add' }); 
}; 

Aurita.after_file_upload = function() { 
  if(Aurita.waiting_for_file_upload) {
    new Effect.SlideUp('file_upload_indicator'); 
    Aurita.waiting_for_file_upload = false; 
    Aurita.open_info_badge('Wiki::Media_Asset/after_file_upload');
  }
};

Aurita.info_badge_opened = false; 
Aurita.open_info_badge = function(action) { 
  Aurita.close_info_badge(); 
  Aurita.load({ element: 'info_badge', 
                action: action, 
                onload: function() { new Effect.SlideDown('info_badge'); Aurita.info_badge_opened = true; } });
} 
Aurita.close_info_badge = function() { 
  if(Aurita.info_badge_opened) { 
    new Effect.SlideUp('info_badge');
    Aurita.info_badge_opened = false; 
  }
}

Aurita.form_field_onfocus = function(element_id) { 
  Element.addClassName(element_id+'_wrap', 'focussed' ); 
  Element.addClassName(element_id, 'focussed' );
  return true; 
};

Aurita.form_field_onblur = function(element_id) { 
  Element.removeClassName(element_id+'_wrap', 'focussed' ); 
  Element.removeClassName(element_id, 'focussed' );
  return true; 
};

Aurita.handle_invalid_field = function(element) { 
  Element.addClassName(element, 'invalid');
  Element.addClassName(element.id+'_wrap', 'invalid');
}; 

Aurita.validate_form_field_value = function(element, data_type, required) { 
  if(required && (!element.value || element.value == '')) { 
    Aurita.handle_invalid_field(element); 
    return false; 
  }
  switch(data_type) { 
    // Varchar
    case 1043: break; // every input matches varchar
    case 1015: break; // every input matches varchar[]
  }
  // All tests passed, set to valid state again if 
  // failed before: 
  Element.removeClassName(element, 'invalid');
  Element.removeClassName(element.id+'_wrap', 'invalid');
  Element.removeClassName(element.id+'_wrap', 'error');
  return true; 
};


Aurita.flash = function(mesg) { 
  alert(mesg); 
}

Aurita.hierarchy_node_select_onchange = function(field, attribute_name, level) { 
  Aurita.load({ element: attribute_name + '_' + level + '_next', 
                action : 'Wiki::Media_Asset_Folder/hierarchy_node_select_level/media_folder_id__parent='+field.value+'&level='+(level+1) }); 
  $(attribute_name).value = field.value; 
}


///// XHR ///////////////////////////////

Aurita.update_targets            = {}; 
Aurita.current_interface_calls   = {}; 
Aurita.completed_interface_calls = {}; 
Aurita.last_hashvalue            = ''; 
Aurita.wait_for_iframe_sync      = false; 

Aurita.set_ie_history_fix_iframe_src = function(code) 
{ 
  if(Aurita.wait_for_iframe_sync) { 
    return; 
  } 
  var code_url = '/aurita/App_Main/blank/mode=none&code=' + code; 
  $('ie_fix_history_frame').src = code_url;
};
Aurita.set_hashcode = function(code) 
{
  log_debug('set_hashcode: '+code); 
  if(Aurita.check_if_internet_explorer() == 1) {
    Aurita.set_ie_history_fix_iframe_src(code);
  }
  document.location.hash = code; 
  Aurita.force_load = true; 
  Aurita.check_hashvalue(); 
}; 

Aurita.after_update_element = function(element) {
  try { Aurita.Editor.init_all(); } catch(e) { } 
}; 

Aurita.on_successful_submit = function() { 
  context_menu_close(); 
}; 

Aurita.convert_response = function(xml_conn)
{
  response_text = xml_conn.responseText; 
  response = { error: false, script: false, html: response_text }; 

  response_script = false; 
  if(response_text.substr(0, 6) == '{ html')
  { 
    log_debug("Convert response html"); 
    try { 
      json_response = eval('(' + response_text + ')'); 
    } catch(excep) { 
      log_debug('Error in eval on response: ' + excep); 
      return; 
    }
    response_html   = json_response.html.replace('\"','"'); 
    response_script = json_response.script.replace('\"','"'); 
    response_error  = json_response.error; 
    if(response_error) { 
      response_error = json_response.error.replace('\"','"'); 
    }
  } 
  else if(response_text.substr(0,8) == '{ script' ) 
  {
    log_debug("Convert response script"); 
    try { 
      json_response = eval('(' + response_text + ')'); 
    } catch(excep) { 
      log_debug('Error in eval on response: ' + excep); 
      return; 
    }
    response_html   = ''
    response_error  = false; 
    response_script = json_response.script.replace('\"','"'); 
  } 
  else if(response_text.substr(0,7) == '{ error' ) 
  {
    log_debug("Convert response error"); 
    try { 
      json_response   = eval('(' + response_text + ')'); 
    } catch(excep) { 
      log_debug('Error in eval on response: ' + excep); 
      return; 
    }
    response_text   = ''
    response_html   = false; 
    response_script = false; 
    Aurita.update_targets = { }; // Break dispatch chain on error, 
                                 // prohibit further actions in interface
    response_error = json_response.error.replace('\"','"'); 
  } 
  else if(response_text.replace(/\s/g,'') == '') { 
    Aurita.on_successful_submit(); 
  }

  response_debug  = json_response.debug; 
  return { html: response_html, error: response_error, script: response_script, debug: response_debug };
};

Aurita.update_element_silently = function(xml_conn, element, request_method, onload_fun)
{
    if(element) { log_debug('Aurita.update_element_silently ' + element.id); }
    else        { log_debug('Aurita.update_element_silently: Target element undefined!'); }

    response_script = false; 
    response_error = false; 
    if(element) 
    {
      response = Aurita.convert_response(xml_conn); 
      response_html   = response['html']; 
      response_script = response['script']; 
      response_error  = response['error']; 
      response_debug  = response['debug'];
      if(response_debug) { log_debug(response_debug); }

      if(response_html) { 
        element.innerHTML = response_html; 
      }
    }
    if(response_script) { eval(response_script); }
    if(response_error)  { eval(response_error);  }

    if(onload_fun) { onload_fun(); }
}; 

Aurita.replace_element_silently = function(xml_conn, element, request_method, onload_fun)
{
    if(element) { log_debug('Aurita.update_element_silently ' + element.id); }
    else        { log_debug('Aurita.update_element_silently: Target element undefined!'); }

    response_script = false; 
    response_error  = false; 
    if(element) 
    {
      response = Aurita.convert_response(xml_conn); 
      response_html   = response['html']; 
      response_script = response['script']; 
      response_error  = response['error']; 
      response_debug  = response['debug'];
      if(response_debug) { log_debug(response_debug); }

      if(response_html) { 
      //  element.innerHTML = response_html; 
        element.replace(response_html); 
      }
    }
    if(response_script) { eval(response_script); }
    if(response_error)  { eval(response_error);  }

    if(onload_fun) { onload_fun(); }
}; 

Aurita.update_element = function(xml_conn, element, request_method, onload_fun)
{
    if(element) { log_debug('Aurita.update_element: ' + element.id); }
    else        { log_debug('Aurita.update_element: No target element'); }

    response = Aurita.convert_response(xml_conn); 
    response_html   = response['html']; 
    response_script = response['script']; 
    response_error  = response['error']; 
    response_debug  = response['debug'];
    // See Cuba::Controller.render_view
    if(element) 
    {
      try { Element.setOpacity(element, 1.0); } catch(e) { }

      if(response_debug) { log_debug(response_debug); }

      // When to close context menu (no error and no html response, or target element
      // is not context menu)
      if(!response_error && (!element || !response_html))
      {
        try { Aurita.context_menu_close(); } catch(e) { } 
      } 
      if(response_error) // aurita wants to tell us something
      {
        eval(response_error); 
      }
      element.innerHTML = response_html; 
    }
    if(onload_fun) { 
      onload_fun(element); 
    }
    if(response_script) { eval(response_script.replace('\"','"')); }

    if(Aurita.update_targets) {
      for(var target in Aurita.update_targets) {
        if(Aurita.update_targets[target]) { 
          url = Aurita.update_targets[target].replace('.','/');
          Aurita.load({ element: target, action: url }); 
        }
      }
      // Reset targets so they will be set in next load/remote_submit call: 
      Aurita.update_targets = null; 
    }
    Aurita.after_update_element(element); 
}; 

Aurita.before_load_url = function(element) { 
  try { Element.setOpacity(element, 0.5); } catch(e) { } 
  try { Aurita.Editor.save_all(); } catch(e) { } 
}

Aurita.current_request = false; 
Aurita.load_url = function(params)
{
  log_debug('entering load_url'); 
  target_id = params['element']; 
  if(!target_id) { target_id = 'app_main_content'; }

  element = Aurita.element(target_id); 
  if(!params['silently']) { 
    log_debug('Before load');
    Aurita.before_load_url(element); 
  }

  if(target_id == 'app_main_content' && !params['no_hashvalue'] && !params['onload']) { 
    log_debug('redirect to set_hashcode'); 
    Aurita.current_hashvalue = params['action']; 
    Aurita.last_hashvalue    = params['action']; 
    Aurita.set_hashcode(params['action']);
    return; 
  }

  req_url = ''; 

  if(params['action']) { 
    action_url  = params['action'];
    action_url  = action_url.replace('/aurita/',''); 
    // Are there any params in the request URI?
    if(action_url.match('=')) { 
      action_url += '&'; 
    } else { 
      // If none, does request URI end in a forward slash? 
      if(!action_url.match(/^(.+)\/$/)) { action_url += '/'; }
    }
    action_url += ('element=' + element.id);
    call_arr    = action_url.replace(/([^\/]+)\/([^\/]+)[\/&]?(.+)?/,'$1.$2').replace('/','').split('.');
    model       = call_arr[0]; 
    method      = call_arr[1]; 
    postVars    = 'controller=' + model; 
    postVars   += '&action=' + method; 
    if(!params['mode']) { 
      params['mode'] = 'async';
    }
    postVars += ('&mode=' + params['mode'] + '&');
//  postVars += ('&element=' + element.id + '&');
    postVars += action_url.replace(/([^\/]+)\/([^\/]+)[\/&]?(.+)?/,'$3').replace('/',''); 
    req_url = '/aurita/dispatch'; 
  } 
  else if(params['url']) { 
    req_url = params['url'];
    postVars      = '';
  }
  if(params['silently']) { 
    update_fun = Aurita.update_element_silently; 
  } 
  else if(params['replace']) { 
    update_fun = Aurita.replace_element_silently; 
  } 
  else { 
    log_debug('LOAD URL'); 
    update_fun = Aurita.update_element; 
  }

  log_debug("Dispatch interface "+req_url);
  
  Aurita.update_targets = params['targets']; 

  var xml_conn = new XHConn; 

  if(params['method'] == 'POST') { 
    xml_conn.connect(req_url, 'POST', update_fun, element, postVars, params['onload']); 
  }
  else { 
    action_url = '/aurita/' + action_url + '&mode=async'; 
    xml_conn.connect(action_url, 'GET', update_fun, element, '', params['onload']); 
  }
}; 

Aurita.prevent_default_onclick = false; 
Aurita.load = function(params) {
  try { 
    Aurita.prevent_default_onclick = true; 
    Aurita.load_url(params); 
    return false; 
    try { 
      if(window.event) { 
//          stopPropagation = true; 
//          window.event.cancelBubble = true; 
      }
    } catch(e) {  } 
  } catch(e) { 
    log_debug(e); 
    return false; 
  } 
  return false; 
}; 

Aurita.display_widget = function(widget_response) { 
    widget = Aurita.eval_response(widget_response); 
    if(!widget && widget['html']) { return; } 
    widget = widget['html']; 
    $('app_main_content').innerHTML = widget; 
}; 

/* This returns an implicit closure - be careful with frequent calls! */
Aurita.load_widget_to = function(element) { 
  return function(widget_response) { 
    widget = Aurita.eval_response(widget_response); 
    if(!widget && widget['html']) { return; } 
    widget_html  = widget['html']; 

    $(element).innerHTML = widget_html; 

    if(widget['script']) { 
      init_script = widget['script'].replace('\"','"'); 
      eval(init_script); 
    }
  }
}; 

/* This returns an implicit closure - be careful with frequent calls! */
Aurita.append_widget_to = function(element) { 
  return function(widget_response) { 
    widget = Aurita.eval_response(widget_response); 
    if(!widget && widget['html']) { return; } 
    widget = widget['html']; 
    widget_element = document.createElement('span');
    widget_element.innerHTML = widget; 
    $(element).appendChild(widget_element); 
  }
}; 

Aurita.load_widget = function(widget_name, params, handle_fun) { 
  try { 
    if(widget_name.indexOf('(') != -1) {
      // Parameters are appended to widget name, like 
      //   Text_Field({ name: 'some_text' })

      params_part = widget_name.slice(widget_name.indexOf('(')+1, widget_name.indexOf(')'));
      params      = eval('(' +params_part + ')');
      widget_name = widget_name.slice(0,widget_name.indexOf('('));
    }
    params_string = 'controller=Widget_Service&action=get&widget='+widget_name;
    for(param_name in params) { 
      params_string += '&' + param_name + '=' + params[param_name];
    }
    if(!handle_fun) { handle_fun = Aurita.display_widget; } 
    Aurita.get_remote_string('/aurita/poll', handle_fun, 'POST', params_string); 
  } catch(excep) { 
    log_debug('Could not load widget '+widget_name+'('+params_string+')');
  }
}; 

Aurita.load_silently = function(params) {
  try { 
    if(!$(params['element'])) { 
      log_debug('Target for Aurita.load_silently does not exist: '+params['target']+', using default'); 
    }
    params['targets']  = params['redirect_after']; 
    params['silently'] = true; 
    Aurita.load_url(params); 
    return false; 
  } catch(e) { 
    log_debug(e); 
    return false; 
  } 
}; 

Aurita.call = function(url_req) { 
  if(url_req['action']) { 
    url_req['element'] = 'dispatcher';
    Aurita.load(url_req); 
  }
  else {
    Aurita.load({ action: url_req, element: 'dispatcher' }); 
  }
}; 

Aurita.get_ie_history_fix_iframe_code = function() 
{
  hashcode = false
  try { 
    // Requesting the src attribute is faster, as iframe does not have to be loaded, 
    // but this method is prohibited in most cases: 
    hashcode = parent.ie_fix_history_frame.location.href; 
    hashcode = hashcode.replace(/(.+)?code=([^&]+)/g,"$2"); 
  } catch(e) { }
  return hashcode; 
}

Aurita.current_hashvalue = false; 
Aurita.check_hashvalue = function()
{
    Aurita.current_hashvalue = document.location.hash.replace('#',''); 

    if(Aurita.current_hashvalue.match(/(.+)?_anchor/)) { return;  } 

    if(Aurita.check_if_internet_explorer() == 1) { // IE REACT
      if(Aurita.force_load) { 
        iframe_hashvalue = Aurita.current_hashvalue; 
      }
      else { 
        iframe_hashvalue = Aurita.get_ie_history_fix_iframe_code(); 
      } 

      // Case: Backbutton
      if(iframe_hashvalue && 
      // iframe_hashvalue != 'no_code' && 
         iframe_hashvalue != Aurita.current_hashvalue && 
         !Aurita.force_load && 
         iframe_hashvalue != '' && 
         !iframe_hashvalue.match('about:')) 
      { 
//      if(Aurita.current_hashvalue && Aurita.current_hashvalue != '' && iframe_hashvalue == 'no_code') { 
//        Aurita.current_hashvalue = 'App_General/main/';
//      }
        if(Aurita.current_hashvalue && Aurita.current_hashvalue != '' && iframe_hashvalue != 'no_code') { 
          Aurita.current_hashvalue = iframe_hashvalue; 
        }
      }
    }

    if(Aurita.force_load || Aurita.current_hashvalue != Aurita.last_hashvalue && Aurita.current_hashvalue != '') 
    { 
      log_debug('check_hashvalue load'); 
      window.scrollTo(0,0);

      log_debug('last: ' + Aurita.last_hashvalue); 
      log_debug('new: ' + Aurita.current_hashvalue); 
      Aurita.last_hashvalue = Aurita.current_hashvalue;
      action = Aurita.current_hashvalue.replace(/--/g,'/').replace(/-/,'=');

      Aurita.load({ action: action, 
                    no_hashvalue: true, 
                    onload: function() { Aurita.wait_for_iframe_sync = false; } }); 
      Aurita.force_load = false; 
    } 
}; 

Aurita.last_feedback = { }; 
Aurita.handle_feedback = function(response) 
{
  if(!response) return; 
  try { 
    feedback = eval('('+response+')'); 
  } catch(excep) { 
    log_debug('Error in eval on response: ' + excep); 
    return; 
  }

  if(feedback.unread_mail && Aurita.last_feedback.unread_mail != feedback.unread_mail) { 
    log_debug('-- unread_mail: '+feedback.unread_mail); 
    if(feedback.unread_mail == 0) {
      feedback.unread_mail = ''; 
      $('mailbox_icon').src = '/aurita/images/icons/mailbox.gif'; 
      Element.hide('mail_notifier'); 
    }
    else { 
      feedback.unread_mail = '(' + feedback.unread_mail + ')'; 
      $('mailbox_icon').src = '/aurita/images/icons/mailbox_alert.gif'; 
      $('mail_notifier').innerHTML = feedback.unread_mail; 
      Element.show('mail_notifier'); 
    }
  }
  Aurita.last_feedback = feedback; 
}; 

Aurita.poll_feedback = function()
{
  Aurita.get_remote_string('Async_Feedback/get/x=1', Aurita.handle_feedback); 
}; 

Aurita.confirmed_interface = ''; 
Aurita.unconfirmed_action =  '';  
Aurita.message_box = undefined; 
Aurita.on_confirm_action = false; 

Aurita.after_confirmed_action = function(xml_conn, element) 
{
  // do nothing
}; 

// Usage: 
// <span onclick="Aurita.confirmable({ action: 'Community::Forum_Post/delete/forum_post_id=123', 
//                                     message: 'Really delete post?', 
//                                     onconfirm: function() { alert('Post deleted'); }
//                                  });" >
//   delete post
// </span>
Aurita.confirmable = function(params) {
  req_url = params['action']; 
  message = params['message']; 
  Aurita.message_box = new Aurita.MessageBox({ action: 'App_Main/confirmation_box/message='+message }); 
  Aurita.unconfirmed_action = req_url; 
  if(params['onconfirm']) { 
    Aurita.on_confirm_action = params['onconfirm']; 
  } 
  else { 
    Aurita.on_confirm_action = false; 
  }
  Aurita.message_box.open();
}; 
Aurita.confirm_action = function() { 
  Aurita.call({ action: Aurita.unconfirmed_action, 
                onupdate: Aurita.after_confirmed_action });
  if(Aurita.on_confirm_action) { Aurita.on_confirm_action(); }
  Aurita.message_box.close(); 
}; 
Aurita.cancel_action = function() { 
  Aurita.message_box.close(); 
}; 

Aurita.tabs = {}; 
Aurita.register_tab_group = function(tab_params) { 
  Aurita.tabs[tab_params.tab_group_id] = tab_params; 
}

var active_messaging_button = false;
Aurita.tab_click = function(tab_group_id, tab_id, tab_name)
{
  tab_params = Aurita.tab_register[tab_group_id]; 
  tabs = tab_params.tabs; 
  
  for(t in tabs) { 
    Element.removeClassName(t, 'active');
  }
  Element.addClassName(tab_id, 'active');

  action_url = tab_params.actions[tab_id]; 

  Aurita.load({ element: tab_content_id, action: action_url }); 
}

Aurita.poll_load = function(elem_id, url, seconds)
{
  setInterval(function() { 
    Aurita.load({ element: elem_id, action: url, silently: true }) 
  }, seconds * 1000);
}; 

Aurita.poll_call = function(elem_id, url, seconds)
{
  setInterval(function() { 
    Aurita.call({ element: elem_id, action: url, silently: true }) 
  }, seconds * 1000);
} 



///////////////////////////////////////////////////////
// END aurita
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN error
///////////////////////////////////////////////////////

Aurita.notify_error = function(error_code, form_element, message) { 
  Element.setStyle(form_element_id, { borderColor: '#990000' } ); 
  if(message) { 
    $(form_element_id+'_message').innerHTML = message; 
    Element.show(form_element_id+'_message'); 
  }
  try { Element.show(button_id+'_form_buttons'); } catch(e) {}; 
  try { Element.show('main_form_buttons'); } catch(e) {};  
  try { if(Aurita.context_menu.is_opened()) { Element.setOpacity('context_menu', 1.0); } } catch(e) {}; 
  init_all_editors(); 
}

///////////////////////////////////////////////////////
// END error
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN backbutton
///////////////////////////////////////////////////////


function PageLocator(propertyToUse, dividingCharacter) {
    this.propertyToUse = propertyToUse;
    this.defaultQS = 1;
    this.dividingCharacter = dividingCharacter;
}
PageLocator.prototype.getLocation = function() {
    return eval(this.propertyToUse);
}
PageLocator.prototype.getHash = function() {
    var url = this.getLocation();
    if(url.indexOf(this.dividingCharacter) > -1) {
        var url_elements = url.split(this.dividingCharacter);
        return url_elements[url_elements.length-1];
    } else {
        return this.defaultQS;
    }
}
PageLocator.prototype.getHref = function() {
    var url = this.getLocation();
    var url_elements = url.split(this.dividingCharacter);
    return url_elements[0];
}
PageLocator.prototype.makeNewLocation = function(new_qs) {
    return this.getHref() + this.dividingCharacter + new_qs;
}


///////////////////////////////////////////////////////
// END backbutton
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN message_box
///////////////////////////////////////////////////////

Aurita.MessageBox = function(params)
{
    var m_action       = params['action'];
    var m_content      = params['content']; 
    var m_is_draggable = (params['draggable'] != false); 
    var m_draggable    = false; 

    var fill_box = function(message_string) { 
      $('message_box').innerHTML = message_string; 
      show(); 
    };
    var show = function()
    {
      $('message_box').show(); 
      Aurita.GUI.center_element('message_box');
      if(m_is_draggable) { 
        m_draggable = new Draggable('message_box'); 
      }
    };
    
    this.open = function()
    {
      if(m_content) { 
        $('message_box').innerHTML = m_content; 
        show(); 
      } else {
        Aurita.get_remote_string(m_action, fill_box); 
      }
      m_opened = true; 
      if(m_is_draggable) { 
        m_draggable = new Draggable('message_box'); 
      }
    };

    this.load = function() { 
      Aurita.load({ action: m_action, 
                    element: 'message_box', 
                    silently: true, 
                    onload: function() { 
                      Aurita.message_box = this;
                      Aurita.GUI.center_element('message_box');
                      $('message_box').show(); 
                    }});
    };

    this.close = function() {
      $('message_box').innerHTML = ''; 
      Element.setStyle('message_box', { 'display': 'none' });
      if(m_draggable) { 
        m_draggable.destroy(); 
      }
    };

}

///////////////////////////////////////////////////////
// END message_box
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN aurita_gui
///////////////////////////////////////////////////////
Aurita.GUI = { 

  init_left : function(element)
  {
     log_debug('init left'); 
     Aurita.GUI.collapse_boxes(); 
//   Sortable.create('left_column_components');
     Element.show(element); 
  }, 
  init_main : function(element)
  {
     log_debug('init main'); 
     Aurita.GUI.collapse_boxes(); 
//   Sortable.create('workspace_components');
     Element.show(element); 
  }, 
        
  load_layout : function(setup_name)
  {
    log_debug('load layout '+setup_name); 
    Aurita.load({ element: 'app_left_column', action: setup_name+'/left/', onload: function() { Element.show('app_left_column'); } } ); 
    Aurita.load({ action: setup_name+'/main/' }); 

    body_elem = $('app_body'); 
    body_elem.removeAttribute('class'); 
    body_elem.addClassName('site_body'); 
    body_elem.addClassName(setup_name); 
  }, 

  active_button : false, 
  switch_layout : function(setup_name)
  {
    Element.hide('app_left_column'); 
//    Element.hide('app_main_content'); 
    if(active_button) { 
      active_button.className = 'header_button';
    }

    active_button = document.getElementById('button_'+setup_name.replace('::','__')); 
    active_button.className = 'header_button_active';

    Aurita.GUI.load_layout(setup_name); 
    return; 

    setTimeout(function() { Aurita.GUI.load_layout(setup_name) }, 550); 
  }, 


  toggle_box : function(box_id) { 
    log_debug('toggling '+box_id); 

    collapsed_boxes = getCookie('collapsed_boxes'); 
    if(collapsed_boxes) { 
      collapsed_boxes = collapsed_boxes.split('-'); 
    } else { 
      collapsed_boxes = []; 
    }
    if($('collapse_icon_'+box_id).src.match('plus.gif')) { 
      $('collapse_icon_'+box_id).src = '/aurita/images/icons/minus.gif'
      box_id_string = ''
      for(b=0; b<collapsed_boxes.length; b++) {
        bid = collapsed_boxes[b]; 
        if(bid != box_id) { 
          box_id_string +=  bid + '-';
        }
      }
      setCookie('collapsed_boxes', box_id_string); 
      log_debug('Slide down'); 
//    new Effect.SlideDown(box_id + '_body', { duration: 0.5 });
      Element.show(box_id + '_body'); 
    } else { 
      collapsed_boxes.push(box_id); 
      setCookie('collapsed_boxes', collapsed_boxes.join('-')); 
      $('collapse_icon_'+box_id).src = '/aurita/images/icons/plus.gif'
      log_debug('Slide up'); 
//    new Effect.SlideUp(box_id + '_body', { duration: 0.5 });
      Element.hide(box_id + '_body'); 
    }
  }, 

  close_box : function(box_id) { 
    if($(box_id + '_body')) { 
      Element.hide(box_id + '_body'); 
      $('collapse_icon_'+box_id).src = '/aurita/images/icons/plus.gif'
    }
  }, 

  collapse_boxes : function() 
  {
     collapsed_boxes = getCookie('collapsed_boxes'); 
     if(collapsed_boxes) {
       collapsed_boxes = collapsed_boxes.split('-'); 
       for(b=0; b<collapsed_boxes.length; b++) { 
         box_id = collapsed_boxes[b]; 
         if($(box_id)) { 
           Aurita.GUI.close_box(box_id); 
         }
       }
     }
  }, 

  calendar : false, 
  open_calendar : function(field_id, button_id)
  {
    log_debug('opening calendar'); 
    
    var onSelect = function(calendar, date) { 
      $(field_id).value = date; 
      if (calendar.dateClicked) {
          calendar.callCloseHandler(); // this calls "onClose" (see above)
      };
    }
    var onClose = function(calendar) { calendar.hide(); }; 

    Aurita.GUI.calendar = new Calendar(1, null, onSelect, onClose);
    Aurita.GUI.calendar.create(); 
    Aurita.GUI.calendar.showAtElement($(field_id), 'Bl'); 
  }, 


  set_dialog_link : function(url) { 
    plaintext = Aurita.temp_range.text; 
    url = 'http://' + url.replace('http://',''); 
    if(Aurita.check_if_internet_explorer() == '1') { 
      marker_key = 'find_and_replace_me';
      Aurita.temp_range.text = marker_key; 
      editor_html = Aurita.temp_editor_instance.getBody().innerHTML; 
      pos = editor_html.indexOf(marker_key); 
      if(pos != -1) { 
        Aurita.temp_editor_instance.getBody().innerHTML = editor_html.substring(0,pos) + '<a href="'+url+'" target="_blank">'+plaintext+'</a>' + editor_html.substring(pos+marker_key.length);
      }
    } 
    else 
    { 
      tinyMCE.execInstanceCommand(Aurita.temp_editor_id, 'mceInsertRawHTML', false, '<a href="'+url+'" target="_blank">'+Aurita.temp_range+'</a>');
    }
    Aurita.context_menu_close(); 
  }, 

  center_element : function(element_id) { 
    var d = document; 
    var rootElm = (d.documentelement && d.compatMode == 'CSS1Compat') ? d.documentelement : d.body

    var vpw = self.innerWidth ? self.innerWidth : rootElm.clientWidth; // viewport width 
    var vph = self.innerHeight ? self.innerHeight : rootElm.clientHeight; // viewport height 

    var elem_width  = $(element_id).getWidth(); 
    var elem_height = $(element_id).getHeight(); 

    var scroll_top = (window.pageYOffset)? window.pageYOffset : document.scrollTop; 

    var pos_left = ((vpw - elem_width) / 2); 
    var pos_top  = ((scroll_top + vph) - (elem_height/2)); 

    new Effect.Move(element_id, { 
      x: pos_left, 
      y: scroll_top + 50, 
//    y: 120, 
      mode: 'absolute', 
      afterFinish: function() { Element.show(element_id); }, 
      duration: 0
    });
  }, 
  
  reorder_hierarchy_id : false, 
  on_hierarchy_entry_reorder : function(entry)
  {
      position_values = Sortable.serialize(entry.id);
      Aurita.load_silently({ element: 'dispatcher', 
                             method: 'POST', 
                             action: 'Hierarchy/perform_reorder/' + position_values + '&hierarchy_id=' + reorder_hierarchy_id }); 
  }, 

  init_sortable_components : function(container, params) { 
    params['format']   = /^component_(.+)$/;
    params['onUpdate'] = function(container) { 
      position_values = Sortable.serialize(container.id); 
      Aurita.call({ method: 'POST', 
                    action: 'Component_Position/set/'+position_values+'&context='+container.id }); 
    }
    Sortable.create(container, params)
  }, 

  Autocomplete : function(element_id, params) { 
    var elem_id       = element_id;
    var params        = params;
    var poll          = false; 
    var autocompleter = this; 
    var last_key      = '';

    $(elem_id).observe('click', function(evt) { 
    //  if (params.onfocus) { params.onfocus(); }
    
      // use variable autocompleter here to reference back 
      // to the original instance, as we are in a closure 
      // here. 
      autocompleter.active = true; 
      autocompleter.poll   = setInterval(function() { 
        tkey = Form.Element.getValue($(elem_id)); 
        if (tkey.length > 2 && autocompleter.last_key != tkey) {
          autocompleter.last_key = tkey; 
          call_action = params.action + 'key=' + tkey;
          if (params.onupdate) { params.onupdate(); }
          Aurita.load_silently({ action: call_action, 
                                 element: params.element, 
                                 method: 'POST', 
                                 onload: params.onload });
        }
      }, 400);
    });
    $(elem_id).observe('blur', function(evt) { 
      this.active = false; 
      clearInterval(poll);
      if (params.onblur) { params.onblur(); }
    });
  }, 

  Tooltip: Class.create({ 
    initialize: function(element, params) { 
      this.hover_elem = $(element); 
      this.box_elem   = $(params.tooltip); 

      this.hover_elem.observe('mouseover', this.show_box.bind(this));
      this.hover_elem.observe('mousemove', this.update_box_position.bind(this));
      this.hover_elem.observe('mouseout', this.hide_box.bind(this));
    }, 

    show_box : function(evt) { 
      this.box_elem.show(); 
    }, 
    update_box_position : function(evt) { 
      new Effect.Move(this.box_elem, { mode: 'absolute', 
                                       duration: 0,
                                       x: Event.pointerX(evt)-134, 
                                       y: Event.pointerY(evt)-60 });
    }, 
    hide_box : function(evt) { 
      this.box_elem.hide(); 
    }
  })

};


///////////////////////////////////////////////////////
// END aurita_gui
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN login
///////////////////////////////////////////////////////

var Login = { 

  check_success: function(success)
  {
    var failed = true; 

    if(success != "\n0\n") 
    { 
      user_params = eval(success); 
      if(user_params.session_id) {
        setCookie('cb_login', user_params.session_id, 0, '/'); 
        failed = false; 
      }
    }
    if(failed) 
    {
      new Effect.Shake('login_box'); 
    }
    else { 
      new Effect.Fade('login_box', {queue: 'front', duration: 1}); 
//    new Effect.Appear('start_button', {queue: 'end', duration: 1}); 
      document.location.href = '/aurita/App_Main/start/';
    }
  },

  remote_login: function(login, pass)
  {
    login = MD5(login); 
    pass  = MD5(pass); 
    Aurita.get_remote_string('App_Main/validate_user/mode=async&login='+login+'&pass='+pass, Login.check_success); 
  }

} // Namespace Login

///////////////////////////////////////////////////////
// END login
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN main
///////////////////////////////////////////////////////

Aurita.Main = { 

  init_login_screen : function(element) {
    new Effect.Appear('login_box',{duration: 2, to: 1.0}); 
  }, 

  autocomplete_username_handler : function(text, li)
  {
    generic_id = text.id; 
  }, 
  
  init_autocomplete_tags : function()
  {
    new Ajax.Autocompleter("autocomplete_tags", 
                           "autocomplete_tags_choices", 
                           "/aurita/poll", 
                           { 
                             minChars: 2, 
                             tokens: [' ',',','\n'], 
                             frequency: 0.1, 
                             parameters: 'controller=Autocomplete&action=tags&mode=none'
                           }
    );
  }, 

  autocomplete_single_tag : function(li)
  {
    tag = li.id.replace('tag_',''); 
    Aurita.load({ element: 'tag_form', action: 'Tag_Synonym/show/tag='+tag });
    return true; 
  }, 

  init_autocomplete_tag_selection : function()
  {
    new Ajax.Autocompleter("autocomplete_tags", 
                           "autocomplete_tags_choices", 
                           "/aurita/poll", 
                           { 
                             minChars: 2, 
                             tokens: [' ',',','\n'], 
                             frequency: 0.1, 
                             updateElement: Aurita.Main.autocomplete_single_tag, 
                             parameters: 'controller=Autocomplete&action=tags&mode=none'
                           }
    );
  }, 

  init_autocomplete_username : function()
  {
    new Ajax.Autocompleter("autocomplete_username", 
                           "autocomplete_username_choices", 
                           "/aurita/poll", 
                           { 
                             minChars: 2, 
                             tokens: [' ',',','\n'], 
                             frequency: 0.1, 
                             parameters: 'controller=Autocomplete&action=usernames&mode=none'
                           }
    );
  }, 

  autocomplete_selected_users : {}, 
  init_autocomplete_single_username : function()
  {
    Aurita.Main.autocomplete_selected_users = {}; 
    new Ajax.Autocompleter("autocomplete_username", 
                           "autocomplete_username_choices", 
                           "/aurita/poll", 
                           { 
                             minChars: 2, 
                             updateElement: Aurita.Main.autocomplete_single_username_handler, 
                             frequency: 0.1, 
                             tokens: [], 
                             parameters: 'controller=Autocomplete&action=usernames&mode=none'
                           }
    );
  }, 

  autocomplete_single_username_handler : function(li)
  {
    $('autocomplete_username').value = ''; 
    uname = li.innerHTML.replace(/^.+<b>([^>]+?)<\/b>.+$/i,'$1'); // username is in <b> tag
    uid = li.id.replace('user__',''); 
    entry =  '<li id="user_group_id_'+uid+'">'
    entry += '<input type="hidden" name="user_group_ids[]" value="'+uid+'" />'
    entry += '<a class="icon" onclick="Element.remove(\'user_group_id_'+uid+'\');"><img src="/aurita/images/icons/delete_small.png" /></a>'+uname+'</li>';
    $('user_group_ids_selected_options').innerHTML += entry; 

    return true; 
  }, 

  category_selection_add : function(category_field_id)
  {
    var category_select_field_id = category_field_id + '_select'; 
    var category_list_id         = category_field_id + '_selected_options';
    var category_id              = $F(category_select_field_id); // Selected value of category select field
    var selected_option          = $A($(category_select_field_id).options).find(function(option) { return option.selected; } );
    category_name                = selected_option.text; 

    entry =  '<li id="public_category_category_id_'+category_id+'">'
    entry += '<input type="hidden" name="category_ids[]" value="'+category_id+'" />'
    entry += '<a class="icon" onclick="Element.remove(\'public_category_category_id_'+category_id+'\');"><img src="/aurita/images/icons/delete_small.png" /></a>'+category_name+'</li>';
    $(category_list_id).innerHTML += entry; 

    Element.remove(selected_option); 
    return true; 
  } 

}; 

///////////////////////////////////////////////////////
// END main
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN wiki
///////////////////////////////////////////////////////

Aurita.Wiki = { 

  autocomplete_article_handler : function(text, li) { 
    plaintext = Aurita.temp_range.text; 
    if(Aurita.check_if_internet_explorer() == '1') { 
      marker_key = 'find_and_replace_me';
      Aurita.temp_range.text = marker_key; 
      editor_html = Aurita.temp_editor_instance.getBody().innerHTML; 
      pos = editor_html.indexOf(marker_key); 
      if(pos != -1) { 
        Aurita.temp_editor_instance.getBody().innerHTML = editor_html.substring(0,pos) + '<a href="#'+text.id.replace('__','--')+'">'+plaintext+'</a>' + editor_html.substring(pos+marker_key.length);
      }
    } 
    else 
    { 
      tinyMCE.execInstanceCommand(Aurita.temp_editor_id, 'mceInsertRawHTML', false, '<a href="#'+text.id.replace('__','--')+'">'+plaintext+'</a>');
    }
    context_menu_close(); 
  }, 

  autocomplete_link_article_handler : function(text, li) { 
    plaintext = Aurita.temp_range.text; 
    hashcode = text.id.replace('__','--'); 
    onclick = "Aurita.set_hashcode(&apos;"+hashcode+"&apos;); "; 
    if(Aurita.check_if_internet_explorer() == '1') { 
      marker_key = 'find_and_replace_me';
      Aurita.temp_range.text = marker_key; 
      editor_html = Aurita.temp_editor_instance.getBody().innerHTML; 
      pos = editor_html.indexOf(marker_key); 
      if(pos != -1) { 
        Aurita.temp_editor_instance.getBody().innerHTML = editor_html.substring(0,pos) + '<a href="#'+hashcode+'" onclick="'+onclick+'">'+plaintext+'</a>' + editor_html.substring(pos+marker_key.length);
      }
    } 
    else 
    { 
      tinyMCE.execInstanceCommand(Aurita.temp_editor_id, 'mceInsertRawHTML', false, '<a href="#'+hashcode+'" onclick="'+onclick+'">'+Aurita.temp_range+'</a>');
    }
    context_menu_close(); 
  }, 

  init_autocomplete_articles : function(xml_conn, element, update_source)
  {
    element.innerHTML = xml_conn.responseText; 
    new Ajax.Autocompleter("autocomplete_article", 
                           "autocomplete_article_choices", 
                           "/aurita/poll", 
                           { 
                             minChars: 2, 
                             updateElement: autocomplete_article_handler, /* TODO: Handler doesn't exist any more?! */
                             tokens: [' ',',','\n']
                           }
    );
  }, 

  init_link_autocomplete_articles : function()
  {
    new Ajax.Autocompleter("autocomplete_link_article", 
                           "autocomplete_link_article_choices", 
                           "/aurita/poll", 
                           { 
                             minChars: 2, 
                             updateElement: autocomplete_link_article_handler, 
                             tokens: [' ',',','\n'], 
                             parameters: 'controller=Autocomplete&action=articles&mode=async'
                           }
    );
  }, 

  on_article_reorder : function(container)
  {
    position_values = Sortable.serialize(container.id);
    Aurita.call({ method : 'POST', 
                  action : 'Wiki::Article/perform_reorder/' + position_values + 
                           '&content_id_parent=' + Aurita.Wiki.reorder_article_content_id }); 
  }, 

  init_article_reorder : function(article_content_id)
  {
      Aurita.Wiki.reorder_article_content_id = article_content_id; 
      Sortable.create("article_partials_list", 
                      { dropOnEmpty: true, 
                        onUpdate: Aurita.Wiki.on_article_reorder, 
                        handle: true }); 
  }, 

  init_article : function(xml_conn, element, update_source)
  {
      element.innerHTML = xml_conn.responseText; 
  }, 

  attachment_text_asset_content_id : false, 
  init_container_attachment_editor : function(article_id, text_asset_content_id) { 
    
  }, 

  handle_container_attachment : function(widget_response) { 
    widget = Aurita.eval_response(widget_response); 
    if(!widget && widget['html']) { return; } 
    widget = widget['html']; 

    $('selected_media_assets').innerHTML += widget; 
  }, 

  // mark_image : function(image_index, media_asset_content_id, media_asset_id, thumbnail_suffix, desc)
  add_container_attachment : function(media_asset_id) 
  {
    Aurita.load_widget('Wiki::Media_Asset_Selection_Thumbnail', 
                       { media_asset_id: media_asset_id, size: 'tiny' }, 
                       Aurita.Wiki.handle_container_attachment); 
  }, 

  init_container_inline_editor : function(xml_conn, element, update_source)
  {
      element.innerHTML = xml_conn.responseText; 
      Element.setOpacity(element, 1.0); 
      init_all_editors(); 
  }, 

  opened_select_box : false, 
  select_media_asset : function(params) {
      var hidden_field_id = params['hidden_field']; 
      var user_id = params['user_id']; 
      var hidden_field = $(hidden_field_id); 
      var select_box_id = 'select_box_'+hidden_field_id;
      select_box = $(select_box_id); 
      Aurita.Wiki.opened_select_box = select_box; 
      Aurita.load({ element: select_box_id, 
                    action: 'Wiki::Media_Asset/choose_from_user_folders/user_group_id='+user_id+'&image_dom_id='+hidden_field_id }); 
      Element.setStyle(select_box, { display: 'block' });
      Element.setStyle(select_box, { width: '100%' });
  }, 

  select_media_asset_click : function(media_asset_id, element_id) { 
      var hidden_field = $(element_id);
      var image = $('picture_asset_'+element_id); 

      image.src = ''; 
      if(media_asset_id == 0) { 
        image.style.display = 'none';
        hidden_field.value = '1'; 
        $('clear_selected_image_button'+element_id).style.display = 'none'; 
      } else { 
        image.src = '/aurita/assets/medium/asset_'+media_asset_id+'.jpg';
        image.style.display = 'block';
        hidden_field.value = media_asset_id; 
        $('clear_selected_image_button_'+element_id).style.display = ''; 
      }
      try { 
        if(Aurita.Wiki.opened_select_box) { 
          Element.hide(Aurita.Wiki.opened_select_box); 
          Aurita.Wiki.opened_select_box = false; 
        }
      } catch(e) { }
  }, 

  expanded_folder_ids : {}, 
  load_media_asset_folder_level : function(parent_folder_id, indent) {
    if($('folder_expand_icon_'+parent_folder_id)) { 
      if($('folder_expand_icon_'+parent_folder_id).src.match('folder_collapse.gif')) { 
        $('folder_expand_icon_'+parent_folder_id).src = '/aurita/images/icons/folder_expand.gif'; 
        Aurita.Wiki.expanded_folder_ids[parent_folder_id] = false; 
        Element.hide('folder_children_'+parent_folder_id); 
        return;
      }
      else { 
        Element.show('folder_children_'+parent_folder_id); 
        Aurita.Wiki.expanded_folder_ids[parent_folder_id] = true; 
        $('folder_expand_icon_'+parent_folder_id).src = '/aurita/images/icons/folder_collapse.gif'; 
        if($('folder_children_'+parent_folder_id).innerHTML.length < 10) { 
          Aurita.load({ element: 'folder_children_'+parent_folder_id, 
                        action: 'Wiki::Media_Asset_Folder/tree_box_level/media_folder_id='+parent_folder_id+'&indent='+indent }); 
        }
      }
    }
  }, 

  open_folder : 0, 
  change_folder_icon : function(value) { 
    folder_to_open = $("folder_icon_" + value);
    folder_to_close = $("folder_icon_" + Aurita.Wiki.open_folder);
    if(folder_to_close) { 
      folder_to_close.src = "/aurita/images/icons/folder_closed.gif"; 
    }
    if(folder_to_open) { 
      folder_to_open.src = "/aurita/images/icons/folder_opened.gif"; 
    }
    Aurita.Wiki.open_folder = value;
  }, 

  recently_viewed : [], 
  recently_viewed_titles : [], 
  recently_viewed_models : [], 
  add_recently_viewed : function(model, asset_id, title) { 
    Aurita.Wiki.recently_viewed_titles[asset_id] = title; 
    Aurita.Wiki.recently_viewed_models[asset_id] = model; 

    if(Aurita.Wiki.recently_viewed.indexOf(asset_id) != -1) { 
      // remove previous appearance of asset_id from list: 
      Aurita.Wiki.recently_viewed.splice(Aurita.Wiki.recently_viewed.indexOf(asset_id), 1); 
    }
    else { 
      // remove last asset_id from list: 
      if(Aurita.Wiki.recently_viewed.length > 10) Aurita.Wiki.recently_viewed.shift(); 
    }
    Aurita.Wiki.recently_viewed.push(asset_id); 
    template = $('recently_viewed_element_template').innerHTML; 
    content = ''; 
    Aurita.Wiki.recently_viewed.reverse(); 
    for(i=0; i<Aurita.Wiki.recently_viewed.length; i++) {
      cid      = Aurita.Wiki.recently_viewed[i]; 
      title    = Aurita.Wiki.recently_viewed_titles[cid]; 
      model    = Aurita.Wiki.recently_viewed_models[cid];
      content += template.replace('__id__', cid).replace('__id__', cid).replace('__id__', cid).replace('{title}', title).replace('__model__', model); 
    }
    Aurita.Wiki.recently_viewed.reverse(); 
    $('recently_viewed_list').innerHTML = content; 
  }, 

  after_article_delete : function(deleted_article_id) { 
    entry = 'article_entry_'+deleted_article_id; 
    if($(entry)) { 
      new Effect.Pulsate(entry, { duration: 0.5, pulses: 2, queue: 'front' }); 
      new Effect.Fade(entry, { duration: 0.5, queue: 'end' }); 
    } 
    else { 
      Aurita.load_widget('Message_Box', { message: 'article_has_been_deleted' }); 
    } 
  }, 
  
  after_media_asset_delete : function(deleted_media_asset_id) { 
    reps = [ 'media_asset_entry_'+deleted_media_asset_id, 
             'wiki__media_asset_'+deleted_media_asset_id ];
    entry_found = false; 
    for(var i in reps) { 
      entry = reps[i];
      if($(entry)) { 
        entry_found = true; 
        new Effect.Pulsate(entry, { duration: 0.5, pulses: 2, queue: 'front' }); 
        new Effect.Fade(entry, { duration: 0.5, queue: 'end' }); 
      } 
    } 
    if(!entry_found) { 
      Aurita.load_widget('Message_Box', { message: 'file_has_been_deleted' }); 
    }
  }, 

  after_media_asset_folder_delete : function(deleted_folder_id) { 
    reps = [ 'media_asset_folder_entry_'+deleted_folder_id, 
             'wiki__media_asset_folder_'+deleted_folder_id ];
    entry_found = false; 
    for(var i in reps) { 
      entry = reps[i];
      if($(entry)) { 
        entry_found = true; 
        new Effect.Pulsate(entry, { duration: 0.5, pulses: 2, queue: 'front' }); 
        new Effect.Fade(entry, { duration: 0.5, queue: 'end' }); 
      } 
    } 
    if(!entry_found) { 
      Aurita.load_widget('Message_Box', { message: 'folder_has_been_deleted' }); 
    }
  }, 

  insert_link : function(article_id_element, url_element) { 
    var link_url = '';
    if($(article_id_element)) { 
      article_id = $(article_id_element).value; 
      link_url = 'Wiki::Article/show/id='+article_id; 
      var old_c = tinyMCE.activeEditor.selection.getContent(); 
      var new_c = '<a onclick="Aurita.load({ action: \''+link_url+'\');" href="#'+link_url+'">'+old_c+'</a>';
      tinyMCE.activeEditor.selection.setContent(new_c); 
      return; 
    }
    else { 
      link_url = $(url_element).value;
      if(link_url.indexOf(':') < 0 ) { link_url = 'http://' + link_url; }
      var old_c = tinyMCE.activeEditor.selection.getContent(); 
      var new_c = '<a href="'+link_url+'" target="_blank">'+old_c+'</a>';
      tinyMCE.activeEditor.selection.setContent(new_c); 
      return; 
    }
  }, 

  insert_file : function(media_asset_id, variant) { 
    var elm  = '';
//  var type = params['type'];
    var link_url  = 'Wiki::Media_Asset/show/id='+media_asset_id;
    if(variant == undefined || !variant) { 
      variant = 'thumb';
    }
    elm = '<img src="/aurita/assets/'+variant+'/asset_'+media_asset_id+'.jpg" />';
    tinyMCE.execCommand('mceInsertContent', false, elm);
    return;

    if(type == 'image') { 
      elm = '<img src="/aurita/assets/preview/asset_'+media_asset_id+'.jpg" />';
      tinyMCE.execCommand('mceInsertContent', false, elm);
    }
    else if(type == 'file') {
      if(tinyMCE.activeEditor.selection) { 
        var old_c = tinyMCE.activeEditor.selection.getContent(); 
        elm = '<a href="#'+link_url+'" onclick="Aurita.load({ action: \''+link_url+'\' });">'+old_c+'</a>'
        tinyMCE.activeEditor.selection.setContent(elm); 
      } 
      else { 
        elm = '<a href="#'+link_url+'" onclick="Aurita.load({ action: \''+link_url+'\' });">'+params['title']+'</a>'
        tinyMCE.execCommand('mceInsertContent', false, elm);
      }
    }
  }, 

  link_to_file : function(media_asset_id) { 
    var link_url = 'Wiki::Media_Asset/show/media_asset_id='+media_asset_id; 
    var old_c = tinyMCE.activeEditor.selection.getContent(); 
    elm = '<a href="#'+link_url+'" onclick="Aurita.load({ action: \''+link_url+'\' });">'+old_c+'</a>'
    tinyMCE.activeEditor.selection.setContent(elm); 
  }

};




///////////////////////////////////////////////////////
// END wiki
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN poll
///////////////////////////////////////////////////////

Poll_Editor = { 

  option_counter: 0, 
  option_amount: 0, 

  add_option: function() { 
    Poll_Editor.option_counter++; 
    Poll_Editor.option_amount++; 
    field = document.createElement('li');
    field.id = 'poll_option_entry_'+Poll_Editor.option_counter; 
    field.innerHTML = '<input type="text" class="polling_option" name="poll_option_'+Poll_Editor.option_counter+'" /><button onclick="Poll_Editor.remove_option('+Poll_Editor.option_counter+');" class="polling_option_button">-</button>';
    $('poll_options').appendChild(field);

    if(Poll_Editor.option_amount >= 2) { 
      Element.setStyle('poll_editor_submit_button', { display: '' }); 
    }
    if(Poll_Editor.option_amount > 10) { 
      Element.setStyle('poll_editor_add_option_button', { display: 'none' }); 
    }

    $('poll_editor_max_option_index').value = Poll_Editor.option_counter; 
  },
  remove_option: function(index) { 
    Poll_Editor.option_amount--; 
    Element.remove('poll_option_entry_'+index); 
    if(Poll_Editor.option_amount < 2) { 
      Element.setStyle('poll_editor_submit_button', { display: 'none' }); 
    }
    if(Poll_Editor.option_amount <= 10) { 
      Element.setStyle('poll_editor_add_option_button', { display: '' }); 
    }
  }, 

  init: function(xml_conn, element, update_source)
  {
    element.innerHTML = xml_conn.responseText; 

    Poll_Editor.option_counter = 0; 
    Poll_Editor.option_amount = 0; 
  }

}; 




///////////////////////////////////////////////////////
// END poll
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN publish
///////////////////////////////////////////////////////

Aurita.Publish = { 

  onload_page : function(page_id) { 
    Aurita.load({ element: 'background_selection_box_body', 
                  action: 'Publish::Page/background_selection_box_body/page_id='+page_id }); 
    Aurita.load({ element: 'banner_selection_list', 
                  action: 'Advert::Banner/selection_box_body/page_id='+page_id });
    Aurita.load({ element: 'marginal_selection_list', 
                  action: 'Publish::Marginal/selection_box_body/page_id='+page_id });
  }, 

  init_marginal_placement_editor : function(page_id) { 

    try { 
      Sortable.destroy('place_marginal_selection_list'); 
      Sortable.destroy('marginal_placements_left'); 
      Sortable.destroy('marginal_placements_right'); 
    } catch(e) { } 

    Sortable.create('place_marginal_selection_list', { 
      dropOnEmpty: true, 
      handle: 'header', 
      containment: [ 'place_marginal_selection_list', 'marginal_placements_right', 'marginal_placements_left' ] 
    });
    Sortable.create('marginal_placements_left', { 
      dropOnEmpty: true, 
      handle: 'header', 
      onUpdate: function(container) { 
        placements = Sortable.serialize(container.id); 
        Aurita.call({ method: 'POST', 
                      action: 'Publish::Marginal_Placement/perform_add/page_id='+page_id+'&'+placements+'&section=left' });
      }, 
      containment: [ 'place_marginal_selection_list', 'marginal_placements_right', 'marginal_placements_left' ] 
    });
    Sortable.create('marginal_placements_right', { 
      dropOnEmpty: true, 
      handle: 'header', 
      onUpdate: function(container) { 
        placements = Sortable.serialize(container.id); 
        Aurita.call({ method: 'POST', 
                      action: 'Publish::Marginal_Placement/perform_add/page_id='+page_id+'&'+placements+'&section=right' });
      }, 
      containment: [ 'place_marginal_selection_list', 'marginal_placements_right', 'marginal_placements_left' ] 
    });
  }
};




///////////////////////////////////////////////////////
// END publish
///////////////////////////////////////////////////////

///////////////////////////////////////////////////////
// BEGIN onload
///////////////////////////////////////////////////////

try { 

  tinyMCE.init({
    // do not provide mode! Editor inits are handled event-based when needed. 
    mode: 'specific_textareas', 
    editor_selector : "full", 
    plugins : "autoresize,safari,spellchecker,table,iespell,inlinepopups,insertdatetime,fullscreen,visualchars,xhtmlxtras,auritalink,auritafile,link",
    theme : "advanced",
    relative_urls : true,
    valid_elements : "*[*]",
    extended_valid_elements : "hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]",
    content_css : "/aurita/shared/editor_content_full.css",
    theme_advanced_styles : "Header 1=header1;Header 2=header2;Header 3=header3;Code=code", 
    theme_advanced_toolbar_align : "left", 
    theme_advanced_buttons1 : "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,|,formatselect,removeformat,|,insertdate,inserttime,|,forecolor,backcolor,auritalink,unlink", 
    theme_advanced_buttons2 : "auritafile,bullist,numlist,outdent,indent,|,tablecontrols,|,hr,fullscreen,code", 
    theme_advanced_buttons3 : "", 
    theme_advanced_toolbar_location : "top", 
    theme_advanced_resizing : false, 
    auto_resize : true,
    language : "de", 
    setup : function(editor) { 
      editor.addButton('aurita_save', { 
                        title : 'Speichern', 
                        image : '/aurita/images/icons/editor_save.gif', 
                        onclick : function() { 
                          Aurita.submit_form('container_form_xxxx'); 
                        }
      }); 
      editor.addButton('aurita_cancel', { 
                        title : 'Abbrechen', 
                        image : '/aurita/images/icons/editor_cancel.gif', 
                        onclick : function() { 
                          Aurita.Editor.save_all(); 
                          Aurita.load({ action : 'Wiki::Article/show/article_id=xxxx' });  
                        }
      }); 
    }

  });
  tinyMCE.init({
    mode: 'specific_textareas', 
    editor_selector : "simple", 
    plugins : "safari,spellchecker,table,iespell,inlinepopups,insertdatetime,fullscreen,visualchars,xhtmlxtras", 
    theme : "advanced",
    relative_urls : true,
    valid_elements : "*[*]",
    extended_valid_elements : "hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]",
    content_css : "/aurita/shared/editor_content_simple.css",
    theme_advanced_styles : "Header 1=header1;Header 2=header2;Header 3=header3;Code=code", 
    theme_advanced_toolbar_align : "left", 
    theme_advanced_buttons1 : "bold,italic,underline,strikethrough,removeformat,|,bullist,numlist,|,insertdate,inserttime,|,forecolor,backcolor", 
    theme_advanced_buttons2 : "", 
    theme_advanced_buttons3 : "", 
    theme_advanced_toolbar_location : "top", 
    theme_advanced_resizing : false, 
    auto_resize : false,
    language : "de"

  });

} catch(e) { 
  log_debug("Error when trying to load tinyMCE: " + e); 
}


Aurita.on_page_load = function() { 
  try { 
    Aurita.loading_icon = new Image(); 
    Aurita.loading_icon.src = '/aurita/images/icons/loading.gif'; 

    Aurita.context_menu_draggable = new Draggable('context_menu', { starteffect: 0, endeffect: 0 } );

    Aurita.disable_context_menu_draggable = function() { 
      Aurita.context_menu_draggable.destroy(); 
    }; 

    Aurita.enable_context_menu_draggable = function() { 
      Aurita.context_menu_draggable = new Draggable('context_menu');
    }; 

    Aurita.poll_load('users_online_box_body', 'App_General/users_online_box_body', 120); 
  } 
  catch(e) { } 

  setInterval(function() { Aurita.check_hashvalue(); }, 300);
  setInterval(function() { Aurita.poll_feedback(); }, 60000);

  try { 
    Element.hide('cover'); 
    Aurita.GUI.collapse_boxes();  
  } catch(e) { 
  }

//  new Draggable('message_box'); 
  if($('debug_box')) { 
    new Draggable('debug_box', { handle: 'debug_toolbar', starteffect: 0, endeffect: 0 } );
  }
  try { 
  new accordion('app_left_column', { 
                   classNames: { 
                     content: 'accordion_box_body', 
                     toggle: 'accordion_box_header', 
                     toggleActive: 'accordion_box_header_active' 
                   } 
                });
  } catch(e) { } 

  function custom_autocomplete_onupdate() { 
    Element.hide('indicator');
    Element.show('indicator_');
    Element.setStyle('autocomplete_choices', { width: '419px', top: '25px', left: '-200px' }); 
    Element.show('autocomplete_choices');
  }
  function custom_autocomplete() { 
    Element.show('indicator');
    Element.hide('indicator_');
    Aurita.load_silently({ action: 'Autocomplete/all/key='+($('autocomplete').value), 
                           element: 'autocomplete_choices', 
                           onload: custom_autocomplete_onupdate });
  };


  function show_article(text, li)
  {
    generic_id = text.id; 
    req_parts = generic_id.split('__'); 

    if(generic_id.match('find_all__')) {	
      tag = generic_id.replace('find_all__','');
      Aurita.load({ action: 'App_Main/find_all/key='+tag }); 
    }
    else if(generic_id.match('find_full__')) {	
      tag = generic_id.replace('find_full__','');
      Aurita.load({ action: 'App_Main/find_full/key='+tag }); 
    }
    else { 
      if(req_parts[0] == 'url') { 
        req_url = req_parts[1]; 
        window.open(req_url);
        return; 
      }
      else { 
        if(req_parts[2]) { 
          req_url = (req_parts[0] + '::' + req_parts[1] + '/show/id=' + req_parts[2]); 
          Aurita.load({ action: req_url }); 
        }
        else { 
          req_url = (req_parts[0] + '/show/id=' + req_parts[1]); 
          Aurita.load({ action: req_url }); 
        }
      } 
    }
  }

  function fix_rollout(element, query) { 
    Element.setStyle('autocomplete_choices', { width: '419px', top: '29px', left: '-204px' }); 
    Element.setOpacity('autocomplete_choices', 1.0);
    return query; 
  }

  if($('autocomplete')) { 
    new Ajax.Autocompleter("autocomplete", 
                           "autocomplete_choices", 
                           "/aurita/poll", 
                           { 
                             minChars: 2, 
                             updateElement: show_article, 
                             indicator: 'indicator', 
                             tokens: [], 
                             frequency: 0.2, 
                             callback: fix_rollout, 
                             parameters: 'controller=Autocomplete&action=all&mode=none'
                           }
    );
  }

  Aurita.init_page(); // Calls onload scripts defined in decorator
} 

window.onload = Aurita.on_page_load; 



///////////////////////////////////////////////////////
// END onload
///////////////////////////////////////////////////////
