
Poll_Editor = { 

  option_counter: 0, 
  option_amount: 0, 

  add_option: function() { 
    Poll_Editor.option_counter++; 
    Poll_Editor.option_amount++; 
    field = document.createElement('li');
    field.id = 'poll_option_entry_'+Poll_Editor.option_counter; 
    field.innerHTML = '<input type="text" class="polling_option" name="poll_option_'+Poll_Editor.option_counter+'" /><button onclick="Poll_Editor.remove_option('+Poll_Editor.option_counter+');" class="polling_option_button">-</button>';
    $('poll_options').appendChild(field);

    if(Poll_Editor.option_amount >= 2) { 
      Element.setStyle('poll_editor_submit_button', { display: '' }); 
    }
    if(Poll_Editor.option_amount > 10) { 
      Element.setStyle('poll_editor_add_option_button', { display: 'none' }); 
    }

    $('poll_editor_max_option_index').value = Poll_Editor.option_counter; 
  },
  remove_option: function(index) { 
    Poll_Editor.option_amount--; 
    Element.remove('poll_option_entry_'+index); 
    if(Poll_Editor.option_amount < 2) { 
      Element.setStyle('poll_editor_submit_button', { display: 'none' }); 
    }
    if(Poll_Editor.option_amount <= 10) { 
      Element.setStyle('poll_editor_add_option_button', { display: '' }); 
    }
  }, 

  init: function(xml_conn, element, update_source)
  {
    element.innerHTML = xml_conn.responseText; 

    Poll_Editor.option_counter = 0; 
    Poll_Editor.option_amount = 0; 
  }

}; 



