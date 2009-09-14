

function init_login_screen(element) {
    new Effect.Appear('login_box',{duration: 2, to: 1.0}); 
}

function init_autocomplete_username(xml_conn, element, update_source)
{
  element.innerHTML = xml_conn.responseText; 
  new Ajax.Autocompleter("autocomplete_username", 
                         "autocomplete_username_choices", 
                         "/aurita/autocomplete_username.fcgi", 
                         { 
                           minChars: 2, 
                           tokens: [' ',',','\n']
                         }
  );
}
function init_autocomplete_single_username(xml_conn, element, update_source)
{
  autocomplete_selected_users = {}; 
  element.innerHTML = xml_conn.responseText; 
  new Ajax.Autocompleter("autocomplete_username", 
                         "autocomplete_username_choices", 
                         "/aurita/autocomplete_username.fcgi", 
                         { 
                           minChars: 2, 
                           updateElement: autocomplete_single_username_handler, 
                           tokens: []
                         }
  );
}

function autocomplete_article_handler(text, li) { 
  plaintext = Cuba.temp_range.text; 
  if(Cuba.check_if_internet_explorer() == '1') { 
    marker_key = 'find_and_replace_me';
    Cuba.temp_range.text = marker_key; 
    editor_html = Cuba.temp_editor_instance.getBody().innerHTML; 
    pos = editor_html.indexOf(marker_key); 
    if(pos != -1) { 
      Cuba.temp_editor_instance.getBody().innerHTML = editor_html.substring(0,pos) + '<a href="#'+text.id.replace('__','--')+'">'+plaintext+'</a>' + editor_html.substring(pos+marker_key.length);
    }
  } 
  else 
  { 
    tinyMCE.execInstanceCommand(Cuba.temp_editor_id, 'mceInsertRawHTML', false, '<a href="#'+text.id.replace('__','--')+'">'+plaintext+'</a>');
  }
  context_menu_close(); 
}

function autocomplete_link_article_handler(text, li) { 
  plaintext = Cuba.temp_range.text; 
  hashcode = text.id.replace('__','--'); 
  onclick = "Cuba.set_hashcode(&apos;"+hashcode+"&apos;); "; 
  if(Cuba.check_if_internet_explorer() == '1') { 
    marker_key = 'find_and_replace_me';
    Cuba.temp_range.text = marker_key; 
    editor_html = Cuba.temp_editor_instance.getBody().innerHTML; 
    pos = editor_html.indexOf(marker_key); 
    if(pos != -1) { 
      Cuba.temp_editor_instance.getBody().innerHTML = editor_html.substring(0,pos) + '<a href="#'+hashcode+'" onclick="'+onclick+'">'+plaintext+'</a>' + editor_html.substring(pos+marker_key.length);
    }
  } 
  else 
  { 
    tinyMCE.execInstanceCommand(Cuba.temp_editor_id, 'mceInsertRawHTML', false, '<a href="#'+hashcode+'" onclick="'+onclick+'">'+Cuba.temp_range+'</a>');
  }
  context_menu_close(); 
}

function autocomplete_single_username_handler(li)
{
  username = li.innerHTML.replace(/(.+)?<b>([^<]+)<\/b>(.+)/, "$2"); 
  user_group_id = li.id.replace('user__',''); 
  if(!autocomplete_selected_users[user_group_id]) { 
  $('username_list').innerHTML += '<div id="user_autocomplete_entry_'+ user_group_id +'">'+
                                  '<span class="link" onclick="Element.remove(\'user_autocomplete_entry_'+ user_group_id +'\'); '+
                                                              'autocomplete_selected_users['+user_group_id+'] = false; ">x</span> '+
                                  username +'<br />' +
                                  '<span style="margin-left: 7px; ">'+
                                  '<input type="checkbox" value="t" name="readonly_'+ user_group_id +'" /> nur Lesen'+
                                  '</span>'+
                                  '<input type="hidden" value="'+ user_group_id +'" name="user_group_ids[]" />'+
                                  '</div>';
  }
  autocomplete_selected_users[user_group_id] = true; 

}

