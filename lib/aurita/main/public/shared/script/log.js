
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
