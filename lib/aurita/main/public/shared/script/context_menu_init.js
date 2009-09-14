// DEPRECATED SINCE NS 6.0
if (Browser.is_ie && document.captureEvents) {
    document.captureEvents(Event.MOUSEDOWN);
    document.captureEvents(Event.MOUSEMOVE); 
    document.captureEvents(Event.KEYPRESS);
}

document.onkeydown = function(ev) { 
  if (!ev) ev = window.event;
  if (ev.which) {
    keycode = ev.which;
  } else if (ev.keyCode) {
    keycode = ev.keyCode;
  }
  if(keycode == 17 || keycode == 77) { Aurita.context_menu.deactivate(); } 
}; 
document.onkeyup = function(ev) { 
  if (!ev) ev = window.event;
  if (ev.which) {
    keycode = ev.which;
  } else if (ev.keyCode) {
    keycode = ev.keyCode;
  }
  if(keycode == 17 || keycode == 77) { Aurita.context_menu.activate(); } 
}; 

if (Browser.is_gecko) {
    document.onmousedown = Aurita.context_menu.handle_click; 
    document.oncontextmenu = function(ev) { 
      if(!Aurita.context_menu.is_active()) { 
        Aurita.context_menu.activate(); 
        return true; 
      }
      return false; 
    }; 
} 
else if (Browser.is_ie) {
    document.attachEvent('onclick', Aurita.context_menu.handle_click); 
    document.oncontextmenu = function(ev) { 
      if(!Aurita.context_menu.is_active()) { 
        Aurita.context_menu.activate(); 
        return true; 
      }
      ie_right_click = true; 
      Aurita.context_menu.handle_click(ev); 
      return false; 
    }
}
// temp disable: document.onkeypress = Aurita.context_menu.handle_key; 
// add_event(document,'onmousedown', Aurita.context_menu.handle_click); 
// add_event(document,'oncontextmenu', Aurita.context_menu.handle_click);
document.onmousemove = capture_mouse; 
