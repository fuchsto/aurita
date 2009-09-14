
Aurita.notify_error = function(error_code, form_element, message) { 
  Element.setStyle(form_element_id, { borderColor: '#990000' } ); 
  if(message) { 
    $(form_element_id+'_message').innerHTML = message; 
    Element.show(form_element_id+'_message'); 
  }
  try { Element.show(button_id+'_form_buttons'); } catch(e) {}; 
  try { Element.show('main_form_buttons'); } catch(e) {};  
  try { if(Aurita.context_menu.is_opened()) { Element.setOpacity('context_menu', 1.0); } } catch(e) {}; 
  init_all_editors(); 
}
