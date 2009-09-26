
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
