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
  if(keycode == 17 || keycode == 77) { context_menu_handle.deactivate(); } 
}; 
document.onkeyup = function(ev) { 
  if (!ev) ev = window.event;
  if (ev.which) {
    keycode = ev.which;
  } else if (ev.keyCode) {
    keycode = ev.keyCode;
  }
  if(keycode == 17 || keycode == 77) { context_menu_handle.activate(); } 
}; 

if (Browser.is_gecko) {
    document.onmousedown = context_menu_handle.handle_click; 
    document.oncontextmenu = function(ev) { 
      if(!context_menu_handle.is_active()) { 
        context_menu_handle.activate(); 
        return true; 
      }
      return false; 
    }; 
} 
else if (Browser.is_ie) {
    document.attachEvent('onclick', context_menu_handle.handle_click); 
    document.oncontextmenu = function(ev) { 
      if(!context_menu_handle.is_active()) { 
        context_menu_handle.activate(); 
        return true; 
      }
      ie_right_click = true; 
      context_menu_handle.handle_click(ev); 
      return false; 
    }
}
// temp disable: document.onkeypress = context_menu_handle.handle_key; 
// add_event(document,'onmousedown', context_menu_handle.handle_click); 
// add_event(document,'oncontextmenu', context_menu_handle.handle_click);
document.onmousemove = capture_mouse; 
