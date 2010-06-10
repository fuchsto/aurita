
Aurita.Main = { 

  init_login_screen : function(element) {
    new Effect.Appear('login_box',{duration: 2, to: 1.0}); 
  }, 

  autocomplete_username_handler : function(text, li)
  {
    generic_id = text.id; 
  }, 
  
  init_autocomplete_tags : function()
  {
    new Ajax.Autocompleter("autocomplete_tags", 
                           "autocomplete_tags_choices", 
                           "/aurita/poll", 
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
    Aurita.load({ element: 'tag_form', action: 'Tag_Synonym/show/tag='+tag });
    return true; 
  }, 

  init_autocomplete_tag_selection : function()
  {
    new Ajax.Autocompleter("autocomplete_tags", 
                           "autocomplete_tags_choices", 
                           "/aurita/poll", 
                           { 
                             minChars: 2, 
                             tokens: [' ',',','\n'], 
                             frequency: 0.1, 
                             updateElement: Aurita.Main.autocomplete_single_tag, 
                             parameters: 'controller=Autocomplete&action=tags&mode=none'
                           }
    );
  }, 

  init_autocomplete_username : function()
  {
    new Ajax.Autocompleter("autocomplete_username", 
                           "autocomplete_username_choices", 
                           "/aurita/poll", 
                           { 
                             minChars: 2, 
                             tokens: [' ',',','\n'], 
                             frequency: 0.1, 
                             parameters: 'controller=Autocomplete&action=usernames&mode=none'
                           }
    );
  }, 

  autocomplete_selected_users : {}, 
  init_autocomplete_single_username : function()
  {
    Aurita.Main.autocomplete_selected_users = {}; 
    new Ajax.Autocompleter("autocomplete_username", 
                           "autocomplete_username_choices", 
                           "/aurita/poll", 
                           { 
                             minChars: 2, 
                             updateElement: Aurita.Main.autocomplete_single_username_handler, 
                             frequency: 0.1, 
                             tokens: [], 
                             parameters: 'controller=Autocomplete&action=usernames&mode=none'
                           }
    );
  }, 

  autocomplete_single_username_handler : function(li)
  {
    $('autocomplete_username').value = ''; 
    uname = li.innerHTML.replace(/^.+<b>([^>]+?)<\/b>.+$/i,'$1'); // username is in <b> tag
    uid = li.id.replace('user__',''); 
    entry =  '<li id="user_group_id_'+uid+'">'
    entry += '<input type="hidden" name="user_group_ids[]" value="'+uid+'" />'
    entry += '<a class="icon" onclick="Element.remove(\'user_group_id_'+uid+'\');"><img src="/aurita/images/icons/delete_small.png" /></a>'+uname+'</li>';
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
    entry += '<a class="icon" onclick="Element.remove(\'public_category_category_id_'+category_id+'\');"><img src="/aurita/images/icons/delete_small.png" /></a>'+category_name+'</li>';
    $(category_list_id).innerHTML += entry; 

    Element.remove(selected_option); 
    return true; 
  }, 

  /* Javascript implementation for GUI::Selection_List_Field. 
   *
   * @params: 
   * - select_field: DOM id of select field used to add entries to list. 
   * - name: Name of generated form field (values will be posted as Array, '[]' is appended automatically). 
   *
   */
  selection_list_add : function(params)
  {
    var select_field_id    = params.select_field; 
    var selected_list_id   = params.name + '_selected_options'; 
    var key                = params.name; 
    var selected_value     = $F(select_field_id); // Selected value of select field
    var selected_option    = $A($(select_field_id).options).find(function(option) { return option.selected; });
    var label              = selected_option.text; 
    var field_id           = key.replace('.','__') + '_' + selected_value;

    if(selected_value == '') { return; } // First option is '-- choose --' and has empty value 

    entry =  '<li id="'+field_id+'">'
    entry += '<input type="hidden" name="'+key+'[]" value="'+selected_value+'" />'
    entry += '<a class="icon" onclick="Element.remove(\''+field_id+'\');"><img src="/aurita/images/icons/delete_small.png" /></a>'+label+'</li>';
    $(selected_list_id).innerHTML += entry; 

    Element.writeAttribute(selected_option, 'disabled', 'disabled');
    $(select_field_id).value = '-'; // reset, otherwise last selected option would be active
    return true; 
  }, 

  selection_list_remove : function(params)
  {
    var select_field_id    = params.select_field; 
    var selected_list_id   = params.name + '_selected_options'; 
    var key                = params.name; 
    var selected_value     = $F(select_field_id); // Selected value of select field
    var selected_option    = $A($(select_field_id).options).find(function(option) { return option.selected; });
    Element.writeAttribute(selected_option, 'disabled', 'false');
  }

}; 
