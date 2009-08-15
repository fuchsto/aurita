
var Cuba = { 

    element: function(element_id)
    {
        element = document.getElementById(element_id); 
        if(!element) { 
            element = $(element_id); 
        }
        if(!element) { 
        //  alert('No such element: ' + element_id); 
        }
        return element;
    }, 

    delete_element: function(element_id) 
    {
        Element.remove(element_id); 
    },
    
    get_form_values: function(form_id)
    {
        var form; 
        if(document.forms) {
           form = eval('document.forms.'+form_id); 
        } 
        else {
           form = Cuba.element(form_id);
        }
        string = ''
        for(index=0; index<form.elements.length; index++) {
            element = form.elements[index]; 
            if(element.value != '' && element.name != '') { 
              element_value = element.value;
              element_value = element_value.replace(/&auml;/g,'ä'); 
              element_value = element_value.replace(/&ouml;/g,'ö'); 
              element_value = element_value.replace(/&uuml;/g,'ü'); 
              element_value = element_value.replace(/&Auml;/g,'Ä'); 
              element_value = element_value.replace(/&Ouml;/g,'Ö'); 
              element_value = element_value.replace(/&Uuml;/g,'Ü'); 
              element_value = element_value.replace(/&szlig;/g,'ß'); 
              element_value = element_value.replace(/&nbsp;/g,' '); 
              
              string += element.name + '=' + element_value + '&'; 
            }
        }
        return string;
    },

    get_form_values_hash: function(form_id)
    {
        var form; 
        if(document.forms) {
           form = eval('document.forms.'+form_id); 
        } 
        else {
           form = Cuba.element(form_id);
        }
	
        value_hash = {}; 
        for(index=0; index<form.elements.length; index++) {
            element = form.elements[index]; 
            if(element.value != '' && element.name != '') { 

              element_value = element.value;
              element_value = element_value.replace(/&auml;/g,'ä'); 
              element_value = element_value.replace(/&ouml;/g,'ö'); 
              element_value = element_value.replace(/&uuml;/g,'ü'); 
              element_value = element_value.replace(/&Auml;/g,'Ä'); 
              element_value = element_value.replace(/&Ouml;/g,'Ö'); 
              element_value = element_value.replace(/&Uuml;/g,'Ü'); 
              element_value = element_value.replace(/&szlig;/g,'ß'); 
              element_value = element_value.replace(/&nbsp;/g,' '); 
              
              value_hash[element.name] = element_value;
            }
        }
        return value_hash;
    },
    
    get_remote_string: function(url, response_fun)
    {
        var xml_conn = new XHConn; 
        xml_conn.get_string(url, response_fun);
    },
    
    after_submit_target_map: {
        'Wiki::Article.perform_add': { 'app_main_content': 'Wiki::Article.show_own_latest' }, 
        'Community::Role_Permissions.perform_add': { 'app_main_content': 'Community::Role.list' }, 
        'Form_Builder.perform_add': { 'app_main_content': 'Form_Builder.form_added' }, 
        'Community::User_Profile.perform_update': { 'app_main_content': 'Community::User_Profile.show_own' }, 
        'Community::User_Message.perform_add' : { 'messaging_content' : 'Community::User_Message.message_sent'}
    }, 

    after_submit_targets: function(form_id) { 
        form_values = Cuba.get_form_values_hash(form_id); 
        targets = Cuba.after_submit_target_map[form_values['cb__model']+'.'+form_values['cb__controller']];
        return targets; 
    }, 
    
    update_targets: {}, 
    init_functions: {
      'Wiki::Article.show': init_article_interface, 
      'App_Main.login': init_login_screen, 
      'Community::User_Profile.register_user': init_login_screen, 
      'Community::User_Profile.show_galery': initLightbox, 
      'Wiki::Media_Asset_Folder.show': initLightbox
    }, 
    element_init_functions: {}, 

    load_element_content: function(element_id, interface_url)
    {
        element = Cuba.element(element_id); 
        var xml_conn = new XHConn; 
        
        interface_call = interface_url.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,'$1.$2');
        interface_call = interface_call.replace('/','');

        init_fun = Cuba.init_functions[interface_call];

        if(init_fun) { Cuba.element_init_functions[element.id] = init_fun; }
        
//      xml_conn.connect(interface_url+'&cb__mode=dispatch&randseed='+Math.round(Math.random()*100000), 'GET', Cuba.update_element_only, element); 
        xml_conn.connect(interface_url+'&cb__mode=dispatch', 'GET', Cuba.update_element_only, element); 
    },

    update_element: function(xml_conn, element, do_update_source)
    {
        if(element) 
        {
          response = xml_conn.responseText;
            
          if(response == "\n") 
          {
            // This might be a hack: 
            // We currenltly are setting (brute force) element_id to 'dispatcher' in 
            // Cuba.remote_submit (because there, it's the only sensible target element). 
            // Then, however, target 'context_menu' is overridden, so it wouldn't be closed 
            // here. 
            if(element.id == 'context_menu') {
              context_menu_close(); 
            } 
          } 
          else
          {
            element.innerHTML = response; 
          }
          init_fun = Cuba.element_init_functions[element.id]
          if(init_fun) { init_fun(element); }
        }

        if(Cuba.update_targets) {
          for(var target in Cuba.update_targets) {
            if(Cuba.update_targets[target]) { 
              url = '/aurita/'+(Cuba.update_targets[target].replace('.','/'));
              Cuba.load_element_content(target, url);
            }
          }
          // Reset targets so they will be set in next load/remote_submit call: 
          Cuba.update_targets = null; 
        }
    },

    update_element_only: function(xml_conn, element, do_update_source)
    {
      if(element) 
      {
        response = xml_conn.responseText;

        if(response == "\n") 
        {
            if(element.id == 'context_menu') {
              context_menu_close(); 
            }
            Element.setStyle(element, { display: 'none' });
        } 
        else
        {
            element.innerHTML = response; 
        }
        init_fun = Cuba.element_init_functions[element.id]; 
        if(init_fun) { init_fun(element); }
      }
    },

    call: function(interface_url)
    {
      var xml_conn = new XHConn; 
      interface_url += '&cb__mode=dispatch'; 
      xml_conn.connect('/aurita/'+interface_url, 'GET', null, null); 
    },

    current_interface_calls: {}, 
    completed_interface_calls: {}, 
    dispatch_interface: function(params)
    {
      target_id     = params['target']; 
      interface_url = '/aurita/' + params['interface_url']; 
      interface_url.replace('/aurita//aurita/','/aurita/'); 
      
      if(Cuba.current_interface_calls[interface_url]) { return; }
      Cuba.current_interface_calls[interface_url] = true; 
      
      update_fun    = params['on_update']; 
      
      Cuba.update_targets = params['targets']; 
      var xml_conn = new XHConn; 
      interface_url += '&cb__mode=dispatch'; 
      element = Cuba.element(target_id); 
      if(!params['silently']) { 
        element.innerHTML = '<img src="/aurita/images/icons/loading.gif" />'; 
      }
      interface_call = interface_url.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,'$1.$2');
      interface_call = interface_call.replace('/','');
      init_fun = Cuba.init_functions[interface_call];
      if(init_fun) { Cuba.element_init_functions[element.id] = init_fun; }
      if(update_fun == undefined) { update_fun = Cuba.update_element; }
      xml_conn.connect(interface_url, 'GET', update_fun, element); 
    },

    remote_submit: function(form_id, target_id, targets)
    {

      context_menu_autoclose = true; 
      target_url     = '/aurita/dispatch'; 
      postVars       = Form.serialize(form_id);
      // postVars = Cuba.get_form_values(form_id); 
      postVars += '&cb__mode=dispatch&x=1'; 
      // postVarsHash   = Cuba.get_form_values_hash(form_id); 
      postVarsHash   = Form.serialize(form_id, true); 
      if(targets && !Cuba.update_targets) { 
          Cuba.update_targets = targets; 
      }
      
      interface_call = postVarsHash['cb__model']+'.'+postVarsHash['cb__controller']; 
      init_fun = Cuba.init_functions[interface_call];
      if(init_fun) { Cuba.element_init_functions[element.id] = init_fun; }
      
      var xml_conn = new XHConn; 
      element = Cuba.element(target_id); 
      xml_conn.connect(target_url, 'POST', Cuba.update_element, element, postVars); 
    },

    async_submit: function(params) { 
        Cuba.remote_submit(params['form'], params['element']); 
    },

    load: function(params) {
        params['interface_url'] = params['action']; 
        params['target']        = params['element']; 
        params['targets']       = params['redirect_after']; 
        params['on_update']     = params['on_update']; 
        Cuba.dispatch_interface(params); 
    },

    cancel_dispatch: function() 
    {
      Cuba.close_context_menu();
    },
    // A message box is printing a string (message_text) and 
    // offers a button to close it. 
    alert: function(message_text) {
        Cuba.message_box = new MessageBox({ interface_url: 'App_Main/alert_box/message='+message_text });
        Cuba.message_box.open();
    },
    // A popup includes an arbitrary interface. 
    popup: function(action) {
        Cuba.message_box = new MessageBox({ interface_url: action });
        Cuba.message_box.open();
    },
    
    confirmed_interface: '',
    unconfirmed_interface: '', 
    message_box: undefined, 
    
    on_confirm_action: function() {}, 

    after_confirmed_action: function(xml_conn, element) 
    {
      // do nothing
    },

    // Usage: 
    // <span onclick="Cuba.confirmable_action({ call: 'Community::Forum_Post/delete/forum_post_id=123', 
    //                                          message: 'Really delete post?', 
    //                                          targets: { post_list: 'Community::Forum_Post/list/' } 
    //                                       });" >
    //   delete post
    // </span>
    confirmable_action: function(params) {
      interface_url = params['action']; 
      message       = params['message']; 
      targets       = params['targets']; 
      Cuba.message_box = new MessageBox({ interface_url: 'App_Main/confirmation_box/message='+message }); 
      Cuba.unconfirmed_interface = interface_url; 
      if(params['onconfirm']) { 
        Cuba.on_confirm_action = params['onconfirm']; 
      }
      Cuba.update_targets = targets; 
      Cuba.message_box.open();
    }, 
    confirm_action: function() { 
      Cuba.dispatch_interface({ target: 'dispatcher', 
                                interface_url: Cuba.unconfirmed_interface, 
                                on_update: Cuba.after_confirmed_action, 
                                targets: Cuba.update_targets });
      Cuba.update_targets = {}; 
      Cuba.on_confirm_action(); 
      Cuba.message_box.close(); 
    }, 
    cancel_action: function() { 
      Cuba.update_targets = {}; 
      Cuba.message_box.close(); 
    },

    waiting_for_file_upload: false, 
    before_file_upload: function() {
      Cuba.waiting_for_file_upload = true; 
      Element.setStyle('file_upload_indicator', { display: '' });
    },
    after_file_upload: function() { 
      if(Cuba.waiting_for_file_upload) {
        Element.setStyle('file_upload_indicator', { display: 'none' });
        Cuba.waiting_for_file_upload = false; 
        alert('Datei wurde auf den Server geladen');
      }
    }, 
    upload_file: function(form_id) {
                   alert('upload');
      if(Cuba.waiting_for_file_upload) { 
        alert('Ein anderer Upload l&auml;uft bereits');
        return false;
      }
      Cuba.before_file_upload(); 
      Element.toggle(form_id); 
      Element.toggle('upload_confirmation');
      return true; 
    }
      

} // Namespace Cuba


Cuba.force_load = false; 

Cuba.set_ie_history_fix_iframe_src = function(url) 
{ 
  if(wait_for_iframe_sync == '1') { 
    wait_for_iframe_sync = '0'; 
  } else { 
    wait_for_iframe_sync = '1'; 
  }
  Cuba.ie_history_fix_iframe = parent.ie_fix_history_frame; 
  Cuba.ie_history_fix_iframe.location.href = url; 
};

Cuba.set_hashcode = function(code) 
{
  if(Cuba.check_if_internet_explorer() == 1)
  {
    Cuba.set_ie_history_fix_iframe_src('/aurita/get_code.fcgi?code='+code);
  }
  Cuba.force_load = true; 
  document.location.href = '#'+code;
  Cuba.check_hashvalue(); 
}; 
Cuba.append_hashcode = function(code) { 
    Cuba.force_load = true; 
    document.location.href += '--' + code;
    Cuba.check_hashvalue(); 
}; 

