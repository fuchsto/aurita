
Aurita.Messaging = { 
  
  load_interfaces : function(what)
  {
     Aurita.load({ element: 'messaging_content', action: 'Messaging::Mailbox/show_'+what+'/' }); 
  }, 

  active_messaging_button : false, 

  open_tab : function(which)
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

    Aurita.Messaging.load_interfaces(which); 
  }

};


