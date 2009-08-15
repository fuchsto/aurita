

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


var mouse_x = 0; 
var mouse_y = 0; 
function capture_mouse(ev) 
{
    if(!ev) { ev = window.event; }
    if(!ev) { return ; }
    alert('IN'); 

//    if(Browser.is_ie) {
    if(true) { 
    alert('IE'); 
      mouse_x = ev.clientX + document.body.scrollLeft; 
      mouse_y = ev.clientY + document.body.scrollTop; 
    }
    else { 
    alert('gecko'); 
      mouse_x = ev.pageX; 
      mouse_y = ev.pageY; 
    }
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
      Element.setStyle($(last_hovered_element), { backgroundColor: 'transparent' }); 
    } catch(e) { }
  }
  Element.setStyle($(elem_id), { backgroundColor: '#bfbfbf' }); 
  last_hovered_element = elem_id; 
}
function unhover_element(elem_id) { 
  Element.setStyle($(elem_id), { backgroundColor: '' }); 
}

var element_style_unfocussed;
function focus_element(element_id)
{
    if(element_style_unfocussed == undefined) {
    //  element_style_unfocussed = rgb_to_hex(Element.getStyle(element_id, 'color')); 
      element_style_unfocussed = (Element.getStyle(element_id, 'color')); 
    }
    //    alert(element_style_unfocussed);
    Element.setStyle(element_id, {backgroundColor: '#ccc8c8'});
    Element.setStyle(element_id, {zIndex: 301});
}
function unfocus_element(element_id)
{
    if(element_exists(element_id)) {
      if(element_style_unfocussed) { 
        Element.setStyle(element_id, {color: element_style_unfocussed}); 
      }
      Element.setStyle(element_id, {backgroundColor: '' });
      Element.setStyle(element_id, {zIndex: 1});
      element_style_unfocussed = undefined; 
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