function init_autocomplete_articles(xml_conn, element, update_source)
{
  element.innerHTML = xml_conn.responseText; 
  new Ajax.Autocompleter("autocomplete_article", 
                         "autocomplete_article_choices", 
                         "/aurita/dispatch.fcgi", 
                         { 
                           minChars: 2, 
                           updateElement: autocomplete_article_handler, /* TODO: Handler doesn't exist any more?! */
                           tokens: [' ',',','\n']
                         }
  );
}

function init_link_autocomplete_articles()
{
  new Ajax.Autocompleter("autocomplete_link_article", 
                         "autocomplete_link_article_choices", 
                         "/aurita/dispatch.fcgi", 
                         { 
                           minChars: 2, 
                           updateElement: autocomplete_link_article_handler, 
                           tokens: [' ',',','\n']
                         }
  );
}

function init_media_interface(xml_conn, element, update_source)
{
    element.innerHTML = xml_conn.responseText; 

    for(index=0; index<3000; index++) {
      if(document.getElementById('folder_'+index))
      {
          Cuba.droppables[index] = index;
          Droppables.add('folder_'+index,
             { onDrop: drop_image_in_folder, 
               onHover: activate_target, 
               greedy: true }); 
      }
    }

}

function init_poll_editor(xml_conn, element, update_source)
{
    element.innerHTML = xml_conn.responseText; 

    Poll_Editor.option_counter = 0; 
    Poll_Editor.option_amount = 0; 
}

var reorder_article_content_id; 
function on_article_reorder(container)
{
    position_values = Sortable.serialize(container.id);
    cb__load_interface_silently('dispatcher','/aurita/Wiki::Article/perform_reorder/' + position_values + '&content_id_parent=' + reorder_article_content_id); 
}
function init_article_reorder_interface(xml_conn, element, update_source)
{
    element.innerHTML = xml_conn.responseText; 

    Sortable.create("article_partials_list", 
		    { dropOnEmpty:true, 
		      onUpdate: on_article_reorder, 
		      handle: true }); 
}

function init_article(xml_conn, element, update_source)
{
    element.innerHTML = xml_conn.responseText; 
    initLightbox(); 
}

var tinyMCE = tinyMCE; 
var registered_editors = {}; 
function flush_editor_register() {
    for(var editor_id in registered_editors) {
      flush_editor(editor_id);     
    }
    registered_editors = {}; 
}

function init_editor(textarea_element_id) 
{
    if(registered_editors[textarea_element_id] == null) { 
      registered_editors[textarea_element_id] = textarea_element_id; 
      tinyMCE.execCommand('mceAddControl', false, textarea_element_id); 
    }
}
function save_editor(textarea_element_id) 
{
    if($(textarea_element_id)) { 
      Element.setStyle(textarea_element_id, { visibility: 'hidden' }); 
    }
    registered_editors[textarea_element_id] = null; 
    tinyMCE.execInstanceCommand(textarea_element_id,'mceCleanup');
    tinyMCE.execCommand('mceRemoveControl', true, textarea_element_id);
    tinyMCE.triggerSave(true,true);
}
function flush_editor(textarea_element_id)
{
    if(!$(textarea_element_id)) { return; }

    Element.setStyle(textarea_element_id, { visibility: 'hidden' }); 
    log_debug('flushing '+textarea_element_id); 
    tinyMCE.execInstanceCommand(textarea_element_id,'mceCleanup');
    tinyMCE.execCommand('mceRemoveControl', true, textarea_element_id);
    tinyMCE.triggerSave();
    registered_editors[textarea_element_id] = null; 
}
function init_all_editors(element) {
	try { 
		elements = document.getElementsByTagName('textarea');
		if(!elements || elements == undefined || elements == null) { log_debug('elements in init_all_editors is undefined'); return; }
		if(elements == undefined || !elements.length) { log_debug('Error: elements.length in init_all_editors is undefined'); return; }
		for (var i = 0; i < elements.length; i++) {
			elem_id = elements.item(i).id; 
			if(registered_editors[elem_id] == null) { 
				log_debug('init editor instance: ' + elem_id);
				inst = $(elem_id); 
				if(inst) { init_editor(elem_id); }
			}
		}
  } catch(e) { 
		log_debug('Catched Exception'); 
		return; 
  }
}

