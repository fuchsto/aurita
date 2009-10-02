
Aurita.Wiki = { 

  autocomplete_article_handler : function(text, li) { 
    plaintext = Aurita.temp_range.text; 
    if(Aurita.check_if_internet_explorer() == '1') { 
      marker_key = 'find_and_replace_me';
      Aurita.temp_range.text = marker_key; 
      editor_html = Aurita.temp_editor_instance.getBody().innerHTML; 
      pos = editor_html.indexOf(marker_key); 
      if(pos != -1) { 
        Aurita.temp_editor_instance.getBody().innerHTML = editor_html.substring(0,pos) + '<a href="#'+text.id.replace('__','--')+'">'+plaintext+'</a>' + editor_html.substring(pos+marker_key.length);
      }
    } 
    else 
    { 
      tinyMCE.execInstanceCommand(Aurita.temp_editor_id, 'mceInsertRawHTML', false, '<a href="#'+text.id.replace('__','--')+'">'+plaintext+'</a>');
    }
    context_menu_close(); 
  }, 

  autocomplete_link_article_handler : function(text, li) { 
    plaintext = Aurita.temp_range.text; 
    hashcode = text.id.replace('__','--'); 
    onclick = "Aurita.set_hashcode(&apos;"+hashcode+"&apos;); "; 
    if(Aurita.check_if_internet_explorer() == '1') { 
      marker_key = 'find_and_replace_me';
      Aurita.temp_range.text = marker_key; 
      editor_html = Aurita.temp_editor_instance.getBody().innerHTML; 
      pos = editor_html.indexOf(marker_key); 
      if(pos != -1) { 
        Aurita.temp_editor_instance.getBody().innerHTML = editor_html.substring(0,pos) + '<a href="#'+hashcode+'" onclick="'+onclick+'">'+plaintext+'</a>' + editor_html.substring(pos+marker_key.length);
      }
    } 
    else 
    { 
      tinyMCE.execInstanceCommand(Aurita.temp_editor_id, 'mceInsertRawHTML', false, '<a href="#'+hashcode+'" onclick="'+onclick+'">'+Aurita.temp_range+'</a>');
    }
    context_menu_close(); 
  }, 

  init_autocomplete_articles : function(xml_conn, element, update_source)
  {
    element.innerHTML = xml_conn.responseText; 
    new Ajax.Autocompleter("autocomplete_article", 
                           "autocomplete_article_choices", 
                           "/aurita/poll", 
                           { 
                             minChars: 2, 
                             updateElement: autocomplete_article_handler, /* TODO: Handler doesn't exist any more?! */
                             tokens: [' ',',','\n']
                           }
    );
  }, 

  init_link_autocomplete_articles : function()
  {
    new Ajax.Autocompleter("autocomplete_link_article", 
                           "autocomplete_link_article_choices", 
                           "/aurita/poll", 
                           { 
                             minChars: 2, 
                             updateElement: autocomplete_link_article_handler, 
                             tokens: [' ',',','\n'], 
                             parameters: 'controller=Autocomplete&action=articles&mode=async'
                           }
    );
  }, 

  on_article_reorder : function(container)
  {
    position_values = Sortable.serialize(container.id);
    Aurita.call({ action : 'Wiki::Article/perform_reorder/' + position_values + 
                           '&content_id_parent=' + Aurita.Wiki.reorder_article_content_id }); 
  }, 

  init_article_reorder : function(article_content_id)
  {
      Aurita.Wiki.reorder_article_content_id = article_content_id; 
      Sortable.create("article_partials_list", 
                      { dropOnEmpty: true, 
                        onUpdate: Aurita.Wiki.on_article_reorder, 
                        handle: true }); 
  }, 

  init_article : function(xml_conn, element, update_source)
  {
      element.innerHTML = xml_conn.responseText; 
  }, 

  attachment_text_asset_content_id : false, 
  init_container_attachment_editor : function(article_id, text_asset_content_id) { 
    
  }, 

  handle_container_attachment : function(widget_response) { 
    widget = Aurita.eval_response(widget_response); 
    if(!widget && widget['html']) { return; } 
    widget = widget['html']; 

    $('selected_media_assets').innerHTML += widget; 
  }, 

  // mark_image : function(image_index, media_asset_content_id, media_asset_id, thumbnail_suffix, desc)
  add_container_attachment : function(media_asset_id) 
  {
    Aurita.load_widget('Wiki::Media_Asset_Selection_Thumbnail', 
                       { media_asset_id: media_asset_id, size: 'tiny' }, 
                       Aurita.Wiki.handle_container_attachment); 
  }, 

  init_container_inline_editor : function(xml_conn, element, update_source)
  {
      element.innerHTML = xml_conn.responseText; 
      Element.setOpacity(element, 1.0); 
      init_all_editors(); 
  }, 

  select_media_asset : function(params) {
      var hidden_field_id = params['hidden_field']; 
      var user_id = params['user_id']; 
      var hidden_field = $(hidden_field_id); 
      var select_box_id = 'select_box_'+hidden_field_id;
      select_box = $(select_box_id); 
      Aurita.load({ element: select_box_id, 
                    action: 'Wiki::Media_Asset/choose_from_user_folders/user_group_id='+user_id+'&image_dom_id='+hidden_field_id }); 
      Element.setStyle(select_box, { display: 'block' });
      Element.setStyle(select_box, { width: '100%' });
  }, 

  select_media_asset_click : function(media_asset_id, element_id) { 
      var hidden_field = $(element_id);
      var image = $('picture_asset_'+element_id); 

      image.src = ''; 
      if(media_asset_id == 0) { 
        image.style.display = 'none';
        hidden_field.value = '1'; 
        $('clear_selected_image_button'+element_id).style.display = 'none'; 
      } else { 
        image.src = '/aurita/assets/medium/asset_'+media_asset_id+'.jpg';
        image.style.display = 'block';
        hidden_field.value = media_asset_id; 
        $('clear_selected_image_button_'+element_id).style.display = ''; 
      }
  }, 

  expanded_folder_ids : {}, 
  load_media_asset_folder_level : function(parent_folder_id, indent) {
    if($('folder_expand_icon_'+parent_folder_id)) { 
      if($('folder_expand_icon_'+parent_folder_id).src.match('folder_collapse.gif')) { 
        $('folder_expand_icon_'+parent_folder_id).src = '/aurita/images/icons/folder_expand.gif'; 
        Aurita.Wiki.expanded_folder_ids[parent_folder_id] = false; 
        Element.hide('folder_children_'+parent_folder_id); 
        return;
      }
      else { 
        Element.show('folder_children_'+parent_folder_id); 
        Aurita.Wiki.expanded_folder_ids[parent_folder_id] = true; 
        $('folder_expand_icon_'+parent_folder_id).src = '/aurita/images/icons/folder_collapse.gif'; 
        if($('folder_children_'+parent_folder_id).innerHTML.length < 10) { 
          Aurita.load({ element: 'folder_children_'+parent_folder_id, 
                        action: 'Wiki::Media_Asset_Folder/tree_box_level/media_folder_id='+parent_folder_id+'&indent='+indent }); 
        }
      }
    }
  }, 

  open_folder : 0, 
  change_folder_icon : function(value) { 
    folder_to_open = $("folder_icon_" + value);
    folder_to_close = $("folder_icon_" + Aurita.Wiki.open_folder);
    if(folder_to_close) { 
      folder_to_close.src = "/aurita/images/icons/folder_closed.gif"; 
    }
    if(folder_to_open) { 
      folder_to_open.src = "/aurita/images/icons/folder_opened.gif"; 
    }
    Aurita.Wiki.open_folder = value;
  }, 

  recently_viewed : [], 
  recently_viewed_titles : [], 
  recently_viewed_models : [], 
  add_recently_viewed : function(model, asset_id, title) { 
    Aurita.Wiki.recently_viewed_titles[asset_id] = title; 
    Aurita.Wiki.recently_viewed_models[asset_id] = model; 

    if(Aurita.Wiki.recently_viewed.indexOf(asset_id) != -1) { 
      // remove previous appearance of asset_id from list: 
      Aurita.Wiki.recently_viewed.splice(Aurita.Wiki.recently_viewed.indexOf(asset_id), 1); 
    }
    else { 
      // remove last asset_id from list: 
      if(Aurita.Wiki.recently_viewed.length > 10) Aurita.Wiki.recently_viewed.shift(); 
    }
    Aurita.Wiki.recently_viewed.push(asset_id); 
    template = $('recently_viewed_element_template').innerHTML; 
    content = ''; 
    Aurita.Wiki.recently_viewed.reverse(); 
    for(i=0; i<Aurita.Wiki.recently_viewed.length; i++) {
      cid      = Aurita.Wiki.recently_viewed[i]; 
      title    = Aurita.Wiki.recently_viewed_titles[cid]; 
      model    = Aurita.Wiki.recently_viewed_models[cid];
      content += template.replace('__id__', cid).replace('__id__', cid).replace('__id__', cid).replace('{title}', title).replace('__model__', model); 
    }
    Aurita.Wiki.recently_viewed.reverse(); 
    $('recently_viewed_list').innerHTML = content; 
  }

};

