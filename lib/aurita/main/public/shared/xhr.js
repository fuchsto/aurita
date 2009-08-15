
function XHConn()
{
  var xmlhttp, bComplete = false;

  try {
//  netscape.security.PrivilegeManager.enablePrivilege("UniversalBrowserRead");
  } catch (e) {
    alert("Permission UniversalBrowserRead denied.");
  }

  try { xmlhttp = new ActiveXObject("Msxml2.XMLHTTP"); }
  catch (e) { try { xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); }
  catch (e) { try { xmlhttp = new XMLHttpRequest(); }
  catch (e) { xmlhttp = false; }}}
  if (!xmlhttp) return null;
  
  //this.connect = function(sURL, sVars, fnDone, element)
  this.connect = function(sURL, sMethod, fnDone, element, postVars) {
  
      if(postVars == undefined) { postVars = ""; }
      if (!xmlhttp) return false;
      bComplete = false;

      try {
        if(sMethod == 'GET') { 
            sURL += '&randseed='+Math.round(Math.random()*100000);
            //    sMethod = sMethod.toUpperCase();
            //    xmlhttp.open(sMethod, sURL+"?"+sVars, true);
            xmlhttp.open(sMethod, sURL, true);
            sVars = ""; 
        }
        else {
            xmlhttp.open(sMethod, sURL, true);
            xmlhttp.setRequestHeader("Method", "POST "+sURL+" HTTP/1.1");
            xmlhttp.setRequestHeader("Content-Type",
                   "application/x-www-form-urlencoded");
        }
        xmlhttp.onreadystatechange = function() {
          if (xmlhttp.readyState == 4 && !bComplete) {
            bComplete = true;
            if(fnDone) { 
              fnDone(xmlhttp, element, sMethod=='POST');
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
          xmlhttp.setRequestHeader("Content-Type",
                 "application/x-www-form-urlencoded");
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


function log_debug(message) { 
  if(window.console && window.console.log) { 
    window.console.log(message); 
  } 
  if(document.getElementById('developer_console')) { 
    document.getElementById('developer_console').innerHTML += (message + '<br />');
  }
}


var Aurita = {
  last_username: '', 
  username_input_element: '0'
}; 

Aurita.check_if_internet_explorer = function() {
  var nAgt = navigator.userAgent;
  if ((verOffset = nAgt.indexOf("MSIE")) != -1) {
    return 1;
  }
  else {
    return 0;
  }
};


Aurita.element = function(dom_id) { 
  try { 
    elem = $(dom_id); 
  } catch(e) { 
    elem = false; 
  }
  return elem; 
}; 

Aurita.get_remote_string = function(url, response_fun) { 
  var xml_conn = new XHConn; 
  xml_conn.get_string('/aurita/'+url+'&mode=async', response_fun);
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

Aurita.async_form_submit = function(form_element) {   
  context_menu_autoclose = true; 
  target_url   = '/aurita/dispatch'; 
  postVars     = Form.serialize(form_element);

  postVars    += '&mode=async'; 
  // postVarsHash = Form.serialize(form_element, true); 
  
  var xml_conn = new XHConn; 
  element = Aurita.element('dispatcher'); 
  xml_conn.connect(target_url, 'POST', Cuba.update_element, element, postVars); 
};

Aurita.handle_form_error = function() { 
  for (var i=0; i < arguments.length; i++) {
    info = arguments[i];
    Element.addClassName(info.field_id+'_wrap', 'error'); 
    Element.removeClassName(info.field_id+'_wrap', 'invalid'); 
  }
  Element.setOpacity('context_menu', 1.0); 
};

Aurita.cancel_form = function(form) { 
  save_all_editors(); 
  if(context_menu_handle.is_opened()) { 
    Element.hide('context_menu'); 
    context_menu_close(); 
  } 
  else { 
    history.back(); 
  }
  return true; 
}; 

Aurita.submit_form = function(form, redirects) { 
  save_all_editors(); 
  Aurita.async_form_submit(form); 
  if(redirects != undefined) { 
    for(x in redirects) {
      Cuba.load({ action: redirects[x], element: x }); 
    }
  }
};

Aurita.before_file_upload = function() {
  Aurita.waiting_for_file_upload = true; 
  new Effect.SlideDown('file_upload_indicator'); 
};

Aurita.submit_upload_form = function(form_id) { 
  if(Cuba.waiting_for_file_upload) { 
    alert('Ein anderer Upload l&auml;uft bereits');
    return false;
  }
  Aurita.waiting_for_file_upload = true; 
  save_all_editors(); 
  Element.toggle(form_id); 
  
  Element.hide('context_menu'); 
  setTimeout('context_menu_close()', 2000); 

  $(form_id).submit(); 
  // Delay closing context menu so form values 
  // remain intact at the moment of submit: 
  new Effect.SlideDown('file_upload_indicator'); 
  if(!context_menu_opened()) { 
    setTimeout('Aurita.after_submit_upload_form()', 2000); 
  }
  return true; 
}; 

Aurita.after_submit_upload_form = function() { 
  Cuba.load({ action: 'Wiki::Media_Asset/after_add' }); 
}; 

Aurita.after_file_upload = function() { 
  if(Aurita.waiting_for_file_upload) {
    new Effect.SlideUp('file_upload_indicator'); 
    Aurita.waiting_for_file_upload = false; 
  }
};

Aurita.form_field_onfocus = function(element_id) { 
  Element.addClassName(element_id+'_wrap', 'focussed' ); 
  Element.addClassName(element_id, 'focussed' );
};

Aurita.form_field_onblur = function(element_id) { 
  Element.removeClassName(element_id+'_wrap', 'focussed' ); 
  Element.removeClassName(element_id, 'focussed' );
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
  Cuba.load({ element: attribute_name + '_' + level + '_next', 
              action : 'Wiki::Media_Asset_Folder/hierarchy_node_select_level/media_folder_id__parent='+field.value+'&level='+(level+1) }); 
  $(attribute_name).value = field.value; 
}


///// XHR ///////////////////////////////

Aurita.update_targets            = {}; 
Aurita.current_interface_calls   = {}; 
Aurita.completed_interface_calls = {}; 
Aurita.last_hashvalue            = ''; 
Aurita.wait_for_iframe_sync      = '0'; 

Aurita.set_ie_history_fix_iframe_src = function(url) 
{ 
  return; // IE REACT
  if(Aurita.wait_for_iframe_sync == '1') { 
    Aurita.wait_for_iframe_sync = '0'; 
  } else { 
    Aurita.wait_for_iframe_sync = '1'; 
  }
  Aurita.ie_history_fix_iframe = parent.ie_fix_history_frame; 
  Aurita.ie_history_fix_iframe.location.href = url; 
};
Aurita.set_hashcode = function(code) 
{
  if(Aurita.check_if_internet_explorer() == 1)
  {
    Aurita.set_ie_history_fix_iframe_src('/aurita/get_code.fcgi?code='+code);
  }
  Aurita.force_load = true; 
  document.location.href = '#'+code;
  Aurita.check_hashvalue(); 
}; 
Aurita.append_hashcode = function(code) { 
    Aurita.force_load = true; 
    document.location.href += '--' + code;
    Aurita.check_hashvalue(); 
}; 


Aurita.after_update_element = function(element) {
  try { init_all_editors(); } catch(e) { } 
}; 

Aurita.on_successful_submit = function() { 
  try { context_menu_close(); } catch(e) { }  
}; 

Aurita.update_element = function(xml_conn, element, do_update_source)
{
    try { Element.setOpacity(element, 1.0); } catch(e) { }

    log_debug('Aurita.update_element ' + element); 
    response = xml_conn.responseText;
    response_html = response; 
    response_script = false; 
    response_error = false; 
    // See Cuba::Controller.render_view
    if(response.substr(0, 6) == '{ html')
    { 
      json_response   = eval('(' + response + ')'); 
      response_html   = json_response.html.replace('\"','"'); 
      response_script = json_response.script.replace('\"','"'); 
      response_error  = json_response.error; 
      if(response_error) { 
        response_error  = json_response.error.replace('\"','"'); 
      }
    } 
    else if(response.substr(0,8) == '{ script' ) 
    {
      json_response = eval('(' + response + ')'); 
      response_html = ''
      response_error = false; 
      response_script = json_response.script.replace('\"','"'); 
    } 
    else if(response.substr(0,7) == '{ error' ) 
    {
      json_response = eval('(' + response + ')'); 
      response = ''
      response_html = false; 
      response_script = false; 
      Aurita.update_targets = { }; // Break dispatch chain on error, 
                                 // prohibit further actions in interface
      response_error = json_response.error.replace('\"','"'); 
    } 
    else if(response.replace(/\s/g,'') == '') { 
      Aurita.on_successful_submit(); 
    }
    else { 
      response_error = false; 
      response_script = false; 
      response_html = response; // Plain response, no json 
    }

    if(element) 
    {
    // When to close context menu (no error and no html response, or target element
    // is not context menu)
      if(!response_error && (!element || !response_html))
   // if(!response_error && (!element || element && element.id != 'context_menu' || !response_html))
      {
        // This might be a hack: 
        // We currenltly are setting (brute force) element_id to 'dispatcher' in 
        // Cuba.remote_submit (because there, it's the only sensible target element). 
        // Then, however, target 'context_menu' is overridden, so it wouldn't be closed 
        // here. 
        context_menu_close(); 
      } 
      if(response_error) // aurita wants to tell us something
      {
        eval(response_error); 
      }
      element.innerHTML = response_html; 
    }
    if(response_script) { eval(response_script); }

    if(Aurita.update_targets) {
      for(var target in Aurita.update_targets) {
        if(Aurita.update_targets[target]) { 
          url = Aurita.update_targets[target].replace('.','/');
          url += '&randseed='+Math.round(Math.random()*100000);
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
  try { save_all_editors(); } catch(e) { } 
}

Aurita.load_url = function(params)
{
  target_id = params['element']; 
  if(!target_id) { target_id = 'app_main_content'; }

  element = Aurita.element(target_id); 

  Aurita.before_load_url(element); 

  if(params['action']) { 
    action_url = params['action'];
    action_url.replace('/aurita/',''); 
    call_arr  = action_url.replace(/([^\/]+)\/([^\/]+)[\/&](.+)?/,'$1.$2').replace('/','');
    model     = call_arr.split('.')[0]; 
    method    = call_arr.split('.')[1]; 
    postVars  = 'controller=' + model; 
    postVars += '&action=' + method; 
    postVars += '&mode=async&';
    postVars += action_url.replace(/([^\/]+)\/([^/]+)\/(.+)?/,'$3').replace('/',''); 
    interface_url = '/aurita/dispatch'; 
    method        = 'POST'
  } 
  else if(params['url']) { 
    interface_url = params['url'];
    postVars      = '';
    method        = 'GET'
  }
  update_fun = Aurita.update_element; 

  if(Aurita.current_interface_calls[interface_url]) { log_debug("Duplicate interface call?"); }
  Aurita.current_interface_calls[interface_url] = true; 
  
  log_debug("Dispatch interface "+interface_url);
  
  Aurita.update_targets = params['targets']; 

  var xml_conn = new XHConn; 
  
  xml_conn.connect(interface_url, method, update_fun, element, postVars); 
}; 

Aurita.load = function(params) {
  try { 
    if(!params['element']) { 
      Aurita.set_hashcode(params['action']);
      return false; 
    }

    if(!$(params['element'])) { 
      log_debug('Target for Aurita.load does not exist: '+params['target']+', ignoring call'); 
      return false; 
    }
    params['targets'] = params['redirect_after']; 
    Aurita.load_url(params); 
    return false; 

  } catch(e) { 
    log_debug(e); 
    return false; 
  } 
}; 

Aurita.check_hashvalue = function() 
{
    current_hashvalue = document.location.hash.replace('#',''); 

    if(current_hashvalue.match(/(.+)?_anchor/)) { return;  } 

    if(false && Aurita.check_if_internet_explorer() == 1) { // IE REACT
      iframe_hashvalue = Aurita.get_ie_history_fix_iframe_code(); 
      if(iframe_hashvalue != 'no_code' && iframe_hashvalue != current_hashvalue && !Aurita.force_load && iframe_hashvalue != '' && !iframe_hashvalue.match('about:')) { 
        current_hashvalue = iframe_hashvalue; 
      }
      if(document.location.hash != '#'+current_hashvalue) { document.location.hash = current_hashvalue; }
    }

    if(Aurita.force_load || current_hashvalue != Aurita.last_hashvalue && current_hashvalue != '') 
    { 
      window.scrollTo(0,0);

      Aurita.force_load = false; 
      log_debug("loading interface for "+current_hashvalue); 
      Aurita.last_hashvalue = current_hashvalue;
      action = current_hashvalue.replace(/--/g,'/').replace(/-/,'=');

      // split hash into controller--action--param1--value1--param2--value2...
      Aurita.load({ element: 'app_main_content', 
                    action: action }); 

    } 
}; 