function save_all_editors(element) {
	try { 
		var inst = false; 
		elements = document.getElementsByTagName('textarea');
		if(!elements || elements == undefined || elements == null) { log_debug('Error: elements in init_all_editors is undefined'); return; }
		log_debug('saving all editors'); 
		for (var i = 0; i < elements.length; i++) {
			elem_id = elements.item(i).id; 
			if(elem_id && elem_id.match('lore_textarea')) { 
				inst = $(elem_id);
			}
			if(inst) { save_editor(inst.id); }
		}
  } catch(e) { 
		log_debug('Catched Exception'); 
		return; 
  }
}

function enlarge_textarea() {
    for(i=0; i<10; i++) {
      inst = document.getElementById('mce_editor_'+i); 
      if(inst) { Element.setStyle(inst, { width: '500px', height: '300px' }); }
    }
}


function init_user_profile()
{
    alert('foo'); 
    init_editor('guestbook_textarea'); 
}

var calendar; 
function open_calendar(field_id, button_id)
{

    var onSelect = function(calendar, date) { 
      document.getElementById(field_id).value = date; 
      if (calendar.dateClicked) {
          calendar.callCloseHandler(); // this calls "onClose" (see above)
      };
    }
    var onClose = function(calendar) { calendar.hide(); }

    calendar = new Calendar(1, null, onSelect, onClose);

    calendar.create(); 

    calendar.showAtElement(document.getElementById(field_id), 'Bl'); 

    return; ///////////////////////////////////////////////////////////

    if(document.getElementById('date_field')) {
      Calendar.setup({
             inputField  : "date_field",  // ID of the input field
             ifFormat    : "%d.%m.%Y",    // the date format
             button      : "date_trigger" // ID of the button
      });
    }
}

function reload_selected_media_assets()
{
    cb__load_interface_silently('selected_media_assets', '/aurita/Wiki::Media_Asset/list_selected/content_id='+active_text_asset_content_id);
}
function asset_entry_string(image_index, content_id, media_asset_id, thumbnail_suffix)
{
  if(!thumbnail_suffix || thumbnail_suffix == 'jpg') { 
    thumbnail_suffix = media_asset_id; 
  }
  string = ''+
   '<div id="image_wrap__'+content_id+'">'+
   '<div style="float: left; margin-top: 4px; margin-left: 4px; height: 120px; border: 1px solid #aaaaaa; background-color: #ffffff; ">'+
     '<div style="height: 100px; width: 120px; overflow: hidden;">'+
       '<img src="/aurita/assets/thumb/asset_'+thumbnail_suffix+'.jpg" />'+
     '</div>'+
     '<div onclick="deselect_image('+content_id+');" style="cursor: pointer; background-color: #eaeaea; padding: 3px; position: relative; left: 0px; bottom: 0px; width: 12px; height: 12px; text-align: center; ">X</div>'+
   '</div>'+
   '</div>'; 

   return string; 
}
var active_text_asset_content_id;
function mark_image(image_index, media_asset_content_id, media_asset_id, thumbnail_suffix)
{
  marked_image_register = document.getElementById('marked_image_register').value; 
  if (marked_image_register != '') { 
      marked_image_register += '_'; 
  }
  marked_image_register += media_asset_content_id; 
  document.getElementById('marked_image_register').value = marked_image_register; 

  document.getElementById('selected_media_assets').innerHTML += asset_entry_string(image_index, media_asset_content_id, media_asset_id, thumbnail_suffix);
}
function deselect_image(media_asset_content_id) 
{ 
  Cuba.delete_element('image_wrap__'+ media_asset_content_id);
  marked_image_register = document.getElementById('marked_image_register').value; 
  marked_image_register = marked_image_register.replace(media_asset_content_id, '').replace('__', '_');
  document.getElementById('marked_image_register').value = marked_image_register; 
}
function init_container_inline_editor(xml_conn, element, update_source)
{
    element.innerHTML = xml_conn.responseText; 
    init_all_editors(); 
}
