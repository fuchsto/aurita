
Aurita.Messaging = { 
  
  insert_at_cursor : function(textarea_element_id, text) { 
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
  }, 
  
  messaging_load_interfaces : function(what)
  {
     Aurita.load({ element: 'messaging_content', action: 'Messaging::Mailbox/show_'+what, on_update: on_data }); 
  }, 

  active_messaging_button : false, 

  messaging_load : function(which)
  {
    if(!active_messaging_button) { 
      active_messaging_button = $('messaging_flag_inbox'); 
    }
    Element.addClassName('messaging_flag_inbox', 'flag_button');
    Element.removeClassName('messaging_flag_inbox', 'flag_button_active');
    Element.addClassName('messaging_flag_sent', 'flag_button');
    Element.removeClassName('messaging_flag_sent', 'flag_button_active');
    Element.addClassName('messaging_flag_read', 'flag_button');
    Element.removeClassName('messaging_flag_read', 'flag_button_active');
    Element.addClassName('messaging_flag_trash', 'flag_button');
    Element.removeClassName('messaging_flag_trash', 'flag_button_active');

    active_messaging_button = $('messaging_flag_'+which); 

    Element.addClassName(active_messaging_button, 'flag_button_active');
    Element.removeClassName(active_messaging_button, 'flag_button');

    Aurita.messaging_load_interfaces(which); 
  }

};


