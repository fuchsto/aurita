
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

Aurita.hover = function(element) { 
  $(element).addClassName('hover');
}
Aurita.unhover = function(element) { 
  $(element).removeClassName('hover');
}

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
  Aurita.load_silently({ element: attribute_name + '_' + level + '_next', 
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

  if(target_id == 'app_main_content' && !params['no_hashvalue'] && !params['onload'] && params['method'] == 'GET') { 
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
  //  action = Aurita.current_hashvalue.replace(/--/g,'/').replace(/-/,'=');
      action = Aurita.current_hashvalue; 

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


