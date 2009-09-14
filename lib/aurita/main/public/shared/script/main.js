
Aurita.Main = { 

  init_login_screen : function(element) {
    new Effect.Appear('login_box',{duration: 2, to: 1.0}); 
  }, 

  init_autocomplete_tags : function()
  {
    new Ajax.Autocompleter("autocomplete_tags", 
                           "autocomplete_tags_choices", 
                           "/aurita/dispatch_runner.fcgi", 
                           { 
                             minChars: 2, 
                             tokens: [' ',',','\n'], 
                             frequency: 0.1, 
                             parameters: 'controller=Autocomplete&action=tags&mode=none'
                           }
    );
  }, 

  autocomplete_single_tag : function(li)
  {
    tag = li.id.replace('tag_',''); 
    Cuba.load({ element: 'tag_form', action: 'Tag_Synonym/show/tag='+tag });
    return true; 
  }, 

  init_autocomplete_tag_selection : function()
  {
    new Ajax.Autocompleter("autocomplete_tags", 
                           "autocomplete_tags_choices", 
                           "/aurita/dispatch_runner.fcgi", 
                           { 
                             minChars: 2, 
                             tokens: [' ',',','\n'], 
                             frequency: 0.1, 
                             updateElement: autocomplete_single_tag, 
                             parameters: 'controller=Autocomplete&action=tags&mode=none'
                           }
    );
  }, 

  init_autocomplete_username : function()
  {
    new Ajax.Autocompleter("autocomplete_username", 
                           "autocomplete_username_choices", 
                           "/aurita/dispatch_runner.fcgi", 
                           { 
                             minChars: 2, 
                             tokens: [' ',',','\n'], 
                             frequency: 0.1, 
                             parameters: 'controller=Autocomplete&action=usernames&mode=none'
                           }
    );
  }, 

  autocomplete_selected_users : {}; 
  init_autocomplete_single_username : function()
  {
    autocomplete_selected_users = {}; 
    new Ajax.Autocompleter("autocomplete_username", 
                           "autocomplete_username_choices", 
                           "/aurita/dispatch_runner.fcgi", 
                           { 
                             minChars: 2, 
                             updateElement: autocomplete_single_username_handler, 
                             frequency: 0.1, 
                             tokens: [], 
                             parameters: 'controller=Autocomplete&action=usernames&mode=none'
                           }
    );
  }, 

  autocomplete_single_username_handler(li)
  {
    $('autocomplete_username').value = ''; 
    uname = li.innerHTML.replace(/^.+<b>([^>]+?)<\/b>.+$/,'$1'); // username is in <b> tag
    uid = li.id.replace('user__',''); 
    entry =  '<li id="user_group_id_'+uid+'">'
    entry += '<input type="hidden" name="user_group_ids[]" value="'+uid+'" />'
    entry += '<span class="link" onclick="Element.remove(\'user_group_id_'+uid+'\');">X </span>'+uname+'</li>';
    $('user_group_ids_selected_options').innerHTML += entry; 

    return true; 
  }, 

  category_selection_add : function(category_field_id)
  {
    var category_select_field_id = category_field_id + '_select'; 
    var category_list_id         = category_field_id + '_selected_options';
    var category_id              = $F(category_select_field_id); // Selected value of category select field
    var selected_option          = $A($(category_select_field_id).options).find(function(option) { return option.selected; } );
    category_name                = selected_option.text; 

    entry =  '<li id="public_category_category_id_'+category_id+'">'
    entry += '<input type="hidden" name="category_ids[]" value="'+category_id+'" />'
    entry += '<span class="link" onclick="Element.remove(\'public_category_category_id_'+category_id+'\');">X </span>'+category_name+'</li>';
    $(category_list_id).innerHTML += entry; 

    Element.remove(selected_option); 
    return true; 
  }, 

  set_dialog_link : function(url) { 
    plaintext = Cuba.temp_range.text; 
    url = 'http://' + url.replace('http://',''); 
    if(Cuba.check_if_internet_explorer() == '1') { 
      marker_key = 'find_and_replace_me';
      Cuba.temp_range.text = marker_key; 
      editor_html = Cuba.temp_editor_instance.getBody().innerHTML; 
      pos = editor_html.indexOf(marker_key); 
      if(pos != -1) { 
        Cuba.temp_editor_instance.getBody().innerHTML = editor_html.substring(0,pos) + '<a href="'+url+'" target="_blank">'+plaintext+'</a>' + editor_html.substring(pos+marker_key.length);
      }
    } 
    else 
    { 
      tinyMCE.execInstanceCommand(Cuba.temp_editor_id, 'mceInsertRawHTML', false, '<a href="'+url+'" target="_blank">'+Cuba.temp_range+'</a>');
    }
    Aurita.context_menu_close(); 
  }

}
