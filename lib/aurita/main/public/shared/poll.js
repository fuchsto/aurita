
Poll_Editor = { 

  option_counter: 0, 
  option_amount: 0, 

  add_option: function() { 
    Poll_Editor.option_counter++; 
    Poll_Editor.option_amount++; 
    field = document.createElement('span');
    field.id = 'poll_option_entry_'+Poll_Editor.option_counter; 
    field.innerHTML = '<input style="margin-top: 2px; " type="text" class="lore" name="poll_option_'+Poll_Editor.option_counter+'" /><span onclick="Poll_Editor.remove_option('+Poll_Editor.option_counter+');" class="lore_text_button" style="height: 19px; ">-</span> <br />';
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
  }

}; 

