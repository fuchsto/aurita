/* ==============================================
   === FILE: public/inc/log.js 
   ==============================================*/

function log_debug(message) { 
  if(window.console && window.console.log) { 
    window.console.log(message); 
  } 
  if(document.getElementById('developer_console')) { 
    document.getElementById('developer_console').innerHTML += (message + '<br />');
  }
}
/* ==============================================
   === END FILE: public/inc/log.js 
   ==============================================*/

/* ==============================================
   === FILE: public/inc/ui.js 
   ==============================================*/

date_obj = new Date(); 

function swap_image_choice_list()
{
    Element.setStyle('image_choice_list', { display: '' }); 
    Element.setStyle('text_asset_form', { display: 'none' }); 
    Element.setStyle('choose_custom_form', { display: 'none' }); 
    Cuba.disable_context_menu_draggable(); 
}
function swap_text_edit_form()
{
    Element.setStyle('image_choice_list', { display: 'none'}); 
    Element.setStyle('text_asset_form', { display: ''}); 
    Element.setStyle('choose_custom_form', { display: 'none'}); 
    Cuba.enable_context_menu_draggable(); 
}
function swap_choose_custom_form()
{
    Element.setStyle('image_choice_list', { display: 'none'}); 
    Element.setStyle('text_asset_form', { display: 'none'}); 
    Element.setStyle('choose_custom_form', { display: ''}); 
    Cuba.enable_context_menu_draggable(); 
}

function profile_load_interfaces(uid, what)
{
  Cuba.load({ element: 'profile_content', action: 'User_Profile/show_'+what+'/user_group_id='+uid, on_update: on_data }); 
}

var active_profile_button = false;
function profile_load(uid, which)
{
  new Effect.Fade('profile_content', {duration: 0.5}); 
  if($('profile_flag_main')) { 
    $('profile_flag_main').className = 'flag_button'
  }
  if($('profile_flag_own_main')) { 
    $('profile_flag_own_main').className = 'flag_button'
  }
  $('profile_flag_galery').className = 'flag_button'
  $('profile_flag_posts').className  = 'flag_button'
  $('profile_flag_friends').className  = 'flag_button'
  if(!active_profile_button) { 
    document.getElementById('profile_flag_main'); 
  }
  active_profile_button.className = 'flag_button';
  active_profile_button = document.getElementById('profile_flag_'+which); 
  active_profile_button.className = 'flag_button_active';
  setTimeout("profile_load_interfaces('"+uid+"','"+which+"')", 550); 
}

function messaging_load_interfaces(what)
{
  Cuba.load({ element: 'messaging_content', action: 'Messaging::Mailbox/show_'+what, on_update: on_data }); 
}

var last_message_shown = false; 
function messaging_show_message(mesg_id, style, mark_as_read) { 
  var message_list_element = 'message_entry_'+mesg_id; 
  focus_element(message_list_element); 
  if(last_message_shown && last_message_shown != message_list_element) { 
    unfocus_element(last_message_shown); 
  }
  last_message_shown = message_list_element; 
  if(mark_as_read) { 
    Cuba.load({ element: 'dispatcher', 
                action: 'Messaging::User_Message/mark_as_read/user_message_id='+mesg_id }); 
  }
  if($('message_'+mesg_id)) { 
    // Message is preloaded; 
    $('message_viewer').innerHTML = $('message_'+mesg_id).innerHTML;
  } 
  else { 
    // Message has to be requested: 
    Cuba.load({ element: 'message_viewer', action: 'Messaging::User_Message/show/user_message_id='+mesg_id+'&style='+style }); 
  }
}

var active_messaging_button = false;
function messaging_load(which)
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

  messaging_load_interfaces(which); 
}

function autocomplete_username_handler(text, li)
{
  generic_id = text.id; 
}

/* ==============================================
   === END FILE: public/inc/ui.js 
   ==============================================*/
/* ==============================================
   === FILE: public/inc/helpers.js 
   ==============================================*/


var Browser = {
    is_ie    : document.all&&document.getElementById,
    is_gecko : document.getElementById&&!document.all
};

function element_exists(id)
{
    return (document.getElementById(id) != undefined);
}
function add_event( obj, type, fn )
{
   if (obj.addEventListener) {
      obj.addEventListener( type, fn, false );
   } else if (obj.attachEvent) {
      obj["e"+type+fn] = fn;
      obj[type+fn] = function() { obj["e"+type+fn]( window.event ); }
      obj.attachEvent( "on"+type, obj[type+fn] );
   }
}

function remove_event( obj, type, fn )
{
   if (obj.removeEventListener) {
      obj.removeEventListener( type, fn, false );
   } else if (obj.detachEvent) {
      obj.detachEvent( "on"+type, obj[type+fn] );
      obj[type+fn] = null;
      obj["e"+type+fn] = null;
   }
}

function position_of(obj) 
{
    var curleft = curtop = 0;
    if (obj.offsetParent) {
      curleft = obj.offsetLeft
      curtop = obj.offsetTop
      while (obj = obj.offsetParent) {
        curleft += obj.offsetLeft
        curtop += obj.offsetTop
      }
    }
    return [curleft,curtop];
}

function getPageScroll(){

  var yScroll;

  if (self.pageYOffset) {
    yScroll = self.pageYOffset;
  } else if (document.documentElement && document.documentElement.scrollTop){  // Explorer 6 Strict
    yScroll = document.documentElement.scrollTop;
  } else if (document.body) {// all other Explorers
    yScroll = document.body.scrollTop;
  }

  arrayPageScroll = new Array('',yScroll) 
  return arrayPageScroll;
}

var mouse_x = 0; 
var mouse_y = 0; 
function capture_mouse(ev) 
{
    if(!ev) { ev = window.event; }
    if(!ev) { return ; }

// Is IE
    if(Browser.is_ie) { 
      mouse_x = ev.clientX;  // ignore horizontal scroll
      mouse_y = ev.clientY + getPageScroll()[1]; 
    }
// Is Gecko
    else if (Browser.is_gecko) { 
      mouse_x = ev.pageX; 
      mouse_y = ev.pageY; 
    }
//    Element.setStyle('context_menu_icon', { left: (mouse_x+5)+'px', top: (mouse_y+5)+'px' });
//    window.status = mouse_x + 'x' + mouse_y; 
}
function get_mouse(event) 
{
    return [mouse_x, mouse_y];
}

function get_style(el, style) 
{
    if(!document.getElementById) return;
    var value = el.style[style];
    
    if(!value) { 
      if(document.defaultView) {
        value = document.defaultView.getComputedStyle(el, "").getPropertyValue(style);
      } else if(el.currentStyle) { 
        value = el.currentStyle[style];
      }
    }
    return value; 
}

function is_mouse_over(obj)
{
    if(!obj) { return; } 
    width = parseInt(Element.getWidth(obj)); 
    height = parseInt(Element.getHeight(obj));
    if(!width) { width = obj.offsetWidth; }
    if(!height) { width = obj.offsetheight; }
    pos = position_of(obj);
    x = pos[0];
    y = pos[1];
    
    if(obj.style.x) { x = obj.style.x; }
    if(obj.style.y) { y = obj.style.y; }
    
    if(mouse_x >= x && mouse_x <= x+width &&
       mouse_y >= y && mouse_y <= y+height) {
      window.status = 'OVER MENU '+mouse_x+' '+mouse_y; 
      return true; 
    } 
    else {
      return false; 
    }
}

function rgb_to_hex(str)
{
    var pattern = /\([^\)]+\)/gi;
    var result = ''+str.match(pattern);

    result = result.replace(/\(/,'').replace(/\)/,'');

    var hex = '#';
    tmp = result.split(', ');

    for (m=0; m<3; m++) {
      value = (tmp[m]*1).toString(16);
      if(value.length < 2) { value = '0'+value; }
      hex += value;
    }
    return hex;
}

var last_hovered_element = false; 
function hover_element(elem_id) { 
  if(last_hovered_element) { 
    try { 
      Element.removeClassName($(last_hovered_element), 'hovered'); 
    } catch(e) { }
  }
  Element.addClassName($(elem_id), 'hovered'); 
  last_hovered_element = elem_id; 
}
function unhover_element(elem_id) { 
  Element.removeClassName($(elem_id), 'hovered'); 
}

function focus_element(element_id)
{
    Element.addClassName(element_id, 'highlighted'); 
    Element.setStyle(element_id, {zIndex: 301});
}
function unfocus_element(element_id)
{
    if(element_exists(element_id)) {
      Element.removeClassName(element_id, 'highlighted'); 
      Element.setStyle(element_id, {zIndex: 1});
    }
}

function swap_style(style, value_1, value_2, target)
{
    obj = document.getElementById(target); 
    style_curr = obj.style[style]; 
    
    obj.style[style] = value_1; 
    if(obj.style[style] == style_curr) {
      obj.style[style] = value_2; 
    }
}

function swap_value(element_id, value_1, value_2)
{
    obj = document.getElementById(element_id); 
    value_curr = obj.value; 
    
    obj.value = value_1; 
    if(obj.value == value_curr) {
      obj.value = value_2; 
    }
    
}


function resizeable_popup(w, h, url)
{
    LeftPosition = (screen.width) ? (screen.width-w)/2 : 0;
    TopPosition = (screen.height) ? (screen.height-h)/2 : 0;
    settings = 'height='+h+',width='+w+',top='+TopPosition+',left='+LeftPosition+',scrollbars=1,resizable=1,menubar=0,fullscreen=0,status=0';
    win = window.open(url,"popup",settings);
    win.focus();
}

function checkbox_swap(element)
{
    if(element.checked == true) {
      element.value = '1'; 
    }
    else {
      element.value = '0'; 
    }
}

function alert_array(arr) { 
  s = ''; 
  for(var e in arr) { 
    s += (e + ' | ' + arr[e]); 
  } 
  alert(s); 
}
/* ==============================================
   === END FILE: public/inc/helpers.js 
   ==============================================*/
/* ==============================================
   === FILE: public/inc/cookie.js 
   ==============================================*/
/**
 * Sets a Cookie with the given name and value.
 *
 * name       Name of the cookie
 * value      Value of the cookie
 * [expires]  Expiration date of the cookie (default: end of current session)
 * [path]     Path where the cookie is valid (default: path of calling document)
 * [domain]   Domain where the cookie is valid
 *              (default: domain of calling document)
 * [secure]   Boolean value indicating if the cookie transmission requires a
 *              secure transmission
 */
function setCookie(name, value, expires, path, domain, secure) {
    path = '/'; 
    document.cookie= name + "=" + escape(value) +
        ((expires) ? "; expires=" + expires.toGMTString() : "") +
        ((path) ? "; path=" + path : "") +
        ((domain) ? "; domain=" + domain : "") +
        ((secure) ? "; secure" : "");
}

/**
 * Gets the value of the specified cookie.
 *
 * name  Name of the desired cookie.
 *
 * Returns a string containing value of specified cookie,
 *   or null if cookie does not exist.
 */
function getCookie(name) {
    var dc = document.cookie;
    var prefix = name + "=";
    var begin = dc.indexOf("; " + prefix);
    if (begin == -1) {
        begin = dc.indexOf(prefix);
        if (begin != 0) return null;
    } else {
        begin += 2;
    }
    var end = document.cookie.indexOf(";", begin);
    if (end == -1) {
        end = dc.length;
    }
    return unescape(dc.substring(begin + prefix.length, end));
}

/**
 * Deletes the specified cookie.
 *
 * name      name of the cookie
 * [path]    path of the cookie (must be same as path used to create cookie)
 * [domain]  domain of the cookie (must be same as domain used to create cookie)
 */
function deleteCookie(name, path, domain) {
    path = '/'; 
    if (getCookie(name)) {
        document.cookie = name + "=" +
            ((path) ? "; path=" + path : "") +
            ((domain) ? "; domain=" + domain : "") +
            "; expires=Thu, 01-Jan-70 00:00:01 GMT";
    }
}
/* ==============================================
   === END FILE: public/inc/cookie.js 
   ==============================================*/
/* ==============================================
   === FILE: public/inc/init.js 
   ==============================================*/


function init_login_screen(element) {
    new Effect.Appear('login_box',{duration: 2, to: 1.0}); 
}


function init_article_interface(element) { 
}

function init_autocomplete_tags()
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
}

function autocomplete_single_tag(li)
{
  tag = li.id.replace('tag_',''); 
  Cuba.load({ element: 'tag_form', action: 'Tag_Synonym/show/tag='+tag });
  return true; 
}
function init_autocomplete_tag_selection()
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
}

function init_send_mail() { 
  init_autocomplete_username()
}

function init_autocomplete_username()
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
}

var autocomplete_selected_users = {}; 
function init_autocomplete_single_username()
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
}
function autocomplete_single_username_handler(li)
{
  $('autocomplete_username').value = ''; 
  uname = li.innerHTML.replace(/^.+<b>([^>]+?)<\/b>.+$/,'$1'); // username is in <b> tag
  uid = li.id.replace('user__',''); 
  entry =  '<li id="user_group_id_'+uid+'">'
  entry += '<input type="hidden" name="user_group_ids[]" value="'+uid+'" />'
  entry += '<span class="link" onclick="Element.remove(\'user_group_id_'+uid+'\');">X </span>'+uname+'</li>';
  $('user_group_ids_selected_options').innerHTML += entry; 

  return true; 
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

function category_selection_add(category_field_id)
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
}
function category_selection_add_option(category_field_id, option_value, option_name) { 
  
}

function set_dialog_link(url) { 
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
  context_menu_close(); 
}

function init_autocomplete_articles(xml_conn, element, update_source)
{
  element.innerHTML = xml_conn.responseText; 
  new Ajax.Autocompleter("autocomplete_article", 
                         "autocomplete_article_choices", 
                         "/aurita/dispatch_runner.fcgi", 
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
                         "/aurita/dispatch_runner.fcgi", 
                         { 
                           minChars: 2, 
                           updateElement: autocomplete_link_article_handler, 
                           tokens: [' ',',','\n'], 
                           parameters: 'controller=Autocomplete&action=articles&mode=async'
                         }
  );
}

function init_media_interface(xml_conn, element, update_source)
{
    element.innerHTML = xml_conn.responseText; 
    Element.setOpacity(element, 1.0); 
return;  // Some Bug in IE when initializing Droppables! 

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
//  element.innerHTML = xml_conn.responseText; 

    Sortable.create("article_partials_list", 
                    { dropOnEmpty: true, 
                      onUpdate: on_article_reorder, 
                      handle: true }); 
}
function on_bookmark_reorder(container)
{
    position_values = Sortable.serialize(container.id);
    cb__load_interface_silently('dispatcher','/aurita/Bookmarking::Bookmark/perform_reorder/' + position_values); 
}
var reorder_hierarchy_id; 
function on_hierarchy_entry_reorder(entry)
{
    position_values = Sortable.serialize(entry.id);
    Aurita.load_silently({ element: 'dispatcher', 
                           action: 'Hierarchy/perform_reorder/' + position_values + '&hierarchy_id=' + reorder_hierarchy_id }); 
}

function init_article(xml_conn, element, update_source)
{
    element.innerHTML = xml_conn.responseText; 
}

var tinyMCE = tinyMCE; 
var registered_editors = {}; 
function flush_editor_register() {
    for(var editor_id in registered_editors) {
      try { 
          flush_editor(editor_id);     
      } catch(e) { 
        log_debug('ERROR in flush_editor_register '+editor_id); 
      }
    }
    registered_editors = {}; 
}

function init_editor(textarea_element_id) 
{
    if(registered_editors[textarea_element_id] == null) { 
      registered_editors[textarea_element_id] = textarea_element_id; 
      try { 
        Element.setStyle(textarea_element_id, { visibility: true }); 
      } catch(e) { 
        log_debug('init_editor: ' + e.message); 
      }
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
    save_all_editors(element); 

		elements = document.getElementsByTagName('textarea');
		if(!elements || elements == undefined || elements == null) { log_debug('elements in init_all_editors is undefined'); return; }
		if(elements == undefined || !elements.length) { log_debug('Error: elements.length in init_all_editors is undefined'); return; }
		for (var i = 0; i < elements.length; i++) {
			elem_id = elements.item(i).id; 
      log_debug('editor in register: '+registered_editors[elem_id]); 
			if(registered_editors[elem_id] == null) { 
				log_debug('init editor instance: ' + elem_id);
				inst = $(elem_id); 
				if(inst && Element.hasClassName(inst, 'editor')) { init_editor(elem_id); }
			}
		}
  } catch(e) { 
		log_debug('Catched Exception ' + e.message); 
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
		//	if(elem_id && elem_id.match('lore_textarea')) { 
				inst = $(elem_id);
		//	}
	    if(inst && Element.hasClassName(inst, 'editor')) { save_editor(elem_id); }
		}
  } catch(e) { 
		log_debug('Catched Exception: ' + e); 
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

  log_debug('opening calendar'); 
  
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
function asset_entry_string(image_index, content_id, media_asset_id, thumbnail_suffix, desc)
{
  if(!thumbnail_suffix || thumbnail_suffix == 'jpg') { 
    thumbnail_suffix = media_asset_id; 
  }
  string = ''+
   '<div id="image_wrap__'+content_id+'">'+
   '<div style="float: left; margin-top: 4px; margin-left: 4px; height: 120px; border: 1px solid #aaaaaa; background-color: #ffffff; padding: 2px; ">'+
     '<div style="height: 100px; width: 120px; overflow: hidden;">'; 
  if(thumbnail_suffix == 'image') { 
    string += '<img src="/aurita/assets/thumb/asset_'+media_asset_id+'.jpg" /><div style="clear: both; "></div><br />'+desc; 
  }
  else { 
    string += '<img src="/aurita/assets/thumb/asset_'+thumbnail_suffix+'.gif" style="padding: 2px; " /><div style="clear: both; "></div><br />'+desc; 
  }
  string += 
         '</div>'+
         '<div onclick="deselect_image('+content_id+');" style="cursor: pointer; background-color: #eaeaea; padding: 3px; position: relative; left: 0px; bottom: 0px; width: 12px; height: 12px; text-align: center; ">X</div>'+
       '</div>'+
       '</div>';

  return string; 
}
var active_text_asset_content_id;
function mark_image(image_index, media_asset_content_id, media_asset_id, thumbnail_suffix, desc)
{
  marked_image_register = document.getElementById('marked_image_register').value; 
  if (marked_image_register != '') { 
      marked_image_register += '_'; 
  }
  marked_image_register += media_asset_content_id; 
  document.getElementById('marked_image_register').value = marked_image_register; 

  document.getElementById('selected_media_assets').innerHTML += asset_entry_string(image_index, media_asset_content_id, media_asset_id, thumbnail_suffix, desc);
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
    Element.setOpacity(element, 1.0); 
    init_all_editors(); 
}
/* ==============================================
   === END FILE: public/inc/init.js 
   ==============================================*/
/* ==============================================
   === FILE: public/inc/remote_call.js 
   ==============================================*/
/** XHConn - Simple XMLHTTP Interface - bfults@gmail.com - 2005-04-08        **
 ** Code licensed under Creative Commons Attribution-ShareAlike License      **
 ** http://creativecommons.org/licenses/by-sa/2.0/                           **/
function XHConn()
{
  var xmlhttp, bComplete = false;
  var request_url = false; 

  try {
      //    netscape.security.PrivilegeManager.enablePrivilege("UniversalBrowserRead");
  } catch (e) {
    alert("Permission UniversalBrowserRead denied.");
  }

  this.req_url = function() { 
    return request_url;
  }

  try { xmlhttp = new ActiveXObject("Msxml2.XMLHTTP"); }
  catch (e) { try { xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); }
  catch (e) { try { xmlhttp = new XMLHttpRequest(); }
  catch (e) { xmlhttp = false; }}}
  if (!xmlhttp) return null;

  this.abort = function() { 
    xmlhttp.abort(); 
  }
  
  //this.connect = function(sURL, sVars, fnDone, element)
  this.connect = function(sURL, sMethod, fnDone, element, postVars, onload_fun) {
  
      request_url = sURL; 

      if(postVars == undefined) { postVars = ""; }
      if (!xmlhttp) return false;
      bComplete = false;

      try {
        if(sMethod == 'GET') { 
            sURL += '&randseed='+Math.round(Math.random()*100000);
            //    sMethod = sMethod.toUpperCase();
            //    xmlhttp.open(sMethod, sURL+"?"+sVars, true);
            xmlhttp.open(sMethod, sURL, true);
            sVars = ""; 
        }
        else {
            xmlhttp.open(sMethod, sURL, true);
            xmlhttp.setRequestHeader("Method", "POST "+sURL+" HTTP/1.1");
            xmlhttp.setRequestHeader("Content-Type",
                   "application/x-www-form-urlencoded");
        }
        xmlhttp.onreadystatechange = function() {
          if (xmlhttp.readyState == 4 && !bComplete) {
            bComplete = true;
            if(fnDone) { 
              fnDone(xmlhttp, element, sMethod, onload_fun);
            }
          }
        };
        xmlhttp.send(postVars); 
      }
      catch(z) { 
        alert(z);  
        return false; 
      }
      return true;
  };

  this.get_string = function(sURL, responseFun, sMethod, postVars) {

   result = '';
   if(postVars == undefined) { postVars = ""; }
   if(sMethod == undefined) { sMethod = 'GET'; }
      if (!xmlhttp) return false;
      bComplete = false;

      try {
        if(sMethod == 'GET') { 
            //    sMethod = sMethod.toUpperCase();
            //    xmlhttp.open(sMethod, sURL+"?"+sVars, true);
            xmlhttp.open(sMethod, sURL, true);
            sVars = ""; 
        }
        else {
            xmlhttp.open(sMethod, sURL, true);
            xmlhttp.setRequestHeader("Method", "POST "+sURL+" HTTP/1.1");
            xmlhttp.setRequestHeader("Content-Type",
                   "application/x-www-form-urlencoded");
        }
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 && !bComplete) {
          bComplete = true;
          responseFun(xmlhttp.responseText);
            }
        };
        xmlhttp.send(postVars); 
      }
      catch(z) { 
        alert(z);  
        return false; 
      }
      return result;
  };
  
  return this;
}

/*
// Maps interface names to init functions. Means "Call this function 
// after this interface has been requested"
Cuba.init_functions = { 
    'Wiki::Article.show' : init_article_interface, 
    'Wiki::Container.update' : init_all_editors, 
    'App_Main.login' : init_login_screen
};

// Maps element ids to init functions. Means: "Call this function when 
// updating this element". This Hash is to be filled automatically. 
Cuba.element_init_functions = {}
Cuba.update_targets = {}; 
*/
function update_element(xml_conn, element, do_update_source)
{
  if(element) {
    response = xml_conn.responseText;

    if(response == "\n")
    {
        if(element.id == 'context_menu') {
          context_menu_close(); 
        }
        element.display = 'none';
    } 
    else
    {
        element.innerHTML = response; 

        init_fun = Cuba.element_init_functions[element.id]
        if(init_fun) { init_fun(element); }
    }
  }
  if(do_update_source) {
    for(var target in Cuba.update_targets) {
        url = Cuba.update_targets[target];
        cb__update_element(target, url); 
    }
  }
}
function update_element_and_targets(xml_conn, element, update_targets) // update_targets is ignored here
{
  t = '';
  for(var target in Cuba.update_targets) {
    t += target;
  }
//  alert('update '+t+':'+update_targets);
  update_element(xml_conn, element, true); 
}


function cb__get_remote_string(url, response_fun)
{
    var xml_conn = new XHConn; 
    xml_conn.get_string(url, response_fun);
}

function cb__get_form_values(form_id)
{
    form = document.getElementById(form_id);
    
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
    return string
}

function cb__update_element(element_id, interface_url)
{
    element = document.getElementById(element_id);
    var xml_conn = new XHConn; 

    interface_call = interface_url.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,'$1.$2');
    interface_call = interface_call.replace('/','');

    init_fun = Cuba.init_functions[interface_call];
    if(init_fun) { Cuba.element_init_functions[element.id] = init_fun; }

    xml_conn.connect(interface_url+'&mode=async&randseed='+Math.round(Math.random()*100000), 'GET', update_element, element); 
}

function cb__remote_submit(form_id, target_id, targets)
{
    context_menu_autoclose = true; 
    target_url     = '/aurita/dispatch'; 
    postVars       = Cuba.get_form_values(form_id);
    postVarsHash   = Cuba.get_form_values_hash(form_id);
    postVars += 'mode=async'; 
    Cuba.update_targets = targets

    interface_call = postVarsHash['controller']+'.'+postVarsHash['action']
    interface_call = interface_call.replace('/','');

    init_fun = Cuba.init_functions[interface_call];
    if(init_fun) { Cuba.element_init_functions[element.id] = init_fun; }

    var xml_conn = new XHConn; 
    element = document.getElementById(target_id); 

    //    xml_conn.connect(target_url, 'POST', update_element_and_targets, element, postVars); 
    xml_conn.connect(target_url, 'POST', update_element, element, postVars); 
}

function cb__async_call(target_id, interface_url, on_complete_fun)
{
    var xml_conn = new XHConn; 
    interface_url += '&mode=async'; 
    element = document.getElementById(target_id); 
    element.innerHTML = '<img src="/aurita/images/icons/loading.gif" />'; 
    if(on_complete_fun == undefined) { on_complete_fun = update_element; }
    xml_conn.connect(interface_url, 'GET', on_complete_fun, element);
}

function cb__dispatch_interface(target_id, interface_url, update_fun)
{
//  new Effect.Appear(document.getElementById(target_id), {from:0.0, to:0.9, duration:0.5});
    var xml_conn = new XHConn; 
    interface_url += '&mode=async'; 
    element = document.getElementById(target_id); 
    element.innerHTML = '<img src="/aurita/images/icons/loading.gif" />'; 

    interface_call = interface_url.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,'$1.$2');
    interface_call = interface_call.replace('/','');
    
    init_fun = Cuba.init_functions[interface_call];
    if(init_fun) { Cuba.element_init_functions[element.id] = init_fun; }
    
    if(update_fun == undefined && interface_url.match('Wiki::Article/show')) { update_fun = init_article; }
    if(update_fun == undefined) { update_fun = update_element; }
    xml_conn.connect(interface_url, 'GET', update_fun, element); 
}

function cb__load_interface(target_id, interface_url, targets)
{
    var xml_conn = new XHConn; 
    interface_url += '&mode=async&randseed='+Math.round(Math.random()*100000); 
    element = document.getElementById(target_id); 
    element.innerHTML  = '<img src="/aurita/images/icons/loading.gif" />'; 
    Cuba.update_targets = targets; 
    if(interface_url.match('Wiki::Article/show')) { update_fun = init_article; }
    else { update_fun  = update_element; }
    xml_conn.connect(interface_url, 'GET', update_fun, element); 
}
function cb__load_interface_silently(target_id, interface_url)
{
    var xml_conn = new XHConn; 
    interface_url += '&mode=async&randseed='+Math.round(Math.random()*100000); 
    element = document.getElementById(target_id); 
    xml_conn.connect(interface_url, 'GET', update_element, element); 
}

// Only function allowed to close the 
// currently opened context menu. 
// Also responsible for cleanup-procedure. 
function cb__cancel_dispatch()
{
    context_menu_close();
    return; 
//    dispatcher_hide(); 
//    setTimeout('cb__unfade()',1000); 
    if(context_menu_opened) {
	context_menu_opened = false; 
	document.getElementById('context_menu').style.display = 'none'; 
	unfocus_element(context_menu_active_element_id); 
    } 
    else {
	new Effect.Fade('dispatcher', {duration: 0.5});
    }
}

/* ==============================================
   === END FILE: public/inc/remote_call.js 
   ==============================================*/
/* ==============================================
   === FILE: public/inc/cuba_async.js 
   ==============================================*/

var Cuba = { 

    compare_arrays: function(a,b) { 
      return (a.join('-') == b.join('-')); 
    }, 

    random: function(length) {
      if(!length) length = 4; 
      return Math.round(Math.random() * Math.exp(10,length)); 
    }, 

    loading_symbol: '<img src="/aurita/images/icons/loading.gif" border="0" />', 

    notify_invalid_params : function(klass, method, message) 
    { 
      method = method.replace('perform_',''); 
      klass = klass.replace('Aurita::Main::','').replace('_Controller',''); 
      form_buttons = klass.toLowerCase() + '_' + method + '_form_buttons'; 
      if($(form_buttons)) Element.show(form_buttons); 
      Cuba.alert(message); 
    }, 

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
    //  'Wiki::Article.perform_add': { 'app_main_content': 'Wiki::Article.show_own_latest' }, 
        'Role_Permissions.perform_add': { 'app_main_content': 'Role.list' }, 
        'Form_Builder.perform_add': { 'app_main_content': 'Form_Builder.form_added' }, 
        'User_Profile.perform_update': { 'app_main_content': 'User_Profile.show_own' }, 
        'Messaging::User_Message.perform_add' : { 'messaging_content' : 'Messaging::User_Message.message_sent'}
    }, 

    after_submit_targets: function(form_id) { 
     // form_values = Cuba.get_form_values_hash(form_id); 
        form_values = Form.serialize(form_id, true); 
        log_debug(form_values['controller']+'.'+form_values['action']); 
        targets = Cuba.after_submit_target_map[form_values['controller']+'.'+form_values['action']];
        return targets; 
    }, 
    
    update_targets: {}, 
    init_functions: {
      'Wiki::Article.show': init_article_interface, 
      'App_Main.login': init_login_screen, 
      'User_Profile.register_user': init_login_screen
    }, 
    element_init_functions: {}, 

    load_element_content: function(element_id, interface_url)
    {
        element = Cuba.element(element_id); 
        var xml_conn = new XHConn; 
        
        interface_call = interface_url.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,'$1.$2');
        interface_call = interface_call.replace('/','');

        init_fun = Cuba.init_functions[interface_call];

        if(init_fun && element) { Cuba.element_init_functions[element.id] = init_fun; }
        
//      xml_conn.connect(interface_url+'&mode=async&randseed='+Math.round(Math.random()*100000), 'GET', Cuba.update_element_only, element); 
        xml_conn.connect(interface_url+'&mode=async', 'GET', Cuba.update_element_only, element, true); 
    },

    after_update_element: function(element) 
    {
      Cuba.collapse_boxes(); 
      init_all_editors(); 
    }, 

    on_successful_submit: function() { 
      context_menu_close(); 
    }, 

    update_element: function(xml_conn, element, do_update_source)
    {
        try { Element.setOpacity(element, 1.0); } catch(e) { }
        log_debug('update element ' + element); 
        response = xml_conn.responseText;
        response_html = response; 
        response_script = false; 
        response_error = false; 
        // See Cuba::Controller.render_view
        if(response.substr(0, 6) == '{ html')
        { 
          json_response   = eval('(' + response + ')'); 
          response_html   = json_response.html.replace('\"','"'); 
          response_script = json_response.script.replace('\"','"'); 
          response_error  = json_response.error; 
          if(response_error) { 
            response_error  = json_response.error.replace('\"','"'); 
          }
        } 
        else if(response.substr(0,8) == '{ script' ) 
        {
          json_response = eval('(' + response + ')'); 
          response_html = ''
          response_error = false; 
          response_script = json_response.script.replace('\"','"'); 
        } 
        else if(response.substr(0,7) == '{ error' ) 
        {
          json_response = eval('(' + response + ')'); 
          response = ''
          response_html = false; 
          response_script = false; 
          Cuba.update_targets = { }; // Break dispatch chain on error, 
                                     // prohibit further actions in interface
          response_error = json_response.error.replace('\"','"'); 
        } 
        else if(response.replace(/\s/g,'') == '') { 
          Cuba.on_successful_submit(); 
        }
        else { 
          response_error = false; 
          response_script = false; 
          response_html = response; // Plain response, no json 
        }

        if(element) 
        {
        // When to close context menu (no error and no html response, or target element
        // is not context menu)
          if(!response_error && (!element || !response_html))
       // if(!response_error && (!element || element && element.id != 'context_menu' || !response_html))
          {
            // This might be a hack: 
            // We currenltly are setting (brute force) element_id to 'dispatcher' in 
            // Cuba.remote_submit (because there, it's the only sensible target element). 
            // Then, however, target 'context_menu' is overridden, so it wouldn't be closed 
            // here. 
            context_menu_close(); 
          } 
          if(response_error) // aurita wants to tell us something
          {
            eval(response_error); 
          }
          element.innerHTML = response_html; 
        }
        if(response_script) { eval(response_script); }

        if(Cuba.update_targets) {
          for(var target in Cuba.update_targets) {
            if(Cuba.update_targets[target]) { 
              url = Cuba.update_targets[target].replace('.','/');
              url += '&randseed='+Math.round(Math.random()*100000);
              Cuba.load({ element: target, action: url }); 
            }
          }
          // Reset targets so they will be set in next load/remote_submit call: 
          Cuba.update_targets = null; 
        }
        Cuba.after_update_element(element); 
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
        if(init_fun && element) { init_fun(element); }
      }
    },

    call: function(interface_url)
    {
      var xml_conn = new XHConn; 
      interface_url += '&mode=async'; 
      xml_conn.connect('/aurita/'+interface_url, 'GET', null, null); 
    },

    current_interface_calls: {}, 
    completed_interface_calls: {}, 
    dispatch_interface: function(params)
    {
      target_id     = params['target']; 
      interface_url = '/aurita/' + params['interface_url']; 
      interface_url.replace('/aurita//aurita/','/aurita/'); 

      try { save_all_editors(); } catch(e) { } 
      
      if(Cuba.current_interface_calls[interface_url]) { log_debug("Duplicate interface call?"); }
      Cuba.current_interface_calls[interface_url] = true; 
      
      log_debug("Dispatch interface "+interface_url);

      update_fun    = params['on_update']; 
      
      Cuba.update_targets = params['targets']; 
      var xml_conn = new XHConn; 
      interface_url += '&mode=async'; 
      element = Cuba.element(target_id); 
      if(!params['silently']) { 
//        element.innerHTML = Cuba.loading_symbol; 
        Element.setOpacity(element, 0.5); 
      }
      interface_call = interface_url.replace(/aurita\/([^\/]+)\/([^/]+)[\/&](.+)?/,'$1.$2').replace('/','');
      model    = interface_call.split('.')[0]; 
      method   = interface_call.split('.')[1]; 
      postVars = 'controller=' + model; 
      postVars += '&action=' + method; 
      postVars += '&';
      postVars += interface_url.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,'$3').replace('/',''); 
      interface_url = '/aurita/dispatch'; 

      interface_call = interface_call.replace('/','');
      update_fun = Cuba.update_element; 
      xml_conn.connect(interface_url, 'POST', update_fun, element, postVars); 
    },

    remote_submit: function(form_id, target_id, targets)
    {

      context_menu_autoclose = true; 
      target_url     = '/aurita/dispatch'; 
      postVars       = Form.serialize(form_id);

      // postVars = Cuba.get_form_values(form_id); 
      postVars += '&mode=async&x=1'; 
      // postVarsHash   = Cuba.get_form_values_hash(form_id); 
      postVarsHash   = Form.serialize(form_id, true); 
      if(targets && !Cuba.update_targets) { 
          Cuba.update_targets = targets; 
      }
      else { 
        // update targets
          for(t in targets) { 
            Cuba.update_targets[t] = targets[t]; 
          }
      }
      
      interface_call = postVarsHash['controller']+'.'+postVarsHash['action']; 
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
      try { 
        if(!params['element']) { 
          Cuba.set_hashcode(params['action']);
          return false; 
        }

        if(!params['element']) { params['element'] = 'app_main_content'; }
        if(!$(params['element'])) { 
          log_debug('Target for Cuba.load does not exist: '+params['target']+', ignoring call'); 
          return false; 
        }
        params['interface_url'] = params['action']; 
        params['target']        = params['element']; 
        params['targets']       = params['redirect_after']; 
        params['on_update']     = params['on_update']; 
        if(params['nocache']) { 
          params['interface_url'] += '&rand=' + Cuba.random(); 
        }
        Cuba.dispatch_interface(params); 
        return false; 
      } catch(e) { 
        return false; 
      } 
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

} // Namespace Cuba


Cuba.force_load = false; 

Cuba.append_autocomplete_value = function(field_id, value) { 
  field = $(field_id); 
  fullvalue = field.value.replace(',', ' ').replace(/\s+/, ' '); 
  values = fullvalue.split(' '); 
  values.pop(); 
  values.push(value); 
  field.value = values.join(' '); 
  field.focus(); 
}

Cuba.set_ie_history_fix_iframe_src = function(url) 
{ 
  return; // IE REACT
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

/* ==============================================
   === END FILE: public/inc/cuba_async.js 
   ==============================================*/
/* ==============================================
   === FILE: public/inc/feedback.js 
   ==============================================*/

Cuba.toggle_user_functions = function(result) 
{ 
  log_debug('toggling user functions'); 
  result = result.replace(' ','').replace("\n",''); 
  if(result.match('1') || result.match('2')) { 
    Element.show('button_App_Profile'); 
  } 
  if(result.match('2')) { 
    Element.show('button_App_Expert'); 
  }
  if(result.match('0') || result == '') { 
    Element.hide('button_App_Profile'); 
    Element.hide('button_App_Expert'); 
  }
}

Cuba.toggle_mail_notifier = function(result) 
{ 
  result = result.replace(' ','').replace("\n",''); 
  var new_mail = (result.lastIndexOf("0") == -1 && result != ''); 
  log_debug('new mail: '+ result+' -> '+new_mail); 
  if (new_mail) { 
    Element.setStyle('new_mail_notifier', { display: '' });
    $('unread_mail_amount').innerHTML = '(' + result + ')'; 
  } 
  else { 
    Element.setStyle('new_mail_notifier', { display: 'none' });
  }
}


/* ==============================================
   === END FILE: public/inc/feedback.js 
   ==============================================*/
/* ==============================================
   === FILE: public/inc/iframe.js 
   ==============================================*/

var IFrameObj; // our IFrame object
Cuba.ie_fix_history_frame = function() 
{
  return true // IE REACT
  iframe_id = 'ie_fix_history_iframe';

  if (!document.createElement) {return true};
  var IFrameDoc;
  if (!IFrameObj && document.createElement) {
    // create the IFrame and assign a reference to the
    // object to our global variable IFrameObj.
    // this will only happen the first time 
    // callToServer() is called
   try {
      var tempIFrame=document.createElement('iframe');
      tempIFrame.setAttribute('id',iframe_id);
      tempIFrame.style.border='0px';
      tempIFrame.style.width='0px';
      tempIFrame.style.height='0px';
      IFrameObj = document.body.appendChild(tempIFrame);
      
      if (document.frames) {
        // this is for IE5 Mac, because it will only
        // allow access to the document object
        // of the IFrame if we access it through
        // the document.frames array
        IFrameObj = document.frames[iframe_id];
      }
    } catch(exception) {
      // This is for IE5 PC, which does not allow dynamic creation
      // and manipulation of an iframe object. Instead, we'll fake
      // it up by creating our own objects.
      iframeHTML='\<iframe id="'+iframe_id+'" style="';
      iframeHTML+='border:0px;';
      iframeHTML+='width:0px;';
      iframeHTML+='height:0px;';
      iframeHTML+='"><\/iframe>';
      document.body.innerHTML+=iframeHTML;
      IFrameObj = new Object();
      IFrameObj.document = new Object();
      IFrameObj.document.location = new Object();
      IFrameObj.document.location.iframe = document.getElementById(iframe_id);
      IFrameObj.document.location.replace = function(location) {
        this.iframe.src = location;
      }
    }
  }
  
  if (navigator.userAgent.indexOf('Gecko') !=-1 && !IFrameObj.contentDocument) {
    // we have to give NS6 a fraction of a second
    // to recognize the new IFrame
    setTimeout('callToServer()',10);
    return false;
  }
  
  // For access to JS functions in IFrame: 
/*
  if (IFrameObj.contentDocument) {
    // For NS6
    IFrameDoc = IFrameObj.contentDocument; 
  } else if (IFrameObj.contentWindow) {
    // For IE5.5 and IE6
    IFrameDoc = IFrameObj.contentWindow.document;
  } else if (IFrameObj.document) {
    // For IE5
    IFrameDoc = IFrameObj.document;
  } else {
    return true;
  }
  return IFrameDoc;
*/
  return IFrameObj;
}
/* ==============================================
   === END FILE: public/inc/iframe.js 
   ==============================================*/
/* ==============================================
   === FILE: public/inc/asset_management.js 
   ==============================================*/

  
function show_image(text, li)
{
    media_asset_id = text.id; 
    cb__load_interface('media_folder_content', '/aurita/Wiki::Media_Asset/show/media_asset_id='+media_asset_id);
};

var drop_target_folder; 
function activate_target(draggable, droppable, overlap_perc)
{
    drop_target_folder = droppable; 
};
function drop_image_in_folder(element)
{
    element.style.display = 'none'; 
    if (element.id.search('image') != -1)
    {
    	cb__load_interface_silently('','/aurita/Wiki::Media_Asset/move_to_folder/media_folder_id='+drop_target_folder.id+'&media_asset_id='+element.id);
   	}
   	else if(element.id.search('folder') != -1)
   	{
    	cb__load_interface_silently('','/aurita/Wiki::Media_Asset_Folder/move_to_folder/media_folder_id='+drop_target_folder.id+'&media_folder_asset_id='+element.id);
   	}
};

Cuba.media_asset_draggables = {}; 
Cuba.create_media_asset_draggable = function(element_id, options) { 
  if(Cuba.media_asset_draggables[element_id] == undefined) {
    Cuba.media_asset_draggables[element_id] = new Draggable(element_id, options);
  }
};

Cuba.destroy_draggables = function() {
  for(var x in Cuba.media_asset_draggables) { 
    Cuba.media_asset_draggables[x].destroy(); 
  }
  Cuba.media_asset_draggables = {}; 
};

Cuba.droppables = {};

Cuba.remove_droppables = function() {
  for(var x in Cuba.droppables) {
      Droppables.remove(document.getElementById('folder_'+Cuba.droppables[x]));
  }
	Cuba.droppables = {};
}

Cuba.shutdown_media_management = function() {
  Cuba.remove_droppables(); 
  Cuba.destroy_draggables(); 
  cb__hide_fullscreen_cover(); 
  Cuba.expanded_folder_ids = {}; 
}

Cuba.expanded_folder_ids = {}
Cuba.load_media_asset_folder_level = function(parent_folder_id, indent) {
//  if(Cuba.expanded_folder_ids[parent_folder_id]) {
  if($('folder_expand_icon_'+parent_folder_id).src.match('folder_collapse.gif')) { 
    log_debug('foo'); 
    $('folder_expand_icon_'+parent_folder_id).src = '/aurita/images/icons/folder_expand.gif'; 
    Cuba.expanded_folder_ids[parent_folder_id] = false; 
    Element.hide('folder_children_'+parent_folder_id); 
    return;
  }
  else { 
    log_debug('bar'); 
    Element.show('folder_children_'+parent_folder_id); 
    Cuba.expanded_folder_ids[parent_folder_id] = true; 
    $('folder_expand_icon_'+parent_folder_id).src = '/aurita/images/icons/folder_collapse.gif'; 
    if($('folder_children_'+parent_folder_id).innerHTML.length < 10) { 
      Cuba.load({ element: 'folder_children_'+parent_folder_id, action: 'Wiki::Media_Asset_Folder/tree_box_level/media_folder_id='+parent_folder_id+'&indent='+indent, on_update: init_media_interface}); 
    }
  }
}

Cuba.select_media_asset = function(params) {
    var hidden_field_id = params['hidden_field']; 
    var user_id = params['user_id']; 
    var hidden_field = $(hidden_field_id); 
    var select_box_id = 'select_box_'+hidden_field_id;
    select_box = $(select_box_id); 
    Cuba.load({ element: select_box_id, 
                action: 'Wiki::Media_Asset/choose_from_user_folders/user_group_id='+user_id+'&image_dom_id='+hidden_field_id }); 
    Element.setStyle(select_box, { display: 'block' });
    Element.setStyle(select_box, { width: '100%' });
}; 

Cuba.select_media_asset_click = function(media_asset_id, element_id) { 
    var hidden_field = $(element_id);
    var image = $('picture_asset_'+element_id); 

//  select_box = $('select_box_'+element_id); 
//  Element.setStyle(select_box, { display: 'none' }); 

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
}; 

Cuba.reset_image = function() { 
  
}

Cuba.hide_image = function() { 
	image = $('image_preview');
	url = image.style.backgroundImage
	url = url.replace(/url\(([^\)]+)\)/,'$1');
	image.style.backgroundImage = ""; 
	image.style.backgroundImage = 'url(#' + url + '?' + Math.round(Math.random()*1000) + ')'; 
};

Cuba.folder_hierarchy = new Array();
Cuba.folder_hierarchy.push(0);

Cuba.add_folder_to_hierarchy = function(value) {
  
}; 

Cuba.open_folder = 0;

Cuba.change_folder_icon = function(value) { 
	folder_to_open = $("folder_icon_" + value);
  folder_to_close = $("folder_icon_" + Cuba.open_folder);
  if(folder_to_close) { 
	  folder_to_close.src = "/aurita/images/icons/folder_closed.gif"; 
  }
	folder_to_open.src = "/aurita/images/icons/folder_opened.gif"; 
  Cuba.open_folder = value;
};

Cuba.reload_background_image = function(element) {
	image = $('image_preview');
	url = image.style.backgroundImage
	url = url.replace(/url\(([^\)]+)\)/,'$1').replace('#',''); 
	image.style.backgroundImage = ""; 
	image.style.backgroundImage = 'url(' + url + '?' + Math.round(Math.random()*1000) + ')'; 
  if(Cuba.image_rotated) { 
    Cuba.calculate_aspect_ratio(); 
  }
};


Cuba.increment_rotation_counter = function() {
	Cuba.rotation_counter += 1;
};

Cuba.check_if_internet_explorer = function() {
  var nAgt = navigator.userAgent;
  if ((verOffset = nAgt.indexOf("MSIE")) != -1) {
    return 1;
  }
  else {
    return 0;
  }
};

Cuba.calculate_aspect_ratio = function() {
	image = $('image_preview');
  url = Element.getStyle('image_preview', 'height');
	url = url.replace(/url\(([^\)]+)\)/,'$1');
  Element.setStyle('image_preview', {'src': url});
	height = Element.getHeight('image_preview'); 
	width = Element.getWidth('image_preview');
	ratio = height / width;
	height = parseInt(width / ratio); 
	if(Cuba.check_if_internet_explorer() == 1) {
    Element.setStyle('crop_line_bottom', { 'top': height-8 } ); 
	}
  else {
    Element.setStyle('crop_line_bottom', { 'top': height-6 } ); 
  }
  Element.setStyle('crop_line_left',   { 'height': height+4 } ); 
  Element.setStyle('crop_line_right',  { 'height': height+4 } ); 
	Element.setStyle(image, { 'height': height } );
  Cuba.image_rotated = false; 
};

Cuba.rotation_counter = 0;
Cuba.ignore_manipulation = false; 
Cuba.image_brightness    = 1.0; 
Cuba.image_hue           = 1.0; 
Cuba.image_saturation    = 1.0; 
Cuba.image_contrast	     = 100; 
Cuba.image_mirror_h      = false; 
Cuba.image_mirror_v      = false; 
Cuba.image_rotation      = 0; 
Cuba.image_rotated       = false; 

Cuba.image_manipulate_brightness = function(value) { 
	Cuba.image_brightness = parseInt(value*100)/100; 
	Cuba.manipulate_image();
};
Cuba.image_manipulate_hue = function(value) { 
	Cuba.image_hue = parseInt(value*100)/100; 
	Cuba.manipulate_image(); 
};
Cuba.image_manipulate_saturation = function(value) { 
	Cuba.image_saturation = parseInt(value*100)/100; 
	Cuba.manipulate_image(); 
};
Cuba.image_manipulate_contrast = function(value) { 
	Cuba.image_contrast = parseInt(value*100)/100; 
	Cuba.manipulate_image(); 
};
Cuba.rotate_left = function() { 
  Cuba.image_rotation -= 90; 
  Cuba.rotation_counter--; 
	Cuba.manipulate_image(); 
  Cuba.image_rotated = true; 
}; 
Cuba.rotate_right = function() { 
  Cuba.image_rotation += 90; 
  Cuba.rotation_counter++; 
	Cuba.manipulate_image(); 
  Cuba.image_rotated = true; 
}; 
Cuba.mirror_horizontal = function() { 
  Cuba.image_mirror_h = !Cuba.image_mirror_h; 
	Cuba.manipulate_image(); 
}; 
Cuba.mirror_vertical = function() { 
  Cuba.image_mirror_v = !Cuba.image_mirror_v; 
	Cuba.manipulate_image(); 
}; 

Cuba.manipulate_image = function(slider_value) // Ignore param
{
   if(!Cuba.ignore_manipulation) { 
     Cuba.hide_image(); 
     action = 'Wiki::Image_Editor/manipulate/media_asset_id='+ Cuba.active_media_asset_id;
     action += '&brightness='+Cuba.image_brightness;
     action += '&hue='+Cuba.image_hue;
     action += '&saturation='+Cuba.image_saturation; 
     action += '&contrast='+Cuba.image_contrast;
     action += '&rotation='+Cuba.image_rotation;
     action += '&mirror_h='+Cuba.image_mirror_h;
     action += '&mirror_v='+Cuba.image_mirror_v;
     Cuba.load({ action: action, 
                 element: 'dispatcher', 
                 on_update: Cuba.reload_background_image });
   }
}; 

Cuba.save_image = function() { 
  Cuba.resolve_slider_positions(); 
     Cuba.hide_image(); 
     action = 'Wiki::Image_Editor/save/media_asset_id='+ Cuba.active_media_asset_id;
     action += '&brightness='+Cuba.image_brightness;
     action += '&hue='+Cuba.image_hue;
     action += '&saturation='+Cuba.image_saturation; 
     action += '&contrast='+Cuba.image_contrast;
     action += '&rotation='+Cuba.image_rotation;
     action += '&mirror_h='+Cuba.image_mirror_h;
     action += '&mirror_v='+Cuba.image_mirror_v;
     action += '&crop_top='+Cuba.slider_positions.top; 
     action += '&crop_bottom='+Cuba.slider_positions.bottom; 
     action += '&crop_right='+Cuba.slider_positions.right; 
     action += '&crop_left='+Cuba.slider_positions.left; 
     action += '&height='+Cuba.slider_positions.height; 
     Cuba.load({ action: action, 
                 element: 'dispatcher', 
                 on_update: function() { alert('Bild wurde gespeichert'); } });
}; 

Cuba.init_image_manipulation_sliders = function() {
	Cuba.image_brightness_slider = new Control.Slider('brightness_handle', 'brightness_track', {
	    onChange: Cuba.image_manipulate_brightness, 
		range: $R(0,2), 
		sliderValue: 1 }); 
	Cuba.image_hue_slider = new Control.Slider('hue_handle', 'hue_track', {
	    onChange: Cuba.image_manipulate_hue, 
		range: $R(0,2), 
		sliderValue: 1 });
	Cuba.image_saturation_slider = new Control.Slider('saturation_handle', 'saturation_track', {
	    onChange: Cuba.image_manipulate_saturation, 
		range: $R(0,2), 
		sliderValue: 1 });	
	Cuba.image_contrast_slider = new Control.Slider('contrast_handle', 'contrast_track', {
	    onChange: Cuba.image_manipulate_contrast, 
		range: $R(1,200), 
		sliderValue: 100 });
};

Cuba.reset_image = function() { 
  Cuba.hide_image(); 
  Cuba.ignore_manipulation = true; 
	Cuba.image_brightness_slider.setValue(1);
	Cuba.image_hue_slider.setValue(1);
	Cuba.image_saturation_slider.setValue(1);
	Cuba.image_contrast_slider.setValue(100);
  Cuba.image_mirror_h      = false; 
  Cuba.image_mirror_v      = false; 
  Cuba.image_rotation      = 0; 
	if(Cuba.rotation_counter % 2 == 1)
	{
		Cuba.calculate_aspect_ratio();
	}
  action = 'Wiki::Image_Editor/reset/media_asset_id='+ Cuba.active_media_asset_id;
  Cuba.load({ action: action, 
              element: 'dispatcher', 
              on_update: Cuba.reload_background_image });
	Cuba.rotation_counter = 0;
	Cuba.reload_background_image();
	Cuba.ignore_manipulation = false; 
};

Cuba.init_crop_lines = function() {
    
    new Draggable('crop_line_left', { revert: false, constraint: 'horizontal', containment: 'image_preview' }); 
    new Draggable('crop_line_right', { revert: false, constraint: 'horizontal', containment: 'image_preview' }); 
    new Draggable('crop_line_top', { revert: false, constraint: 'vertical', containment: 'image_preview' }); 
    new Draggable('crop_line_bottom', { revert: false, constraint: 'vertical', containment: 'image_preview' }); 
};

Cuba.resolve_slider_positions = function() {
	image = $('image_preview');
	url = image.style.backgroundImage
	url = url.replace(/url\(([^\)]+)\)/,'$1');
	image_file = new Image(); 
	image_file.src = url; 
	image_height = image_file.height; 

	position_top = parseInt($('crop_line_top').style.top) + 405;
	position_bottom = parseInt($('crop_line_bottom').style.top) - image_height + 6;
	position_left = parseInt($('crop_line_left').style.left) + 305;
	position_right = parseInt($('crop_line_right').style.left) - 299;
	Cuba.slider_positions = {top: position_top, bottom: position_bottom, left: position_left, right: position_right, height: image_height };
}

Cuba.init_image_manipulation = function() { 
	Cuba.init_image_manipulation_sliders();
	Cuba.init_crop_lines(); 
}; 

/* ==============================================
   === END FILE: public/inc/asset_management.js 
   ==============================================*/
/* ==============================================
   === FILE: public/inc/login.js 
   ==============================================*/

var Login = { 

  check_success: function(success)
  {
    var failed = true; 

    if(success != "\n0\n") 
    { 
      user_params = eval(success); 
      if(user_params.session_id) {
        setCookie('cb_login', user_params.session_id, 0, '/'); 
        failed = false; 
      }
    }
    if(failed) 
    {
      new Effect.Shake('login_box'); 
    }
    else { 
      new Effect.Fade('login_box', {queue: 'front', duration: 1}); 
//    new Effect.Appear('start_button', {queue: 'end', duration: 1}); 
      document.location.href = '/aurita/App_Main/start/';
    }
  },

  remote_login: function(login, pass)
  {
    login = MD5(login); 
    pass  = MD5(pass); 
    cb__get_remote_string('/aurita/App_Main/validate_user/mode=async&login='+login+'&pass='+pass, Login.check_success); 
  }

} // Namespace Login

/* ==============================================
   === END FILE: public/inc/login.js 
   ==============================================*/
/* ==============================================
   === FILE: public/inc/backbutton.js 
   ==============================================*/


Cuba.append_autocomplete_value = function(field_id, value) { 
  field = $(field_id); 
  fullvalue = field.value.replace(',', ' ').replace(/\s+/, ' '); 
  values = fullvalue.split(' '); 
  values.pop(); 
  values.push(value); 
  field.value = values.join(' '); 
  field.focus(); 
}

Cuba.get_ie_history_fix_iframe_code = function() 
{
  try { 
    // Requesting the src attribute is faster, as iframe does not have to be loaded, 
    // but this method is prohibited in most cases: 
    hashcode = parent.ie_fix_history_frame.location.href; 
    hashcode = hashcode.replace(/(.+)?get_code.fcgi\?code=(.+)/g,"$2"); 
  } catch(e) { 
    hashcode = parent.ie_fix_history_frame.get_code(); 
  }
  return hashcode; 
}

Cuba.collapse_boxes = function() 
{
   collapsed_boxes = getCookie('collapsed_boxes'); 
   if(collapsed_boxes) {
     collapsed_boxes = collapsed_boxes.split('-'); 
     for(b=0; b<collapsed_boxes.length; b++) { 
       box_id = collapsed_boxes[b]; 
       if($(box_id)) { 
         Cuba.close_box(box_id); 
       }
     }
   }
}

Cuba.last_hashvalue = ''; 
var home_loaded = false; 
wait_for_iframe_sync = '0'; 
Cuba.check_hashvalue = function() 
{
    current_hashvalue = document.location.hash.replace('#',''); 

    if(current_hashvalue.match(/(.+)?_anchor/)) { return;  } 

    if(false && Cuba.check_if_internet_explorer() == 1) { // IE REACT
      iframe_hashvalue = Cuba.get_ie_history_fix_iframe_code(); 
      if(iframe_hashvalue != 'no_code' && iframe_hashvalue != current_hashvalue && !Cuba.force_load && iframe_hashvalue != '' && !iframe_hashvalue.match('about:')) { 
        current_hashvalue = iframe_hashvalue; 
      }
      if(document.location.hash != '#'+current_hashvalue) { document.location.hash = current_hashvalue; }
    }

    if(Cuba.force_load || current_hashvalue != Cuba.last_hashvalue && current_hashvalue != '') 
    { 
      window.scrollTo(0,0);
      save_all_editors(); 

      Cuba.force_load = false; 
      log_debug("loading interface for "+current_hashvalue); 
      flush_editor_register(); 
      Cuba.last_hashvalue = current_hashvalue;

      if(current_hashvalue.match('article--')) { 
          aid = current_hashvalue.replace('article--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Wiki::Article/show/article_id='+aid+'&with_editor=1' }); 
      }
      else if(current_hashvalue.match('category--')) { 
          cid = current_hashvalue.replace('category--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Category/show/category_id='+cid }); 
      }
      else if(current_hashvalue.match('user--')) { 
          uid = current_hashvalue.replace('user--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'User_Profile/show_by_username/user_group_name='+uid }); 
      }
      else if(current_hashvalue.match('media--')) { 
          maid = current_hashvalue.replace('media--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Wiki::Media_Asset/show/media_asset_id='+maid }); 
      }
      else if(current_hashvalue.match('folder--')) { 
          mafid = current_hashvalue.replace('folder--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Galery::App_Galery/show/media_folder_id='+mafid }); 
      }
      else if(current_hashvalue.match('playlist--')) { 
          pid = current_hashvalue.replace('playlist--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Video::Playlist_Entry/show/playlist_id='+pid }); 
      }
      else if(current_hashvalue.match('video--')) { 
          vid = current_hashvalue.replace('video--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'App_Main/play_youtube_video/playlist_entry_id='+vid }); 
      }
      else if(current_hashvalue.match('find_all--')) { 
          pattern = current_hashvalue.replace('find_all--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'App_Main/find_all/key='+pattern }); 
      }
      else if(current_hashvalue.match('find--')) { 
          pattern = current_hashvalue.replace('find--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'App_Main/find_all/key='+pattern }); 
      }
      else if(current_hashvalue.match('find_full--')) { 
          pattern = current_hashvalue.replace('find_full--','').replace(/ /g,''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'App_Main/find_full/key='+pattern }); 
      }
      else if(current_hashvalue.match('topic--')) { 
          tid = current_hashvalue.replace('topic--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Forum::Forum_Topic/show/forum_topic_id='+tid }); 
      }
      else if(current_hashvalue.match('group--')) { 
          tid = current_hashvalue.replace('group--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Forum::Forum_Group/show/forum_group_id='+tid }); 
      }
      else if(current_hashvalue.match('app--')) { 
          action = current_hashvalue.replace('app--','').replace('+','').replace(/ /g,''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'App_Main/'+action+'/' }); 
      }
      else if(current_hashvalue.match('calendar--')) { 
          action = current_hashvalue.replace('calendar--','').replace('+','').replace(/ /g,''); 
          if(action.substr(0,5) == 'day--') { 
            action = 'day/date=' + action.replace('day--','');
          }
          Cuba.load({ element: 'app_main_content', 
                      action: 'Calendar::Calendar/'+action }); 
      }
      else {
        action = current_hashvalue.replace(/--/g,'/').replace(/-/,'=');
          // split hash into controller--action--param1--value1--param2--value2...
          Cuba.load({ element: 'app_main_content', 
                      action: action }); 
      }

    } 
}; 
window.setInterval(Cuba.check_hashvalue, 1000); 

function PageLocator(propertyToUse, dividingCharacter) {
    this.propertyToUse = propertyToUse;
    this.defaultQS = 1;
    this.dividingCharacter = dividingCharacter;
}
PageLocator.prototype.getLocation = function() {
    return eval(this.propertyToUse);
}
PageLocator.prototype.getHash = function() {
    var url = this.getLocation();
    if(url.indexOf(this.dividingCharacter) > -1) {
        var url_elements = url.split(this.dividingCharacter);
        return url_elements[url_elements.length-1];
    } else {
        return this.defaultQS;
    }
}
PageLocator.prototype.getHref = function() {
    var url = this.getLocation();
    var url_elements = url.split(this.dividingCharacter);
    return url_elements[0];
}
PageLocator.prototype.makeNewLocation = function(new_qs) {
    return this.getHref() + this.dividingCharacter + new_qs;
}




/* ==============================================
   === END FILE: public/inc/backbutton.js 
   ==============================================*/
/* ==============================================
   === FILE: public/inc/box.js 
   ==============================================*/

Cuba.toggle_box = function(box_id) { 
  Element.toggle(box_id + '_body'); 
  collapsed_boxes = getCookie('collapsed_boxes'); 
  if(collapsed_boxes) { 
    collapsed_boxes = collapsed_boxes.split('-'); 
  } else { 
    collapsed_boxes = []; 
  }
  if($('collapse_icon_'+box_id).src.match('plus.gif')) { 
    $('collapse_icon_'+box_id).src = '/aurita/images/icons/minus.gif'
    box_id_string = ''
    for(b=0; b<collapsed_boxes.length; b++) {
      bid = collapsed_boxes[b]; 
      if(bid != box_id) { 
        box_id_string +=  bid + '-';
      }
    }
    setCookie('collapsed_boxes', box_id_string); 
  } else { 
    collapsed_boxes.push(box_id); 
    setCookie('collapsed_boxes', collapsed_boxes.join('-')); 
    $('collapse_icon_'+box_id).src = '/aurita/images/icons/plus.gif'
  }
}; 
Cuba.close_box = function(box_id) { 
  Element.hide(box_id + '_body'); 
  $('collapse_icon_'+box_id).src = '/aurita/images/icons/plus.gif'
}; 

/* ==============================================
   === END FILE: public/inc/box.js 
   ==============================================*/
/* ==============================================
   === FILE: public/inc/poll.js 
   ==============================================*/

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
  }

}; 

/* ==============================================
   === END FILE: public/inc/poll.js 
   ==============================================*/
/* ==============================================
   === FILE: public/inc/jscalendar/calendar.js 
   ==============================================*/
/*  Copyright Mihai Bazon, 2002-2005  |  www.bazon.net/mishoo
 * -----------------------------------------------------------
 *
 * The DHTML Calendar, version 1.0 "It is happening again"
 *
 * Details and latest version at:
 * www.dynarch.com/projects/calendar
 *
 * This script is developed by Dynarch.com.  Visit us at www.dynarch.com.
 *
 * This script is distributed under the GNU Lesser General Public License.
 * Read the entire license text here: http://www.gnu.org/licenses/lgpl.html
 */

// $Id: calendar.js,v 1.51 2005/03/07 16:44:31 mishoo Exp $

/** The Calendar object constructor. */
Calendar = function (firstDayOfWeek, dateStr, onSelected, onClose) {
	// member variables
	this.activeDiv = null;
	this.currentDateEl = null;
	this.getDateStatus = null;
	this.getDateToolTip = null;
	this.getDateText = null;
	this.timeout = null;
	this.onSelected = onSelected || null;
	this.onClose = onClose || null;
	this.dragging = false;
	this.hidden = false;
	this.minYear = 1970;
	this.maxYear = 2050;
	this.dateFormat = Calendar._TT["DEF_DATE_FORMAT"];
	this.ttDateFormat = Calendar._TT["TT_DATE_FORMAT"];
	this.isPopup = true;
	this.weekNumbers = true;
	this.firstDayOfWeek = typeof firstDayOfWeek == "number" ? firstDayOfWeek : Calendar._FD; // 0 for Sunday, 1 for Monday, etc.
	this.showsOtherMonths = false;
	this.dateStr = dateStr;
	this.ar_days = null;
	this.showsTime = false;
	this.time24 = true;
	this.yearStep = 2;
	this.hiliteToday = true;
	this.multiple = null;
	// HTML elements
	this.table = null;
	this.element = null;
	this.tbody = null;
	this.firstdayname = null;
	// Combo boxes
	this.monthsCombo = null;
	this.yearsCombo = null;
	this.hilitedMonth = null;
	this.activeMonth = null;
	this.hilitedYear = null;
	this.activeYear = null;
	// Information
	this.dateClicked = false;

	// one-time initializations
	if (typeof Calendar._SDN == "undefined") {
		// table of short day names
		if (typeof Calendar._SDN_len == "undefined")
			Calendar._SDN_len = 3;
		var ar = new Array();
		for (var i = 8; i > 0;) {
			ar[--i] = Calendar._DN[i].substr(0, Calendar._SDN_len);
		}
		Calendar._SDN = ar;
		// table of short month names
		if (typeof Calendar._SMN_len == "undefined")
			Calendar._SMN_len = 3;
		ar = new Array();
		for (var i = 12; i > 0;) {
			ar[--i] = Calendar._MN[i].substr(0, Calendar._SMN_len);
		}
		Calendar._SMN = ar;
	}
};

// ** constants

/// "static", needed for event handlers.
Calendar._C = null;

/// detect a special case of "web browser"
Calendar.is_ie = ( /msie/i.test(navigator.userAgent) &&
		   !/opera/i.test(navigator.userAgent) );

Calendar.is_ie5 = ( Calendar.is_ie && /msie 5\.0/i.test(navigator.userAgent) );

/// detect Opera browser
Calendar.is_opera = /opera/i.test(navigator.userAgent);

/// detect KHTML-based browsers
Calendar.is_khtml = /Konqueror|Safari|KHTML/i.test(navigator.userAgent);

// BEGIN: UTILITY FUNCTIONS; beware that these might be moved into a separate
//        library, at some point.

Calendar.getAbsolutePos = function(el) {
	var SL = 0, ST = 0;
	var is_div = /^div$/i.test(el.tagName);
	if (is_div && el.scrollLeft)
		SL = el.scrollLeft;
	if (is_div && el.scrollTop)
		ST = el.scrollTop;
	var r = { x: el.offsetLeft - SL, y: el.offsetTop - ST };
	if (el.offsetParent) {
		var tmp = this.getAbsolutePos(el.offsetParent);
		r.x += tmp.x;
		r.y += tmp.y;
	}
	return r;
};

Calendar.isRelated = function (el, evt) {
	var related = evt.relatedTarget;
	if (!related) {
		var type = evt.type;
		if (type == "mouseover") {
			related = evt.fromElement;
		} else if (type == "mouseout") {
			related = evt.toElement;
		}
	}
	while (related) {
		if (related == el) {
			return true;
		}
		related = related.parentNode;
	}
	return false;
};

Calendar.removeClass = function(el, className) {
	if (!(el && el.className)) {
		return;
	}
	var cls = el.className.split(" ");
	var ar = new Array();
	for (var i = cls.length; i > 0;) {
		if (cls[--i] != className) {
			ar[ar.length] = cls[i];
		}
	}
	el.className = ar.join(" ");
};

Calendar.addClass = function(el, className) {
	Calendar.removeClass(el, className);
	el.className += " " + className;
};

// FIXME: the following 2 functions totally suck, are useless and should be replaced immediately.
Calendar.getElement = function(ev) {
	var f = Calendar.is_ie ? window.event.srcElement : ev.currentTarget;
	while (f.nodeType != 1 || /^div$/i.test(f.tagName))
		f = f.parentNode;
	return f;
};

Calendar.getTargetElement = function(ev) {
	var f = Calendar.is_ie ? window.event.srcElement : ev.target;
	while (f.nodeType != 1)
		f = f.parentNode;
	return f;
};

Calendar.stopEvent = function(ev) {
	ev || (ev = window.event);
	if (Calendar.is_ie) {
		ev.cancelBubble = true;
		ev.returnValue = false;
	} else {
		ev.preventDefault();
		ev.stopPropagation();
	}
	return false;
};

Calendar.addEvent = function(el, evname, func) {
	if (el.attachEvent) { // IE
		el.attachEvent("on" + evname, func);
	} else if (el.addEventListener) { // Gecko / W3C
		el.addEventListener(evname, func, true);
	} else {
		el["on" + evname] = func;
	}
};

Calendar.removeEvent = function(el, evname, func) {
	if (el.detachEvent) { // IE
		el.detachEvent("on" + evname, func);
	} else if (el.removeEventListener) { // Gecko / W3C
		el.removeEventListener(evname, func, true);
	} else {
		el["on" + evname] = null;
	}
};

Calendar.createElement = function(type, parent) {
	var el = null;
	if (document.createElementNS) {
		// use the XHTML namespace; IE won't normally get here unless
		// _they_ "fix" the DOM2 implementation.
		el = document.createElementNS("http://www.w3.org/1999/xhtml", type);
	} else {
		el = document.createElement(type);
	}
	if (typeof parent != "undefined") {
		parent.appendChild(el);
	}
	return el;
};

// END: UTILITY FUNCTIONS

// BEGIN: CALENDAR STATIC FUNCTIONS

/** Internal -- adds a set of events to make some element behave like a button. */
Calendar._add_evs = function(el) {
	with (Calendar) {
		addEvent(el, "mouseover", dayMouseOver);
		addEvent(el, "mousedown", dayMouseDown);
		addEvent(el, "mouseout", dayMouseOut);
		if (is_ie) {
			addEvent(el, "dblclick", dayMouseDblClick);
			el.setAttribute("unselectable", true);
		}
	}
};

Calendar.findMonth = function(el) {
	if (typeof el.month != "undefined") {
		return el;
	} else if (typeof el.parentNode.month != "undefined") {
		return el.parentNode;
	}
	return null;
};

Calendar.findYear = function(el) {
	if (typeof el.year != "undefined") {
		return el;
	} else if (typeof el.parentNode.year != "undefined") {
		return el.parentNode;
	}
	return null;
};

Calendar.showMonthsCombo = function () {
	var cal = Calendar._C;
	if (!cal) {
		return false;
	}
	var cal = cal;
	var cd = cal.activeDiv;
	var mc = cal.monthsCombo;
	if (cal.hilitedMonth) {
		Calendar.removeClass(cal.hilitedMonth, "hilite");
	}
	if (cal.activeMonth) {
		Calendar.removeClass(cal.activeMonth, "active");
	}
	var mon = cal.monthsCombo.getElementsByTagName("div")[cal.date.getMonth()];
	Calendar.addClass(mon, "active");
	cal.activeMonth = mon;
	var s = mc.style;
	s.display = "block";
	if (cd.navtype < 0)
		s.left = cd.offsetLeft + "px";
	else {
		var mcw = mc.offsetWidth;
		if (typeof mcw == "undefined")
			// Konqueror brain-dead techniques
			mcw = 50;
		s.left = (cd.offsetLeft + cd.offsetWidth - mcw) + "px";
	}
	s.top = (cd.offsetTop + cd.offsetHeight) + "px";
};

Calendar.showYearsCombo = function (fwd) {
	var cal = Calendar._C;
	if (!cal) {
		return false;
	}
	var cal = cal;
	var cd = cal.activeDiv;
	var yc = cal.yearsCombo;
	if (cal.hilitedYear) {
		Calendar.removeClass(cal.hilitedYear, "hilite");
	}
	if (cal.activeYear) {
		Calendar.removeClass(cal.activeYear, "active");
	}
	cal.activeYear = null;
	var Y = cal.date.getFullYear() + (fwd ? 1 : -1);
	var yr = yc.firstChild;
	var show = false;
	for (var i = 12; i > 0; --i) {
		if (Y >= cal.minYear && Y <= cal.maxYear) {
			yr.innerHTML = Y;
			yr.year = Y;
			yr.style.display = "block";
			show = true;
		} else {
			yr.style.display = "none";
		}
		yr = yr.nextSibling;
		Y += fwd ? cal.yearStep : -cal.yearStep;
	}
	if (show) {
		var s = yc.style;
		s.display = "block";
		if (cd.navtype < 0)
			s.left = cd.offsetLeft + "px";
		else {
			var ycw = yc.offsetWidth;
			if (typeof ycw == "undefined")
				// Konqueror brain-dead techniques
				ycw = 50;
			s.left = (cd.offsetLeft + cd.offsetWidth - ycw) + "px";
		}
		s.top = (cd.offsetTop + cd.offsetHeight) + "px";
	}
};

// event handlers

Calendar.tableMouseUp = function(ev) {
	var cal = Calendar._C;
	if (!cal) {
		return false;
	}
	if (cal.timeout) {
		clearTimeout(cal.timeout);
	}
	var el = cal.activeDiv;
	if (!el) {
		return false;
	}
	var target = Calendar.getTargetElement(ev);
	ev || (ev = window.event);
	Calendar.removeClass(el, "active");
	if (target == el || target.parentNode == el) {
		Calendar.cellClick(el, ev);
	}
	var mon = Calendar.findMonth(target);
	var date = null;
	if (mon) {
		date = new Date(cal.date);
		if (mon.month != date.getMonth()) {
			date.setMonth(mon.month);
			cal.setDate(date);
			cal.dateClicked = false;
			cal.callHandler();
		}
	} else {
		var year = Calendar.findYear(target);
		if (year) {
			date = new Date(cal.date);
			if (year.year != date.getFullYear()) {
				date.setFullYear(year.year);
				cal.setDate(date);
				cal.dateClicked = false;
				cal.callHandler();
			}
		}
	}
	with (Calendar) {
		removeEvent(document, "mouseup", tableMouseUp);
		removeEvent(document, "mouseover", tableMouseOver);
		removeEvent(document, "mousemove", tableMouseOver);
		cal._hideCombos();
		_C = null;
		return stopEvent(ev);
	}
};

Calendar.tableMouseOver = function (ev) {
	var cal = Calendar._C;
	if (!cal) {
		return;
	}
	var el = cal.activeDiv;
	var target = Calendar.getTargetElement(ev);
	if (target == el || target.parentNode == el) {
		Calendar.addClass(el, "hilite active");
		Calendar.addClass(el.parentNode, "rowhilite");
	} else {
		if (typeof el.navtype == "undefined" || (el.navtype != 50 && (el.navtype == 0 || Math.abs(el.navtype) > 2)))
			Calendar.removeClass(el, "active");
		Calendar.removeClass(el, "hilite");
		Calendar.removeClass(el.parentNode, "rowhilite");
	}
	ev || (ev = window.event);
	if (el.navtype == 50 && target != el) {
		var pos = Calendar.getAbsolutePos(el);
		var w = el.offsetWidth;
		var x = ev.clientX;
		var dx;
		var decrease = true;
		if (x > pos.x + w) {
			dx = x - pos.x - w;
			decrease = false;
		} else
			dx = pos.x - x;

		if (dx < 0) dx = 0;
		var range = el._range;
		var current = el._current;
		var count = Math.floor(dx / 10) % range.length;
		for (var i = range.length; --i >= 0;)
			if (range[i] == current)
				break;
		while (count-- > 0)
			if (decrease) {
				if (--i < 0)
					i = range.length - 1;
			} else if ( ++i >= range.length )
				i = 0;
		var newval = range[i];
		el.innerHTML = newval;

		cal.onUpdateTime();
	}
	var mon = Calendar.findMonth(target);
	if (mon) {
		if (mon.month != cal.date.getMonth()) {
			if (cal.hilitedMonth) {
				Calendar.removeClass(cal.hilitedMonth, "hilite");
			}
			Calendar.addClass(mon, "hilite");
			cal.hilitedMonth = mon;
		} else if (cal.hilitedMonth) {
			Calendar.removeClass(cal.hilitedMonth, "hilite");
		}
	} else {
		if (cal.hilitedMonth) {
			Calendar.removeClass(cal.hilitedMonth, "hilite");
		}
		var year = Calendar.findYear(target);
		if (year) {
			if (year.year != cal.date.getFullYear()) {
				if (cal.hilitedYear) {
					Calendar.removeClass(cal.hilitedYear, "hilite");
				}
				Calendar.addClass(year, "hilite");
				cal.hilitedYear = year;
			} else if (cal.hilitedYear) {
				Calendar.removeClass(cal.hilitedYear, "hilite");
			}
		} else if (cal.hilitedYear) {
			Calendar.removeClass(cal.hilitedYear, "hilite");
		}
	}
	return Calendar.stopEvent(ev);
};

Calendar.tableMouseDown = function (ev) {
	if (Calendar.getTargetElement(ev) == Calendar.getElement(ev)) {
		return Calendar.stopEvent(ev);
	}
};

Calendar.calDragIt = function (ev) {
	var cal = Calendar._C;
	if (!(cal && cal.dragging)) {
		return false;
	}
	var posX;
	var posY;
	if (Calendar.is_ie) {
		posY = window.event.clientY + document.body.scrollTop;
		posX = window.event.clientX + document.body.scrollLeft;
	} else {
		posX = ev.pageX;
		posY = ev.pageY;
	}
	cal.hideShowCovered();
	var st = cal.element.style;
	st.left = (posX - cal.xOffs) + "px";
	st.top = (posY - cal.yOffs) + "px";
	return Calendar.stopEvent(ev);
};

Calendar.calDragEnd = function (ev) {
	var cal = Calendar._C;
	if (!cal) {
		return false;
	}
	cal.dragging = false;
	with (Calendar) {
		removeEvent(document, "mousemove", calDragIt);
		removeEvent(document, "mouseup", calDragEnd);
		tableMouseUp(ev);
	}
	cal.hideShowCovered();
};

Calendar.dayMouseDown = function(ev) {
	var el = Calendar.getElement(ev);
	if (el.disabled) {
		return false;
	}
	var cal = el.calendar;
	cal.activeDiv = el;
	Calendar._C = cal;
	if (el.navtype != 300) with (Calendar) {
		if (el.navtype == 50) {
			el._current = el.innerHTML;
			addEvent(document, "mousemove", tableMouseOver);
		} else
			addEvent(document, Calendar.is_ie5 ? "mousemove" : "mouseover", tableMouseOver);
		addClass(el, "hilite active");
		addEvent(document, "mouseup", tableMouseUp);
	} else if (cal.isPopup) {
		cal._dragStart(ev);
	}
	if (el.navtype == -1 || el.navtype == 1) {
		if (cal.timeout) clearTimeout(cal.timeout);
		cal.timeout = setTimeout("Calendar.showMonthsCombo()", 250);
	} else if (el.navtype == -2 || el.navtype == 2) {
		if (cal.timeout) clearTimeout(cal.timeout);
		cal.timeout = setTimeout((el.navtype > 0) ? "Calendar.showYearsCombo(true)" : "Calendar.showYearsCombo(false)", 250);
	} else {
		cal.timeout = null;
	}
	return Calendar.stopEvent(ev);
};

Calendar.dayMouseDblClick = function(ev) {
	Calendar.cellClick(Calendar.getElement(ev), ev || window.event);
	if (Calendar.is_ie) {
		document.selection.empty();
	}
};

Calendar.dayMouseOver = function(ev) {
	var el = Calendar.getElement(ev);
	if (Calendar.isRelated(el, ev) || Calendar._C || el.disabled) {
		return false;
	}
	if (el.ttip) {
		if (el.ttip.substr(0, 1) == "_") {
			el.ttip = el.caldate.print(el.calendar.ttDateFormat) + el.ttip.substr(1);
		}
		el.calendar.tooltips.innerHTML = el.ttip;
	}
	if (el.navtype != 300) {
		Calendar.addClass(el, "hilite");
		if (el.caldate) {
			Calendar.addClass(el.parentNode, "rowhilite");
		}
	}
	return Calendar.stopEvent(ev);
};

Calendar.dayMouseOut = function(ev) {
	with (Calendar) {
		var el = getElement(ev);
		if (isRelated(el, ev) || _C || el.disabled)
			return false;
		removeClass(el, "hilite");
		if (el.caldate)
			removeClass(el.parentNode, "rowhilite");
		if (el.calendar)
			el.calendar.tooltips.innerHTML = _TT["SEL_DATE"];
		return stopEvent(ev);
	}
};

/**
 *  A generic "click" handler :) handles all types of buttons defined in this
 *  calendar.
 */
Calendar.cellClick = function(el, ev) {
	var cal = el.calendar;
	var closing = false;
	var newdate = false;
	var date = null;
	if (typeof el.navtype == "undefined") {
		if (cal.currentDateEl) {
			Calendar.removeClass(cal.currentDateEl, "selected");
			Calendar.addClass(el, "selected");
			closing = (cal.currentDateEl == el);
			if (!closing) {
				cal.currentDateEl = el;
			}
		}
		cal.date.setDateOnly(el.caldate);
		date = cal.date;
		var other_month = !(cal.dateClicked = !el.otherMonth);
		if (!other_month && !cal.currentDateEl)
			cal._toggleMultipleDate(new Date(date));
		else
			newdate = !el.disabled;
		// a date was clicked
		if (other_month)
			cal._init(cal.firstDayOfWeek, date);
	} else {
		if (el.navtype == 200) {
			Calendar.removeClass(el, "hilite");
			cal.callCloseHandler();
			return;
		}
		date = new Date(cal.date);
		if (el.navtype == 0)
			date.setDateOnly(new Date()); // TODAY
		// unless "today" was clicked, we assume no date was clicked so
		// the selected handler will know not to close the calenar when
		// in single-click mode.
		// cal.dateClicked = (el.navtype == 0);
		cal.dateClicked = false;
		var year = date.getFullYear();
		var mon = date.getMonth();
		function setMonth(m) {
			var day = date.getDate();
			var max = date.getMonthDays(m);
			if (day > max) {
				date.setDate(max);
			}
			date.setMonth(m);
		};
		switch (el.navtype) {
		    case 400:
			Calendar.removeClass(el, "hilite");
			var text = Calendar._TT["ABOUT"];
			if (typeof text != "undefined") {
				text += cal.showsTime ? Calendar._TT["ABOUT_TIME"] : "";
			} else {
				// FIXME: this should be removed as soon as lang files get updated!
				text = "Help and about box text is not translated into this language.\n" +
					"If you know this language and you feel generous please update\n" +
					"the corresponding file in \"lang\" subdir to match calendar-en.js\n" +
					"and send it back to <mihai_bazon@yahoo.com> to get it into the distribution  ;-)\n\n" +
					"Thank you!\n" +
					"http://dynarch.com/mishoo/calendar.epl\n";
			}
			alert(text);
			return;
		    case -2:
			if (year > cal.minYear) {
				date.setFullYear(year - 1);
			}
			break;
		    case -1:
			if (mon > 0) {
				setMonth(mon - 1);
			} else if (year-- > cal.minYear) {
				date.setFullYear(year);
				setMonth(11);
			}
			break;
		    case 1:
			if (mon < 11) {
				setMonth(mon + 1);
			} else if (year < cal.maxYear) {
				date.setFullYear(year + 1);
				setMonth(0);
			}
			break;
		    case 2:
			if (year < cal.maxYear) {
				date.setFullYear(year + 1);
			}
			break;
		    case 100:
			cal.setFirstDayOfWeek(el.fdow);
			return;
		    case 50:
			var range = el._range;
			var current = el.innerHTML;
			for (var i = range.length; --i >= 0;)
				if (range[i] == current)
					break;
			if (ev && ev.shiftKey) {
				if (--i < 0)
					i = range.length - 1;
			} else if ( ++i >= range.length )
				i = 0;
			var newval = range[i];
			el.innerHTML = newval;
			cal.onUpdateTime();
			return;
		    case 0:
			// TODAY will bring us here
			if ((typeof cal.getDateStatus == "function") &&
			    cal.getDateStatus(date, date.getFullYear(), date.getMonth(), date.getDate())) {
				return false;
			}
			break;
		}
		if (!date.equalsTo(cal.date)) {
			cal.setDate(date);
			newdate = true;
		} else if (el.navtype == 0)
			newdate = closing = true;
	}
	if (newdate) {
		ev && cal.callHandler();
	}
	if (closing) {
		Calendar.removeClass(el, "hilite");
		ev && cal.callCloseHandler();
	}
};

// END: CALENDAR STATIC FUNCTIONS

// BEGIN: CALENDAR OBJECT FUNCTIONS

/**
 *  This function creates the calendar inside the given parent.  If _par is
 *  null than it creates a popup calendar inside the BODY element.  If _par is
 *  an element, be it BODY, then it creates a non-popup calendar (still
 *  hidden).  Some properties need to be set before calling this function.
 */
Calendar.prototype.create = function (_par) {
	var parent = null;
	if (! _par) {
		// default parent is the document body, in which case we create
		// a popup calendar.
		parent = document.getElementsByTagName("body")[0];
		this.isPopup = true;
	} else {
		parent = _par;
		this.isPopup = false;
	}
	this.date = this.dateStr ? new Date(this.dateStr) : new Date();

	var table = Calendar.createElement("table");
	this.table = table;
	table.cellSpacing = 0;
	table.cellPadding = 0;
	table.calendar = this;
	Calendar.addEvent(table, "mousedown", Calendar.tableMouseDown);

	var div = Calendar.createElement("div");
	this.element = div;
	div.className = "calendar";
	if (this.isPopup) {
		div.style.position = "absolute";
		div.style.display = "none";
	}
	div.appendChild(table);

	var thead = Calendar.createElement("thead", table);
	var cell = null;
	var row = null;

	var cal = this;
	var hh = function (text, cs, navtype) {
		cell = Calendar.createElement("td", row);
		cell.colSpan = cs;
		cell.className = "button";
		if (navtype != 0 && Math.abs(navtype) <= 2)
			cell.className += " nav";
		Calendar._add_evs(cell);
		cell.calendar = cal;
		cell.navtype = navtype;
		cell.innerHTML = "<div unselectable='on'>" + text + "</div>";
		return cell;
	};

	row = Calendar.createElement("tr", thead);
	var title_length = 6;
	(this.isPopup) && --title_length;
	(this.weekNumbers) && ++title_length;

	hh("?", 1, 400).ttip = Calendar._TT["INFO"];
	this.title = hh("", title_length, 300);
	this.title.className = "title";
	if (this.isPopup) {
		this.title.ttip = Calendar._TT["DRAG_TO_MOVE"];
		this.title.style.cursor = "move";
		hh("&#x00d7;", 1, 200).ttip = Calendar._TT["CLOSE"];
	}

	row = Calendar.createElement("tr", thead);
	row.className = "headrow";

	this._nav_py = hh("&#x00ab;", 1, -2);
	this._nav_py.ttip = Calendar._TT["PREV_YEAR"];

	this._nav_pm = hh("&#x2039;", 1, -1);
	this._nav_pm.ttip = Calendar._TT["PREV_MONTH"];

	this._nav_now = hh(Calendar._TT["TODAY"], this.weekNumbers ? 4 : 3, 0);
	this._nav_now.ttip = Calendar._TT["GO_TODAY"];

	this._nav_nm = hh("&#x203a;", 1, 1);
	this._nav_nm.ttip = Calendar._TT["NEXT_MONTH"];

	this._nav_ny = hh("&#x00bb;", 1, 2);
	this._nav_ny.ttip = Calendar._TT["NEXT_YEAR"];

	// day names
	row = Calendar.createElement("tr", thead);
	row.className = "daynames";
	if (this.weekNumbers) {
		cell = Calendar.createElement("td", row);
		cell.className = "name wn";
		cell.innerHTML = Calendar._TT["WK"];
	}
	for (var i = 7; i > 0; --i) {
		cell = Calendar.createElement("td", row);
		if (!i) {
			cell.navtype = 100;
			cell.calendar = this;
			Calendar._add_evs(cell);
		}
	}
	this.firstdayname = (this.weekNumbers) ? row.firstChild.nextSibling : row.firstChild;
	this._displayWeekdays();

	var tbody = Calendar.createElement("tbody", table);
	this.tbody = tbody;

	for (i = 6; i > 0; --i) {
		row = Calendar.createElement("tr", tbody);
		if (this.weekNumbers) {
			cell = Calendar.createElement("td", row);
		}
		for (var j = 7; j > 0; --j) {
			cell = Calendar.createElement("td", row);
			cell.calendar = this;
			Calendar._add_evs(cell);
		}
	}

	if (this.showsTime) {
		row = Calendar.createElement("tr", tbody);
		row.className = "time";

		cell = Calendar.createElement("td", row);
		cell.className = "time";
		cell.colSpan = 2;
		cell.innerHTML = Calendar._TT["TIME"] || "&nbsp;";

		cell = Calendar.createElement("td", row);
		cell.className = "time";
		cell.colSpan = this.weekNumbers ? 4 : 3;

		(function(){
			function makeTimePart(className, init, range_start, range_end) {
				var part = Calendar.createElement("span", cell);
				part.className = className;
				part.innerHTML = init;
				part.calendar = cal;
				part.ttip = Calendar._TT["TIME_PART"];
				part.navtype = 50;
				part._range = [];
				if (typeof range_start != "number")
					part._range = range_start;
				else {
					for (var i = range_start; i <= range_end; ++i) {
						var txt;
						if (i < 10 && range_end >= 10) txt = '0' + i;
						else txt = '' + i;
						part._range[part._range.length] = txt;
					}
				}
				Calendar._add_evs(part);
				return part;
			};
			var hrs = cal.date.getHours();
			var mins = cal.date.getMinutes();
			var t12 = !cal.time24;
			var pm = (hrs > 12);
			if (t12 && pm) hrs -= 12;
			var H = makeTimePart("hour", hrs, t12 ? 1 : 0, t12 ? 12 : 23);
			var span = Calendar.createElement("span", cell);
			span.innerHTML = ":";
			span.className = "colon";
			var M = makeTimePart("minute", mins, 0, 59);
			var AP = null;
			cell = Calendar.createElement("td", row);
			cell.className = "time";
			cell.colSpan = 2;
			if (t12)
				AP = makeTimePart("ampm", pm ? "pm" : "am", ["am", "pm"]);
			else
				cell.innerHTML = "&nbsp;";

			cal.onSetTime = function() {
				var pm, hrs = this.date.getHours(),
					mins = this.date.getMinutes();
				if (t12) {
					pm = (hrs >= 12);
					if (pm) hrs -= 12;
					if (hrs == 0) hrs = 12;
					AP.innerHTML = pm ? "pm" : "am";
				}
				H.innerHTML = (hrs < 10) ? ("0" + hrs) : hrs;
				M.innerHTML = (mins < 10) ? ("0" + mins) : mins;
			};

			cal.onUpdateTime = function() {
				var date = this.date;
				var h = parseInt(H.innerHTML, 10);
				if (t12) {
					if (/pm/i.test(AP.innerHTML) && h < 12)
						h += 12;
					else if (/am/i.test(AP.innerHTML) && h == 12)
						h = 0;
				}
				var d = date.getDate();
				var m = date.getMonth();
				var y = date.getFullYear();
				date.setHours(h);
				date.setMinutes(parseInt(M.innerHTML, 10));
				date.setFullYear(y);
				date.setMonth(m);
				date.setDate(d);
				this.dateClicked = false;
				this.callHandler();
			};
		})();
	} else {
		this.onSetTime = this.onUpdateTime = function() {};
	}

	var tfoot = Calendar.createElement("tfoot", table);

	row = Calendar.createElement("tr", tfoot);
	row.className = "footrow";

	cell = hh(Calendar._TT["SEL_DATE"], this.weekNumbers ? 8 : 7, 300);
	cell.className = "ttip";
	if (this.isPopup) {
		cell.ttip = Calendar._TT["DRAG_TO_MOVE"];
		cell.style.cursor = "move";
	}
	this.tooltips = cell;

	div = Calendar.createElement("div", this.element);
	this.monthsCombo = div;
	div.className = "combo";
	for (i = 0; i < Calendar._MN.length; ++i) {
		var mn = Calendar.createElement("div");
		mn.className = Calendar.is_ie ? "label-IEfix" : "label";
		mn.month = i;
		mn.innerHTML = Calendar._SMN[i];
		div.appendChild(mn);
	}

	div = Calendar.createElement("div", this.element);
	this.yearsCombo = div;
	div.className = "combo";
	for (i = 12; i > 0; --i) {
		var yr = Calendar.createElement("div");
		yr.className = Calendar.is_ie ? "label-IEfix" : "label";
		div.appendChild(yr);
	}

	this._init(this.firstDayOfWeek, this.date);
	parent.appendChild(this.element);
};

/** keyboard navigation, only for popup calendars */
Calendar._keyEvent = function(ev) {
	var cal = window._dynarch_popupCalendar;
	if (!cal || cal.multiple)
		return false;
	(Calendar.is_ie) && (ev = window.event);
	var act = (Calendar.is_ie || ev.type == "keypress"),
		K = ev.keyCode;
	if (ev.ctrlKey) {
		switch (K) {
		    case 37: // KEY left
			act && Calendar.cellClick(cal._nav_pm);
			break;
		    case 38: // KEY up
			act && Calendar.cellClick(cal._nav_py);
			break;
		    case 39: // KEY right
			act && Calendar.cellClick(cal._nav_nm);
			break;
		    case 40: // KEY down
			act && Calendar.cellClick(cal._nav_ny);
			break;
		    default:
			return false;
		}
	} else switch (K) {
	    case 32: // KEY space (now)
		Calendar.cellClick(cal._nav_now);
		break;
	    case 27: // KEY esc
		act && cal.callCloseHandler();
		break;
	    case 37: // KEY left
	    case 38: // KEY up
	    case 39: // KEY right
	    case 40: // KEY down
		if (act) {
			var prev, x, y, ne, el, step;
			prev = K == 37 || K == 38;
			step = (K == 37 || K == 39) ? 1 : 7;
			function setVars() {
				el = cal.currentDateEl;
				var p = el.pos;
				x = p & 15;
				y = p >> 4;
				ne = cal.ar_days[y][x];
			};setVars();
			function prevMonth() {
				var date = new Date(cal.date);
				date.setDate(date.getDate() - step);
				cal.setDate(date);
			};
			function nextMonth() {
				var date = new Date(cal.date);
				date.setDate(date.getDate() + step);
				cal.setDate(date);
			};
			while (1) {
				switch (K) {
				    case 37: // KEY left
					if (--x >= 0)
						ne = cal.ar_days[y][x];
					else {
						x = 6;
						K = 38;
						continue;
					}
					break;
				    case 38: // KEY up
					if (--y >= 0)
						ne = cal.ar_days[y][x];
					else {
						prevMonth();
						setVars();
					}
					break;
				    case 39: // KEY right
					if (++x < 7)
						ne = cal.ar_days[y][x];
					else {
						x = 0;
						K = 40;
						continue;
					}
					break;
				    case 40: // KEY down
					if (++y < cal.ar_days.length)
						ne = cal.ar_days[y][x];
					else {
						nextMonth();
						setVars();
					}
					break;
				}
				break;
			}
			if (ne) {
				if (!ne.disabled)
					Calendar.cellClick(ne);
				else if (prev)
					prevMonth();
				else
					nextMonth();
			}
		}
		break;
	    case 13: // KEY enter
		if (act)
			Calendar.cellClick(cal.currentDateEl, ev);
		break;
	    default:
		return false;
	}
	return Calendar.stopEvent(ev);
};

/**
 *  (RE)Initializes the calendar to the given date and firstDayOfWeek
 */
Calendar.prototype._init = function (firstDayOfWeek, date) {
	var today = new Date(),
		TY = today.getFullYear(),
		TM = today.getMonth(),
		TD = today.getDate();
	this.table.style.visibility = "hidden";
	var year = date.getFullYear();
	if (year < this.minYear) {
		year = this.minYear;
		date.setFullYear(year);
	} else if (year > this.maxYear) {
		year = this.maxYear;
		date.setFullYear(year);
	}
	this.firstDayOfWeek = firstDayOfWeek;
	this.date = new Date(date);
	var month = date.getMonth();
	var mday = date.getDate();
	var no_days = date.getMonthDays();

	// calendar voodoo for computing the first day that would actually be
	// displayed in the calendar, even if it's from the previous month.
	// WARNING: this is magic. ;-)
	date.setDate(1);
	var day1 = (date.getDay() - this.firstDayOfWeek) % 7;
	if (day1 < 0)
		day1 += 7;
	date.setDate(-day1);
	date.setDate(date.getDate() + 1);

	var row = this.tbody.firstChild;
	var MN = Calendar._SMN[month];
	var ar_days = this.ar_days = new Array();
	var weekend = Calendar._TT["WEEKEND"];
	var dates = this.multiple ? (this.datesCells = {}) : null;
	for (var i = 0; i < 6; ++i, row = row.nextSibling) {
		var cell = row.firstChild;
		if (this.weekNumbers) {
			cell.className = "day wn";
			cell.innerHTML = date.getWeekNumber();
			cell = cell.nextSibling;
		}
		row.className = "daysrow";
		var hasdays = false, iday, dpos = ar_days[i] = [];
		for (var j = 0; j < 7; ++j, cell = cell.nextSibling, date.setDate(iday + 1)) {
			iday = date.getDate();
			var wday = date.getDay();
			cell.className = "day";
			cell.pos = i << 4 | j;
			dpos[j] = cell;
			var current_month = (date.getMonth() == month);
			if (!current_month) {
				if (this.showsOtherMonths) {
					cell.className += " othermonth";
					cell.otherMonth = true;
				} else {
					cell.className = "emptycell";
					cell.innerHTML = "&nbsp;";
					cell.disabled = true;
					continue;
				}
			} else {
				cell.otherMonth = false;
				hasdays = true;
			}
			cell.disabled = false;
			cell.innerHTML = this.getDateText ? this.getDateText(date, iday) : iday;
			if (dates)
				dates[date.print("%Y%m%d")] = cell;
			if (this.getDateStatus) {
				var status = this.getDateStatus(date, year, month, iday);
				if (this.getDateToolTip) {
					var toolTip = this.getDateToolTip(date, year, month, iday);
					if (toolTip)
						cell.title = toolTip;
				}
				if (status === true) {
					cell.className += " disabled";
					cell.disabled = true;
				} else {
					if (/disabled/i.test(status))
						cell.disabled = true;
					cell.className += " " + status;
				}
			}
			if (!cell.disabled) {
				cell.caldate = new Date(date);
				cell.ttip = "_";
				if (!this.multiple && current_month
				    && iday == mday && this.hiliteToday) {
					cell.className += " selected";
					this.currentDateEl = cell;
				}
				if (date.getFullYear() == TY &&
				    date.getMonth() == TM &&
				    iday == TD) {
					cell.className += " today";
					cell.ttip += Calendar._TT["PART_TODAY"];
				}
				if (weekend.indexOf(wday.toString()) != -1)
					cell.className += cell.otherMonth ? " oweekend" : " weekend";
			}
		}
		if (!(hasdays || this.showsOtherMonths))
			row.className = "emptyrow";
	}
	this.title.innerHTML = Calendar._MN[month] + ", " + year;
	this.onSetTime();
	this.table.style.visibility = "visible";
	this._initMultipleDates();
	// PROFILE
	// this.tooltips.innerHTML = "Generated in " + ((new Date()) - today) + " ms";
};

Calendar.prototype._initMultipleDates = function() {
	if (this.multiple) {
		for (var i in this.multiple) {
			var cell = this.datesCells[i];
			var d = this.multiple[i];
			if (!d)
				continue;
			if (cell)
				cell.className += " selected";
		}
	}
};

Calendar.prototype._toggleMultipleDate = function(date) {
	if (this.multiple) {
		var ds = date.print("%Y%m%d");
		var cell = this.datesCells[ds];
		if (cell) {
			var d = this.multiple[ds];
			if (!d) {
				Calendar.addClass(cell, "selected");
				this.multiple[ds] = date;
			} else {
				Calendar.removeClass(cell, "selected");
				delete this.multiple[ds];
			}
		}
	}
};

Calendar.prototype.setDateToolTipHandler = function (unaryFunction) {
	this.getDateToolTip = unaryFunction;
};

/**
 *  Calls _init function above for going to a certain date (but only if the
 *  date is different than the currently selected one).
 */
Calendar.prototype.setDate = function (date) {
	if (!date.equalsTo(this.date)) {
		this._init(this.firstDayOfWeek, date);
	}
};

/**
 *  Refreshes the calendar.  Useful if the "disabledHandler" function is
 *  dynamic, meaning that the list of disabled date can change at runtime.
 *  Just * call this function if you think that the list of disabled dates
 *  should * change.
 */
Calendar.prototype.refresh = function () {
	this._init(this.firstDayOfWeek, this.date);
};

/** Modifies the "firstDayOfWeek" parameter (pass 0 for Synday, 1 for Monday, etc.). */
Calendar.prototype.setFirstDayOfWeek = function (firstDayOfWeek) {
	this._init(firstDayOfWeek, this.date);
	this._displayWeekdays();
};

/**
 *  Allows customization of what dates are enabled.  The "unaryFunction"
 *  parameter must be a function object that receives the date (as a JS Date
 *  object) and returns a boolean value.  If the returned value is true then
 *  the passed date will be marked as disabled.
 */
Calendar.prototype.setDateStatusHandler = Calendar.prototype.setDisabledHandler = function (unaryFunction) {
	this.getDateStatus = unaryFunction;
};

/** Customization of allowed year range for the calendar. */
Calendar.prototype.setRange = function (a, z) {
	this.minYear = a;
	this.maxYear = z;
};

/** Calls the first user handler (selectedHandler). */
Calendar.prototype.callHandler = function () {
	if (this.onSelected) {
		this.onSelected(this, this.date.print(this.dateFormat));
	}
};

/** Calls the second user handler (closeHandler). */
Calendar.prototype.callCloseHandler = function () {
	if (this.onClose) {
		this.onClose(this);
	}
	this.hideShowCovered();
};

/** Removes the calendar object from the DOM tree and destroys it. */
Calendar.prototype.destroy = function () {
	var el = this.element.parentNode;
	el.removeChild(this.element);
	Calendar._C = null;
	window._dynarch_popupCalendar = null;
};

/**
 *  Moves the calendar element to a different section in the DOM tree (changes
 *  its parent).
 */
Calendar.prototype.reparent = function (new_parent) {
	var el = this.element;
	el.parentNode.removeChild(el);
	new_parent.appendChild(el);
};

// This gets called when the user presses a mouse button anywhere in the
// document, if the calendar is shown.  If the click was outside the open
// calendar this function closes it.
Calendar._checkCalendar = function(ev) {
	var calendar = window._dynarch_popupCalendar;
	if (!calendar) {
		return false;
	}
	var el = Calendar.is_ie ? Calendar.getElement(ev) : Calendar.getTargetElement(ev);
	for (; el != null && el != calendar.element; el = el.parentNode);
	if (el == null) {
		// calls closeHandler which should hide the calendar.
		window._dynarch_popupCalendar.callCloseHandler();
		return Calendar.stopEvent(ev);
	}
};

/** Shows the calendar. */
Calendar.prototype.show = function () {
	var rows = this.table.getElementsByTagName("tr");
	for (var i = rows.length; i > 0;) {
		var row = rows[--i];
		Calendar.removeClass(row, "rowhilite");
		var cells = row.getElementsByTagName("td");
		for (var j = cells.length; j > 0;) {
			var cell = cells[--j];
			Calendar.removeClass(cell, "hilite");
			Calendar.removeClass(cell, "active");
		}
	}
	this.element.style.display = "block";
	this.hidden = false;
	if (this.isPopup) {
		window._dynarch_popupCalendar = this;
		Calendar.addEvent(document, "keydown", Calendar._keyEvent);
		Calendar.addEvent(document, "keypress", Calendar._keyEvent);
		Calendar.addEvent(document, "mousedown", Calendar._checkCalendar);
	}
	this.hideShowCovered();
};

/**
 *  Hides the calendar.  Also removes any "hilite" from the class of any TD
 *  element.
 */
Calendar.prototype.hide = function () {
	if (this.isPopup) {
		Calendar.removeEvent(document, "keydown", Calendar._keyEvent);
		Calendar.removeEvent(document, "keypress", Calendar._keyEvent);
		Calendar.removeEvent(document, "mousedown", Calendar._checkCalendar);
	}
	this.element.style.display = "none";
	this.hidden = true;
	this.hideShowCovered();
};

/**
 *  Shows the calendar at a given absolute position (beware that, depending on
 *  the calendar element style -- position property -- this might be relative
 *  to the parent's containing rectangle).
 */
Calendar.prototype.showAt = function (x, y) {
	var s = this.element.style;
	s.left = x + "px";
	s.top = y + "px";
	this.show();
};

/** Shows the calendar near a given element. */
Calendar.prototype.showAtElement = function (el, opts) {
	var self = this;
	var p = Calendar.getAbsolutePos(el);
	if (!opts || typeof opts != "string") {
		this.showAt(p.x, p.y + el.offsetHeight);
		return true;
	}
	function fixPosition(box) {
		if (box.x < 0)
			box.x = 0;
		if (box.y < 0)
			box.y = 0;
		var cp = document.createElement("div");
		var s = cp.style;
		s.position = "absolute";
		s.right = s.bottom = s.width = s.height = "0px";
		document.body.appendChild(cp);
		var br = Calendar.getAbsolutePos(cp);
		document.body.removeChild(cp);
		if (Calendar.is_ie) {
			br.y += document.body.scrollTop;
			br.x += document.body.scrollLeft;
		} else {
			br.y += window.scrollY;
			br.x += window.scrollX;
		}
		var tmp = box.x + box.width - br.x;
		if (tmp > 0) box.x -= tmp;
		tmp = box.y + box.height - br.y;
		if (tmp > 0) box.y -= tmp;
	};
	this.element.style.display = "block";
	Calendar.continuation_for_the_fucking_khtml_browser = function() {
		var w = self.element.offsetWidth;
		var h = self.element.offsetHeight;
		self.element.style.display = "none";
		var valign = opts.substr(0, 1);
		var halign = "l";
		if (opts.length > 1) {
			halign = opts.substr(1, 1);
		}
		// vertical alignment
		switch (valign) {
		    case "T": p.y -= h; break;
		    case "B": p.y += el.offsetHeight; break;
		    case "C": p.y += (el.offsetHeight - h) / 2; break;
		    case "t": p.y += el.offsetHeight - h; break;
		    case "b": break; // already there
		}
		// horizontal alignment
		switch (halign) {
		    case "L": p.x -= w; break;
		    case "R": p.x += el.offsetWidth; break;
		    case "C": p.x += (el.offsetWidth - w) / 2; break;
		    case "l": p.x += el.offsetWidth - w; break;
		    case "r": break; // already there
		}
		p.width = w;
		p.height = h + 40;
		self.monthsCombo.style.display = "none";
		fixPosition(p);
		self.showAt(p.x, p.y);
	};
	if (Calendar.is_khtml)
		setTimeout("Calendar.continuation_for_the_fucking_khtml_browser()", 10);
	else
		Calendar.continuation_for_the_fucking_khtml_browser();
};

/** Customizes the date format. */
Calendar.prototype.setDateFormat = function (str) {
	this.dateFormat = str;
};

/** Customizes the tooltip date format. */
Calendar.prototype.setTtDateFormat = function (str) {
	this.ttDateFormat = str;
};

/**
 *  Tries to identify the date represented in a string.  If successful it also
 *  calls this.setDate which moves the calendar to the given date.
 */
Calendar.prototype.parseDate = function(str, fmt) {
	if (!fmt)
		fmt = this.dateFormat;
	this.setDate(Date.parseDate(str, fmt));
};

Calendar.prototype.hideShowCovered = function () {
	if (!Calendar.is_ie && !Calendar.is_opera)
		return;
	function getVisib(obj){
		var value = obj.style.visibility;
		if (!value) {
			if (document.defaultView && typeof (document.defaultView.getComputedStyle) == "function") { // Gecko, W3C
				if (!Calendar.is_khtml)
					value = document.defaultView.
						getComputedStyle(obj, "").getPropertyValue("visibility");
				else
					value = '';
			} else if (obj.currentStyle) { // IE
				value = obj.currentStyle.visibility;
			} else
				value = '';
		}
		return value;
	};

	var tags = new Array("applet", "iframe", "select");
	var el = this.element;

	var p = Calendar.getAbsolutePos(el);
	var EX1 = p.x;
	var EX2 = el.offsetWidth + EX1;
	var EY1 = p.y;
	var EY2 = el.offsetHeight + EY1;

	for (var k = tags.length; k > 0; ) {
		var ar = document.getElementsByTagName(tags[--k]);
		var cc = null;

		for (var i = ar.length; i > 0;) {
			cc = ar[--i];

			p = Calendar.getAbsolutePos(cc);
			var CX1 = p.x;
			var CX2 = cc.offsetWidth + CX1;
			var CY1 = p.y;
			var CY2 = cc.offsetHeight + CY1;

			if (this.hidden || (CX1 > EX2) || (CX2 < EX1) || (CY1 > EY2) || (CY2 < EY1)) {
				if (!cc.__msh_save_visibility) {
					cc.__msh_save_visibility = getVisib(cc);
				}
				cc.style.visibility = cc.__msh_save_visibility;
			} else {
				if (!cc.__msh_save_visibility) {
					cc.__msh_save_visibility = getVisib(cc);
				}
				cc.style.visibility = "hidden";
			}
		}
	}
};

/** Internal function; it displays the bar with the names of the weekday. */
Calendar.prototype._displayWeekdays = function () {
	var fdow = this.firstDayOfWeek;
	var cell = this.firstdayname;
	var weekend = Calendar._TT["WEEKEND"];
	for (var i = 0; i < 7; ++i) {
		cell.className = "day name";
		var realday = (i + fdow) % 7;
		if (i) {
			cell.ttip = Calendar._TT["DAY_FIRST"].replace("%s", Calendar._DN[realday]);
			cell.navtype = 100;
			cell.calendar = this;
			cell.fdow = realday;
			Calendar._add_evs(cell);
		}
		if (weekend.indexOf(realday.toString()) != -1) {
			Calendar.addClass(cell, "weekend");
		}
		cell.innerHTML = Calendar._SDN[(i + fdow) % 7];
		cell = cell.nextSibling;
	}
};

/** Internal function.  Hides all combo boxes that might be displayed. */
Calendar.prototype._hideCombos = function () {
	this.monthsCombo.style.display = "none";
	this.yearsCombo.style.display = "none";
};

/** Internal function.  Starts dragging the element. */
Calendar.prototype._dragStart = function (ev) {
	if (this.dragging) {
		return;
	}
	this.dragging = true;
	var posX;
	var posY;
	if (Calendar.is_ie) {
		posY = window.event.clientY + document.body.scrollTop;
		posX = window.event.clientX + document.body.scrollLeft;
	} else {
		posY = ev.clientY + window.scrollY;
		posX = ev.clientX + window.scrollX;
	}
	var st = this.element.style;
	this.xOffs = posX - parseInt(st.left);
	this.yOffs = posY - parseInt(st.top);
	with (Calendar) {
		addEvent(document, "mousemove", calDragIt);
		addEvent(document, "mouseup", calDragEnd);
	}
};

// BEGIN: DATE OBJECT PATCHES

/** Adds the number of days array to the Date object. */
Date._MD = new Array(31,28,31,30,31,30,31,31,30,31,30,31);

/** Constants used for time computations */
Date.SECOND = 1000 /* milliseconds */;
Date.MINUTE = 60 * Date.SECOND;
Date.HOUR   = 60 * Date.MINUTE;
Date.DAY    = 24 * Date.HOUR;
Date.WEEK   =  7 * Date.DAY;

Date.parseDate = function(str, fmt) {
	var today = new Date();
	var y = 0;
	var m = -1;
	var d = 0;
	var a = str.split(/\W+/);
	var b = fmt.match(/%./g);
	var i = 0, j = 0;
	var hr = 0;
	var min = 0;
	for (i = 0; i < a.length; ++i) {
		if (!a[i])
			continue;
		switch (b[i]) {
		    case "%d":
		    case "%e":
			d = parseInt(a[i], 10);
			break;

		    case "%m":
			m = parseInt(a[i], 10) - 1;
			break;

		    case "%Y":
		    case "%y":
			y = parseInt(a[i], 10);
			(y < 100) && (y += (y > 29) ? 1900 : 2000);
			break;

		    case "%b":
		    case "%B":
			for (j = 0; j < 12; ++j) {
				if (Calendar._MN[j].substr(0, a[i].length).toLowerCase() == a[i].toLowerCase()) { m = j; break; }
			}
			break;

		    case "%H":
		    case "%I":
		    case "%k":
		    case "%l":
			hr = parseInt(a[i], 10);
			break;

		    case "%P":
		    case "%p":
			if (/pm/i.test(a[i]) && hr < 12)
				hr += 12;
			else if (/am/i.test(a[i]) && hr >= 12)
				hr -= 12;
			break;

		    case "%M":
			min = parseInt(a[i], 10);
			break;
		}
	}
	if (isNaN(y)) y = today.getFullYear();
	if (isNaN(m)) m = today.getMonth();
	if (isNaN(d)) d = today.getDate();
	if (isNaN(hr)) hr = today.getHours();
	if (isNaN(min)) min = today.getMinutes();
	if (y != 0 && m != -1 && d != 0)
		return new Date(y, m, d, hr, min, 0);
	y = 0; m = -1; d = 0;
	for (i = 0; i < a.length; ++i) {
		if (a[i].search(/[a-zA-Z]+/) != -1) {
			var t = -1;
			for (j = 0; j < 12; ++j) {
				if (Calendar._MN[j].substr(0, a[i].length).toLowerCase() == a[i].toLowerCase()) { t = j; break; }
			}
			if (t != -1) {
				if (m != -1) {
					d = m+1;
				}
				m = t;
			}
		} else if (parseInt(a[i], 10) <= 12 && m == -1) {
			m = a[i]-1;
		} else if (parseInt(a[i], 10) > 31 && y == 0) {
			y = parseInt(a[i], 10);
			(y < 100) && (y += (y > 29) ? 1900 : 2000);
		} else if (d == 0) {
			d = a[i];
		}
	}
	if (y == 0)
		y = today.getFullYear();
	if (m != -1 && d != 0)
		return new Date(y, m, d, hr, min, 0);
	return today;
};

/** Returns the number of days in the current month */
Date.prototype.getMonthDays = function(month) {
	var year = this.getFullYear();
	if (typeof month == "undefined") {
		month = this.getMonth();
	}
	if (((0 == (year%4)) && ( (0 != (year%100)) || (0 == (year%400)))) && month == 1) {
		return 29;
	} else {
		return Date._MD[month];
	}
};

/** Returns the number of day in the year. */
Date.prototype.getDayOfYear = function() {
	var now = new Date(this.getFullYear(), this.getMonth(), this.getDate(), 0, 0, 0);
	var then = new Date(this.getFullYear(), 0, 0, 0, 0, 0);
	var time = now - then;
	return Math.floor(time / Date.DAY);
};

/** Returns the number of the week in year, as defined in ISO 8601. */
Date.prototype.getWeekNumber = function() {
	var d = new Date(this.getFullYear(), this.getMonth(), this.getDate(), 0, 0, 0);
	var DoW = d.getDay();
	d.setDate(d.getDate() - (DoW + 6) % 7 + 3); // Nearest Thu
	var ms = d.valueOf(); // GMT
	d.setMonth(0);
	d.setDate(4); // Thu in Week 1
	return Math.round((ms - d.valueOf()) / (7 * 864e5)) + 1;
};

/** Checks date and time equality */
Date.prototype.equalsTo = function(date) {
	return ((this.getFullYear() == date.getFullYear()) &&
		(this.getMonth() == date.getMonth()) &&
		(this.getDate() == date.getDate()) &&
		(this.getHours() == date.getHours()) &&
		(this.getMinutes() == date.getMinutes()));
};

/** Set only the year, month, date parts (keep existing time) */
Date.prototype.setDateOnly = function(date) {
	var tmp = new Date(date);
	this.setDate(1);
	this.setFullYear(tmp.getFullYear());
	this.setMonth(tmp.getMonth());
	this.setDate(tmp.getDate());
};

/** Prints the date in a string according to the given format. */
Date.prototype.print = function (str) {
	var m = this.getMonth();
	var d = this.getDate();
	var y = this.getFullYear();
	var wn = this.getWeekNumber();
	var w = this.getDay();
	var s = {};
	var hr = this.getHours();
	var pm = (hr >= 12);
	var ir = (pm) ? (hr - 12) : hr;
	var dy = this.getDayOfYear();
	if (ir == 0)
		ir = 12;
	var min = this.getMinutes();
	var sec = this.getSeconds();
	s["%a"] = Calendar._SDN[w]; // abbreviated weekday name [FIXME: I18N]
	s["%A"] = Calendar._DN[w]; // full weekday name
	s["%b"] = Calendar._SMN[m]; // abbreviated month name [FIXME: I18N]
	s["%B"] = Calendar._MN[m]; // full month name
	// FIXME: %c : preferred date and time representation for the current locale
	s["%C"] = 1 + Math.floor(y / 100); // the century number
	s["%d"] = (d < 10) ? ("0" + d) : d; // the day of the month (range 01 to 31)
	s["%e"] = d; // the day of the month (range 1 to 31)
	// FIXME: %D : american date style: %m/%d/%y
	// FIXME: %E, %F, %G, %g, %h (man strftime)
	s["%H"] = (hr < 10) ? ("0" + hr) : hr; // hour, range 00 to 23 (24h format)
	s["%I"] = (ir < 10) ? ("0" + ir) : ir; // hour, range 01 to 12 (12h format)
	s["%j"] = (dy < 100) ? ((dy < 10) ? ("00" + dy) : ("0" + dy)) : dy; // day of the year (range 001 to 366)
	s["%k"] = hr;		// hour, range 0 to 23 (24h format)
	s["%l"] = ir;		// hour, range 1 to 12 (12h format)
	s["%m"] = (m < 9) ? ("0" + (1+m)) : (1+m); // month, range 01 to 12
	s["%M"] = (min < 10) ? ("0" + min) : min; // minute, range 00 to 59
	s["%n"] = "\n";		// a newline character
	s["%p"] = pm ? "PM" : "AM";
	s["%P"] = pm ? "pm" : "am";
	// FIXME: %r : the time in am/pm notation %I:%M:%S %p
	// FIXME: %R : the time in 24-hour notation %H:%M
	s["%s"] = Math.floor(this.getTime() / 1000);
	s["%S"] = (sec < 10) ? ("0" + sec) : sec; // seconds, range 00 to 59
	s["%t"] = "\t";		// a tab character
	// FIXME: %T : the time in 24-hour notation (%H:%M:%S)
	s["%U"] = s["%W"] = s["%V"] = (wn < 10) ? ("0" + wn) : wn;
	s["%u"] = w + 1;	// the day of the week (range 1 to 7, 1 = MON)
	s["%w"] = w;		// the day of the week (range 0 to 6, 0 = SUN)
	// FIXME: %x : preferred date representation for the current locale without the time
	// FIXME: %X : preferred time representation for the current locale without the date
	s["%y"] = ('' + y).substr(2, 2); // year without the century (range 00 to 99)
	s["%Y"] = y;		// year with the century
	s["%%"] = "%";		// a literal '%' character

	var re = /%./g;
	if (!Calendar.is_ie5 && !Calendar.is_khtml)
		return str.replace(re, function (par) { return s[par] || par; });

	var a = str.match(re);
	for (var i = 0; i < a.length; i++) {
		var tmp = s[a[i]];
		if (tmp) {
			re = new RegExp(a[i], 'g');
			str = str.replace(re, tmp);
		}
	}

	return str;
};

Date.prototype.__msh_oldSetFullYear = Date.prototype.setFullYear;
Date.prototype.setFullYear = function(y) {
	var d = new Date(this);
	d.__msh_oldSetFullYear(y);
	if (d.getMonth() != this.getMonth())
		this.setDate(28);
	this.__msh_oldSetFullYear(y);
};

// END: DATE OBJECT PATCHES


// global object that remembers the calendar
window._dynarch_popupCalendar = null;
/* ==============================================
   === END FILE: public/inc/jscalendar/calendar.js 
   ==============================================*/
/* ==============================================
   === FILE: public/inc/jscalendar/lang/calendar-de.js 
   ==============================================*/
// ** I18N

// Calendar DE language
// Author: Jack (tR), <jack@jtr.de>
// Encoding: any
// Distributed under the same terms as the calendar itself.

// For translators: please use UTF-8 if possible.  We strongly believe that
// Unicode is the answer to a real internationalized world.  Also please
// include your contact information in the header, as can be seen above.

// full day names
Calendar._DN = new Array
("Sonntag",
 "Montag",
 "Dienstag",
 "Mittwoch",
 "Donnerstag",
 "Freitag",
 "Samstag",
 "Sonntag");

// Please note that the following array of short day names (and the same goes
// for short month names, _SMN) isn't absolutely necessary.  We give it here
// for exemplification on how one can customize the short day names, but if
// they are simply the first N letters of the full name you can simply say:
//
//   Calendar._SDN_len = N; // short day name length
//   Calendar._SMN_len = N; // short month name length
//
// If N = 3 then this is not needed either since we assume a value of 3 if not
// present, to be compatible with translation files that were written before
// this feature.

// short day names
Calendar._SDN = new Array
("So",
 "Mo",
 "Di",
 "Mi",
 "Do",
 "Fr",
 "Sa",
 "So");

// full month names
Calendar._MN = new Array
("Januar",
 "Februar",
 "M\u00e4rz",
 "April",
 "Mai",
 "Juni",
 "Juli",
 "August",
 "September",
 "Oktober",
 "November",
 "Dezember");

// short month names
Calendar._SMN = new Array
("Jan",
 "Feb",
 "M\u00e4r",
 "Apr",
 "May",
 "Jun",
 "Jul",
 "Aug",
 "Sep",
 "Okt",
 "Nov",
 "Dez");

// tooltips
Calendar._TT = {};
Calendar._TT["INFO"] = "\u00DCber dieses Kalendarmodul";

Calendar._TT["ABOUT"] =
"DHTML Date/Time Selector\n" +
"(c) dynarch.com 2002-2005 / Author: Mihai Bazon\n" + // don't translate this ;-)
"For latest version visit: http://www.dynarch.com/projects/calendar/\n" +
"Distributed under GNU LGPL.  See http://gnu.org/licenses/lgpl.html for details." +
"\n\n" +
"Datum ausw\u00e4hlen:\n" +
"- Benutzen Sie die \xab, \xbb Buttons um das Jahr zu w\u00e4hlen\n" +
"- Benutzen Sie die " + String.fromCharCode(0x2039) + ", " + String.fromCharCode(0x203a) + " Buttons um den Monat zu w\u00e4hlen\n" +
"- F\u00fcr eine Schnellauswahl halten Sie die Maustaste \u00fcber diesen Buttons fest.";
Calendar._TT["ABOUT_TIME"] = "\n\n" +
"Zeit ausw\u00e4hlen:\n" +
"- Klicken Sie auf die Teile der Uhrzeit, um diese zu erh\u00F6hen\n" +
"- oder klicken Sie mit festgehaltener Shift-Taste um diese zu verringern\n" +
"- oder klicken und festhalten f\u00fcr Schnellauswahl.";

Calendar._TT["TOGGLE"] = "Ersten Tag der Woche w\u00e4hlen";
Calendar._TT["PREV_YEAR"] = "Voriges Jahr (Festhalten f\u00fcr Schnellauswahl)";
Calendar._TT["PREV_MONTH"] = "Voriger Monat (Festhalten f\u00fcr Schnellauswahl)";
Calendar._TT["GO_TODAY"] = "Heute ausw\u00e4hlen";
Calendar._TT["NEXT_MONTH"] = "N\u00e4chst. Monat (Festhalten f\u00fcr Schnellauswahl)";
Calendar._TT["NEXT_YEAR"] = "N\u00e4chst. Jahr (Festhalten f\u00fcr Schnellauswahl)";
Calendar._TT["SEL_DATE"] = "Datum ausw\u00e4hlen";
Calendar._TT["DRAG_TO_MOVE"] = "Zum Bewegen festhalten";
Calendar._TT["PART_TODAY"] = " (Heute)";

// the following is to inform that "%s" is to be the first day of week
// %s will be replaced with the day name.
Calendar._TT["DAY_FIRST"] = "Woche beginnt mit %s ";

// This may be locale-dependent.  It specifies the week-end days, as an array
// of comma-separated numbers.  The numbers are from 0 to 6: 0 means Sunday, 1
// means Monday, etc.
Calendar._TT["WEEKEND"] = "0,6";

Calendar._TT["CLOSE"] = "Schlie\u00dfen";
Calendar._TT["TODAY"] = "Heute";
Calendar._TT["TIME_PART"] = "(Shift-)Klick oder Festhalten und Ziehen um den Wert zu \u00e4ndern";

// date formats
Calendar._TT["DEF_DATE_FORMAT"] = "%d.%m.%Y";
Calendar._TT["TT_DATE_FORMAT"] = "%a, %b %e";

Calendar._TT["WK"] = "wk";
Calendar._TT["TIME"] = "Zeit:";
/* ==============================================
   === END FILE: public/inc/jscalendar/lang/calendar-de.js 
   ==============================================*/
/* ==============================================
   === FILE: public/inc/jscalendar/calendar-setup.js 
   ==============================================*/
/*  Copyright Mihai Bazon, 2002, 2003  |  http://dynarch.com/mishoo/
 * ---------------------------------------------------------------------------
 *
 * The DHTML Calendar
 *
 * Details and latest version at:
 * http://dynarch.com/mishoo/calendar.epl
 *
 * This script is distributed under the GNU Lesser General Public License.
 * Read the entire license text here: http://www.gnu.org/licenses/lgpl.html
 *
 * This file defines helper functions for setting up the calendar.  They are
 * intended to help non-programmers get a working calendar on their site
 * quickly.  This script should not be seen as part of the calendar.  It just
 * shows you what one can do with the calendar, while in the same time
 * providing a quick and simple method for setting it up.  If you need
 * exhaustive customization of the calendar creation process feel free to
 * modify this code to suit your needs (this is recommended and much better
 * than modifying calendar.js itself).
 */

// $Id: calendar-setup.js,v 1.25 2005/03/07 09:51:33 mishoo Exp $

/**
 *  This function "patches" an input field (or other element) to use a calendar
 *  widget for date selection.
 *
 *  The "params" is a single object that can have the following properties:
 *
 *    prop. name   | description
 *  -------------------------------------------------------------------------------------------------
 *   inputField    | the ID of an input field to store the date
 *   displayArea   | the ID of a DIV or other element to show the date
 *   button        | ID of a button or other element that will trigger the calendar
 *   eventName     | event that will trigger the calendar, without the "on" prefix (default: "click")
 *   ifFormat      | date format that will be stored in the input field
 *   daFormat      | the date format that will be used to display the date in displayArea
 *   singleClick   | (true/false) wether the calendar is in single click mode or not (default: true)
 *   firstDay      | numeric: 0 to 6.  "0" means display Sunday first, "1" means display Monday first, etc.
 *   align         | alignment (default: "Br"); if you don't know what's this see the calendar documentation
 *   range         | array with 2 elements.  Default: [1900, 2999] -- the range of years available
 *   weekNumbers   | (true/false) if it's true (default) the calendar will display week numbers
 *   flat          | null or element ID; if not null the calendar will be a flat calendar having the parent with the given ID
 *   flatCallback  | function that receives a JS Date object and returns an URL to point the browser to (for flat calendar)
 *   disableFunc   | function that receives a JS Date object and should return true if that date has to be disabled in the calendar
 *   onSelect      | function that gets called when a date is selected.  You don't _have_ to supply this (the default is generally okay)
 *   onClose       | function that gets called when the calendar is closed.  [default]
 *   onUpdate      | function that gets called after the date is updated in the input field.  Receives a reference to the calendar.
 *   date          | the date that the calendar will be initially displayed to
 *   showsTime     | default: false; if true the calendar will include a time selector
 *   timeFormat    | the time format; can be "12" or "24", default is "12"
 *   electric      | if true (default) then given fields/date areas are updated for each move; otherwise they're updated only on close
 *   step          | configures the step of the years in drop-down boxes; default: 2
 *   position      | configures the calendar absolute position; default: null
 *   cache         | if "true" (but default: "false") it will reuse the same calendar object, where possible
 *   showOthers    | if "true" (but default: "false") it will show days from other months too
 *
 *  None of them is required, they all have default values.  However, if you
 *  pass none of "inputField", "displayArea" or "button" you'll get a warning
 *  saying "nothing to setup".
 */
Calendar.setup = function (params) {
	function param_default(pname, def) { if (typeof params[pname] == "undefined") { params[pname] = def; } };

	param_default("inputField",     null);
	param_default("displayArea",    null);
	param_default("button",         null);
	param_default("eventName",      "click");
	param_default("ifFormat",       "%Y/%m/%d");
	param_default("daFormat",       "%Y/%m/%d");
	param_default("singleClick",    true);
	param_default("disableFunc",    null);
	param_default("dateStatusFunc", params["disableFunc"]);	// takes precedence if both are defined
	param_default("dateText",       null);
	param_default("firstDay",       null);
	param_default("align",          "Br");
	param_default("range",          [1900, 2999]);
	param_default("weekNumbers",    true);
	param_default("flat",           null);
	param_default("flatCallback",   null);
	param_default("onSelect",       null);
	param_default("onClose",        null);
	param_default("onUpdate",       null);
	param_default("date",           null);
	param_default("showsTime",      false);
	param_default("timeFormat",     "24");
	param_default("electric",       true);
	param_default("step",           2);
	param_default("position",       null);
	param_default("cache",          false);
	param_default("showOthers",     false);
	param_default("multiple",       null);

	var tmp = ["inputField", "displayArea", "button"];
	for (var i in tmp) {
		if (typeof params[tmp[i]] == "string") {
			params[tmp[i]] = document.getElementById(params[tmp[i]]);
		}
	}
	if (!(params.flat || params.multiple || params.inputField || params.displayArea || params.button)) {
		alert("Calendar.setup:\n  Nothing to setup (no fields found).  Please check your code");
		return false;
	}

	function onSelect(cal) {
		var p = cal.params;
		var update = (cal.dateClicked || p.electric);
		if (update && p.inputField) {
			p.inputField.value = cal.date.print(p.ifFormat);
			if (typeof p.inputField.onchange == "function")
				p.inputField.onchange();
		}
		if (update && p.displayArea)
			p.displayArea.innerHTML = cal.date.print(p.daFormat);
		if (update && typeof p.onUpdate == "function")
			p.onUpdate(cal);
		if (update && p.flat) {
			if (typeof p.flatCallback == "function")
				p.flatCallback(cal);
		}
		if (update && p.singleClick && cal.dateClicked)
			cal.callCloseHandler();
	};

	if (params.flat != null) {
		if (typeof params.flat == "string")
			params.flat = document.getElementById(params.flat);
		if (!params.flat) {
			alert("Calendar.setup:\n  Flat specified but can't find parent.");
			return false;
		}
		var cal = new Calendar(params.firstDay, params.date, params.onSelect || onSelect);
		cal.showsOtherMonths = params.showOthers;
		cal.showsTime = params.showsTime;
		cal.time24 = (params.timeFormat == "24");
		cal.params = params;
		cal.weekNumbers = params.weekNumbers;
		cal.setRange(params.range[0], params.range[1]);
		cal.setDateStatusHandler(params.dateStatusFunc);
		cal.getDateText = params.dateText;
		if (params.ifFormat) {
			cal.setDateFormat(params.ifFormat);
		}
		if (params.inputField && typeof params.inputField.value == "string") {
			cal.parseDate(params.inputField.value);
		}
		cal.create(params.flat);
		cal.show();
		return false;
	}

	var triggerEl = params.button || params.displayArea || params.inputField;
	triggerEl["on" + params.eventName] = function() {
		var dateEl = params.inputField || params.displayArea;
		var dateFmt = params.inputField ? params.ifFormat : params.daFormat;
		var mustCreate = false;
		var cal = window.calendar;
		if (dateEl)
			params.date = Date.parseDate(dateEl.value || dateEl.innerHTML, dateFmt);
		if (!(cal && params.cache)) {
			window.calendar = cal = new Calendar(params.firstDay,
							     params.date,
							     params.onSelect || onSelect,
							     params.onClose || function(cal) { cal.hide(); });
			cal.showsTime = params.showsTime;
			cal.time24 = (params.timeFormat == "24");
			cal.weekNumbers = params.weekNumbers;
			mustCreate = true;
		} else {
			if (params.date)
				cal.setDate(params.date);
			cal.hide();
		}
		if (params.multiple) {
			cal.multiple = {};
			for (var i = params.multiple.length; --i >= 0;) {
				var d = params.multiple[i];
				var ds = d.print("%Y%m%d");
				cal.multiple[ds] = d;
			}
		}
		cal.showsOtherMonths = params.showOthers;
		cal.yearStep = params.step;
		cal.setRange(params.range[0], params.range[1]);
		cal.params = params;
		cal.setDateStatusHandler(params.dateStatusFunc);
		cal.getDateText = params.dateText;
		cal.setDateFormat(dateFmt);
		if (mustCreate)
			cal.create();
		cal.refresh();
		if (!params.position)
			cal.showAtElement(params.button || params.displayArea || params.inputField, params.align);
		else
			cal.showAt(params.position[0], params.position[1]);
		return false;
	};

	return cal;
};
/* ==============================================
   === END FILE: public/inc/jscalendar/calendar-setup.js 
   ==============================================*/
/* ==============================================
   === FILE: public/inc/md5.js 
   ==============================================*/
/*
 *  md5.js 1.0b 27/06/96
 *
 * Javascript implementation of the RSA Data Security, Inc. MD5
 * Message-Digest Algorithm.
 *
 * Copyright (c) 1996 Henri Torgemane. All Rights Reserved.
 *
 * Permission to use, copy, modify, and distribute this software
 * and its documentation for any purposes and without
 * fee is hereby granted provided that this copyright notice
 * appears in all copies.
 *
 * Of course, this soft is provided "as is" without express or implied
 * warranty of any kind.
 *
 *
 * Modified with german comments and some information about collisions.
 * (Ralf Mieke, ralf@miekenet.de, http://mieke.home.pages.de)
 */



function array(n) {
  for(i=0;i<n;i++) this[i]=0;
  this.length=n;
}



/* Einige grundlegenden Funktionen müssen wegen
 * Javascript Fehlern umgeschrieben werden.
 * Man versuche z.B. 0xffffffff >> 4 zu berechnen..
 * Die nun verwendeten Funktionen sind zwar langsamer als die Originale,
 * aber sie funktionieren.
 */

function integer(n) { return n%(0xffffffff+1); }

function shr(a,b) {
  a=integer(a);
  b=integer(b);
  if (a-0x80000000>=0) {
    a=a%0x80000000;
    a>>=b;
    a+=0x40000000>>(b-1);
  } else
    a>>=b;
  return a;
}

function shl1(a) {
  a=a%0x80000000;
  if (a&0x40000000==0x40000000)
  {
    a-=0x40000000;
    a*=2;
    a+=0x80000000;
  } else
    a*=2;
  return a;
}

function shl(a,b) {
  a=integer(a);
  b=integer(b);
  for (var i=0;i<b;i++) a=shl1(a);
  return a;
}

function and(a,b) {
  a=integer(a);
  b=integer(b);
  var t1=(a-0x80000000);
  var t2=(b-0x80000000);
  if (t1>=0)
    if (t2>=0)
      return ((t1&t2)+0x80000000);
    else
      return (t1&b);
  else
    if (t2>=0)
      return (a&t2);
    else
      return (a&b);
}

function or(a,b) {
  a=integer(a);
  b=integer(b);
  var t1=(a-0x80000000);
  var t2=(b-0x80000000);
  if (t1>=0)
    if (t2>=0)
      return ((t1|t2)+0x80000000);
    else
      return ((t1|b)+0x80000000);
  else
    if (t2>=0)
      return ((a|t2)+0x80000000);
    else
      return (a|b);
}

function xor(a,b) {
  a=integer(a);
  b=integer(b);
  var t1=(a-0x80000000);
  var t2=(b-0x80000000);
  if (t1>=0)
    if (t2>=0)
      return (t1^t2);
    else
      return ((t1^b)+0x80000000);
  else
    if (t2>=0)
      return ((a^t2)+0x80000000);
    else
      return (a^b);
}

function not(a) {
  a=integer(a);
  return (0xffffffff-a);
}

/* Beginn des Algorithmus */

    var state = new array(4);
    var count = new array(2);
        count[0] = 0;
        count[1] = 0;
    var buffer = new array(64);
    var transformBuffer = new array(16);
    var digestBits = new array(16);

    var S11 = 7;
    var S12 = 12;
    var S13 = 17;
    var S14 = 22;
    var S21 = 5;
    var S22 = 9;
    var S23 = 14;
    var S24 = 20;
    var S31 = 4;
    var S32 = 11;
    var S33 = 16;
    var S34 = 23;
    var S41 = 6;
    var S42 = 10;
    var S43 = 15;
    var S44 = 21;

    function F(x,y,z) {
        return or(and(x,y),and(not(x),z));
    }

    function G(x,y,z) {
        return or(and(x,z),and(y,not(z)));
    }

    function H(x,y,z) {
        return xor(xor(x,y),z);
    }

    function I(x,y,z) {
        return xor(y ,or(x , not(z)));
    }

    function rotateLeft(a,n) {
        return or(shl(a, n),(shr(a,(32 - n))));
    }

    function FF(a,b,c,d,x,s,ac) {
        a = a+F(b, c, d) + x + ac;
        a = rotateLeft(a, s);
        a = a+b;
        return a;
    }

    function GG(a,b,c,d,x,s,ac) {
        a = a+G(b, c, d) +x + ac;
        a = rotateLeft(a, s);
        a = a+b;
        return a;
    }

    function HH(a,b,c,d,x,s,ac) {
        a = a+H(b, c, d) + x + ac;
        a = rotateLeft(a, s);
        a = a+b;
        return a;
    }

    function II(a,b,c,d,x,s,ac) {
        a = a+I(b, c, d) + x + ac;
        a = rotateLeft(a, s);
        a = a+b;
        return a;
    }

    function transform(buf,offset) {
        var a=0, b=0, c=0, d=0;
        var x = transformBuffer;

        a = state[0];
        b = state[1];
        c = state[2];
        d = state[3];

        for (i = 0; i < 16; i++) {
            x[i] = and(buf[i*4+offset],0xff);
            for (j = 1; j < 4; j++) {
                x[i]+=shl(and(buf[i*4+j+offset] ,0xff), j * 8);
            }
        }

        /* Runde 1 */
        a = FF ( a, b, c, d, x[ 0], S11, 0xd76aa478); /* 1 */
        d = FF ( d, a, b, c, x[ 1], S12, 0xe8c7b756); /* 2 */
        c = FF ( c, d, a, b, x[ 2], S13, 0x242070db); /* 3 */
        b = FF ( b, c, d, a, x[ 3], S14, 0xc1bdceee); /* 4 */
        a = FF ( a, b, c, d, x[ 4], S11, 0xf57c0faf); /* 5 */
        d = FF ( d, a, b, c, x[ 5], S12, 0x4787c62a); /* 6 */
        c = FF ( c, d, a, b, x[ 6], S13, 0xa8304613); /* 7 */
        b = FF ( b, c, d, a, x[ 7], S14, 0xfd469501); /* 8 */
        a = FF ( a, b, c, d, x[ 8], S11, 0x698098d8); /* 9 */
        d = FF ( d, a, b, c, x[ 9], S12, 0x8b44f7af); /* 10 */
        c = FF ( c, d, a, b, x[10], S13, 0xffff5bb1); /* 11 */
        b = FF ( b, c, d, a, x[11], S14, 0x895cd7be); /* 12 */
        a = FF ( a, b, c, d, x[12], S11, 0x6b901122); /* 13 */
        d = FF ( d, a, b, c, x[13], S12, 0xfd987193); /* 14 */
        c = FF ( c, d, a, b, x[14], S13, 0xa679438e); /* 15 */
        b = FF ( b, c, d, a, x[15], S14, 0x49b40821); /* 16 */

        /* Runde 2 */
        a = GG ( a, b, c, d, x[ 1], S21, 0xf61e2562); /* 17 */
        d = GG ( d, a, b, c, x[ 6], S22, 0xc040b340); /* 18 */
        c = GG ( c, d, a, b, x[11], S23, 0x265e5a51); /* 19 */
        b = GG ( b, c, d, a, x[ 0], S24, 0xe9b6c7aa); /* 20 */
        a = GG ( a, b, c, d, x[ 5], S21, 0xd62f105d); /* 21 */
        d = GG ( d, a, b, c, x[10], S22,  0x2441453); /* 22 */
        c = GG ( c, d, a, b, x[15], S23, 0xd8a1e681); /* 23 */
        b = GG ( b, c, d, a, x[ 4], S24, 0xe7d3fbc8); /* 24 */
        a = GG ( a, b, c, d, x[ 9], S21, 0x21e1cde6); /* 25 */
        d = GG ( d, a, b, c, x[14], S22, 0xc33707d6); /* 26 */
        c = GG ( c, d, a, b, x[ 3], S23, 0xf4d50d87); /* 27 */
        b = GG ( b, c, d, a, x[ 8], S24, 0x455a14ed); /* 28 */
        a = GG ( a, b, c, d, x[13], S21, 0xa9e3e905); /* 29 */
        d = GG ( d, a, b, c, x[ 2], S22, 0xfcefa3f8); /* 30 */
        c = GG ( c, d, a, b, x[ 7], S23, 0x676f02d9); /* 31 */
        b = GG ( b, c, d, a, x[12], S24, 0x8d2a4c8a); /* 32 */

        /* Runde 3 */
        a = HH ( a, b, c, d, x[ 5], S31, 0xfffa3942); /* 33 */
        d = HH ( d, a, b, c, x[ 8], S32, 0x8771f681); /* 34 */
        c = HH ( c, d, a, b, x[11], S33, 0x6d9d6122); /* 35 */
        b = HH ( b, c, d, a, x[14], S34, 0xfde5380c); /* 36 */
        a = HH ( a, b, c, d, x[ 1], S31, 0xa4beea44); /* 37 */
        d = HH ( d, a, b, c, x[ 4], S32, 0x4bdecfa9); /* 38 */
        c = HH ( c, d, a, b, x[ 7], S33, 0xf6bb4b60); /* 39 */
        b = HH ( b, c, d, a, x[10], S34, 0xbebfbc70); /* 40 */
        a = HH ( a, b, c, d, x[13], S31, 0x289b7ec6); /* 41 */
        d = HH ( d, a, b, c, x[ 0], S32, 0xeaa127fa); /* 42 */
        c = HH ( c, d, a, b, x[ 3], S33, 0xd4ef3085); /* 43 */
        b = HH ( b, c, d, a, x[ 6], S34,  0x4881d05); /* 44 */
        a = HH ( a, b, c, d, x[ 9], S31, 0xd9d4d039); /* 45 */
        d = HH ( d, a, b, c, x[12], S32, 0xe6db99e5); /* 46 */
        c = HH ( c, d, a, b, x[15], S33, 0x1fa27cf8); /* 47 */
        b = HH ( b, c, d, a, x[ 2], S34, 0xc4ac5665); /* 48 */

        /* Runde 4 */
        a = II ( a, b, c, d, x[ 0], S41, 0xf4292244); /* 49 */
        d = II ( d, a, b, c, x[ 7], S42, 0x432aff97); /* 50 */
        c = II ( c, d, a, b, x[14], S43, 0xab9423a7); /* 51 */
        b = II ( b, c, d, a, x[ 5], S44, 0xfc93a039); /* 52 */
        a = II ( a, b, c, d, x[12], S41, 0x655b59c3); /* 53 */
        d = II ( d, a, b, c, x[ 3], S42, 0x8f0ccc92); /* 54 */
        c = II ( c, d, a, b, x[10], S43, 0xffeff47d); /* 55 */
        b = II ( b, c, d, a, x[ 1], S44, 0x85845dd1); /* 56 */
        a = II ( a, b, c, d, x[ 8], S41, 0x6fa87e4f); /* 57 */
        d = II ( d, a, b, c, x[15], S42, 0xfe2ce6e0); /* 58 */
        c = II ( c, d, a, b, x[ 6], S43, 0xa3014314); /* 59 */
        b = II ( b, c, d, a, x[13], S44, 0x4e0811a1); /* 60 */
        a = II ( a, b, c, d, x[ 4], S41, 0xf7537e82); /* 61 */
        d = II ( d, a, b, c, x[11], S42, 0xbd3af235); /* 62 */
        c = II ( c, d, a, b, x[ 2], S43, 0x2ad7d2bb); /* 63 */
        b = II ( b, c, d, a, x[ 9], S44, 0xeb86d391); /* 64 */

        state[0] +=a;
        state[1] +=b;
        state[2] +=c;
        state[3] +=d;

    }
    /* Mit der Initialisierung von Dobbertin:
       state[0] = 0x12ac2375;
       state[1] = 0x3b341042;
       state[2] = 0x5f62b97c;
       state[3] = 0x4ba763ed;
       gibt es eine Kollision:

       begin 644 Message1
       M7MH=JO6_>MG!X?!51$)W,CXV!A"=(!AR71,<X`Y-IIT9^Z&8L$2N'Y*Y:R.;
       39GIK9>TF$W()/MEHR%C4:G1R:Q"=
       `
       end

       begin 644 Message2
       M7MH=JO6_>MG!X?!51$)W,CXV!A"=(!AR71,<X`Y-IIT9^Z&8L$2N'Y*Y:R.;
       39GIK9>TF$W()/MEHREC4:G1R:Q"=
       `
       end
    */
    function init() {
        count[0]=count[1] = 0;
        state[0] = 0x67452301;
        state[1] = 0xefcdab89;
        state[2] = 0x98badcfe;
        state[3] = 0x10325476;
        for (i = 0; i < digestBits.length; i++)
            digestBits[i] = 0;
    }

    function update(b) {
        var index,i;

        index = and(shr(count[0],3) , 0x3f);
        if (count[0]<0xffffffff-7)
          count[0] += 8;
        else {
          count[1]++;
          count[0]-=0xffffffff+1;
          count[0]+=8;
        }
        buffer[index] = and(b,0xff);
        if (index  >= 63) {
            transform(buffer, 0);
        }
    }

    function finish() {
        var bits = new array(8);
        var        padding;
        var        i=0, index=0, padLen=0;

        for (i = 0; i < 4; i++) {
            bits[i] = and(shr(count[0],(i * 8)), 0xff);
        }
        for (i = 0; i < 4; i++) {
            bits[i+4]=and(shr(count[1],(i * 8)), 0xff);
        }
        index = and(shr(count[0], 3) ,0x3f);
        padLen = (index < 56) ? (56 - index) : (120 - index);
        padding = new array(64);
        padding[0] = 0x80;
        for (i=0;i<padLen;i++)
          update(padding[i]);
        for (i=0;i<8;i++)
          update(bits[i]);

        for (i = 0; i < 4; i++) {
            for (j = 0; j < 4; j++) {
                digestBits[i*4+j] = and(shr(state[i], (j * 8)) , 0xff);
            }
        }
    }

/* Ende des MD5 Algorithmus */

function hexa(n) {
 var hexa_h = "0123456789abcdef";
 var hexa_c="";
 var hexa_m=n;
 for (hexa_i=0;hexa_i<8;hexa_i++) {
   hexa_c=hexa_h.charAt(Math.abs(hexa_m)%16)+hexa_c;
   hexa_m=Math.floor(hexa_m/16);
 }
 return hexa_c;
}


var ascii="01234567890123456789012345678901" +
          " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ"+
          "[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";

function MD5(nachricht)
{
 var l,s,k,ka,kb,kc,kd;

 init();
 for (k=0;k<nachricht.length;k++) {
   l=nachricht.charAt(k);
   update(ascii.lastIndexOf(l));
 }
 finish();
 ka=kb=kc=kd=0;
 for (i=0;i<4;i++) ka+=shl(digestBits[15-i], (i*8));
 for (i=4;i<8;i++) kb+=shl(digestBits[15-i], ((i-4)*8));
 for (i=8;i<12;i++) kc+=shl(digestBits[15-i], ((i-8)*8));
 for (i=12;i<16;i++) kd+=shl(digestBits[15-i], ((i-12)*8));
 s=hexa(kd)+hexa(kc)+hexa(kb)+hexa(ka);
 return s;
}
/* ==============================================
   === END FILE: public/inc/md5.js 
   ==============================================*/
/* ==============================================
   === FILE: public/inc/setup.js 
   ==============================================*/

      function on_data(xml_conn, element)
      {
         log_debug('on_data triggered'); 
         element.innerHTML = xml_conn.responseText; 
//         Sortable.create('workspace_components');
//         Sortable.create('left_column_components');
         // collapse hierarchy boxes
         collapsed_boxes = getCookie('collapsed_boxes'); 
         if(collapsed_boxes) {
           collapsed_boxes = collapsed_boxes.split('-'); 
           for(b=0; b<collapsed_boxes.length; b++) { 
             box_id = collapsed_boxes[b]; 
             if($(box_id)) { 
               Cuba.close_box(box_id); 
             }
           }
         }
         // display content
         Effect.Appear(element, {duration: 0.5}); 
         init_fun = Cuba.element_init_functions[element.id]
         if(init_fun) { init_fun(element); }
      }
      
      function app_load_interfaces(setup_name)
      {
        log_debug('in app_load_interface '+setup_name); 
//      document.getElementById('app_body').className = 'site_body_'+setup_name; 
        Cuba.load({ element: 'app_left_column', action: setup_name+'/left/', on_update: on_data }); 
        Cuba.load({ element: 'app_main_content', action: setup_name+'/main/',  on_update: on_data }); 
      }
      var active_button; 
      function app_load_setup(setup_name)
      {
        new Effect.Fade('app_left_column', {duration: 0.5}); 
        new Effect.Fade('app_main_content', {duration: 0.5}); 
        if(active_button) { 
          active_button.className = 'header_button';
        }
        active_button = document.getElementById('button_'+setup_name.replace('::','__')); 
        active_button.className = 'header_button_active';
        setTimeout(function() { app_load_interfaces(setup_name) }, 550); 
        
      }

      tinyMCE.init({
//    do not provide mode! Editor inits are handled event-based when needed. 
        plugins : 'paste, auritalink, auritacode, table',
        theme : "advanced",
        relative_urls : true,
        valid_elements : "*[*]",
        extended_valid_elements : "hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]",
        content_css : "/aurita/inc/editor_content.css",
        editor_css : "/aurita/inc/editor.css", 
        theme_advanced_styles : "Header 1=header1;Header 2=header2;Header 3=header3;Code=code", 
        theme_advanced_toolbar_align : "left", 
        theme_advanced_buttons1 : "bold,italic,underline,strikethrough,removeformat,bullist,numlist,insertDate,pastetext,unlink,preview", 
        theme_advanced_buttons1_add : 'auritalink,auritacode,table,formatselect',
        theme_advanced_buttons2 : "", 
        theme_advanced_buttons3 : "", 
        theme_advanced_toolbar_location : "top", 
        theme_advanced_resizing : true, 
        theme_advanced_resize_horizontal : false, 
        language : "de"
      });

      loading = new Image(); 
      loading.src = '/aurita/images/icons/loading.gif'; 

      Cuba.context_menu_draggable = new Draggable('context_menu', { starteffect: 0, endeffect: 0 } );
      new Draggable('dispatcher');

      Cuba.disable_context_menu_draggable = function() { 
        Cuba.context_menu_draggable.destroy(); 
      }
      Cuba.enable_context_menu_draggable = function() { 
        Cuba.context_menu_draggable = new Draggable('context_menu');
      }

      function interval_reload(elem_id, url, seconds)
      {
        setInterval(function() { if(!Cuba.update_targets) { Cuba.load({ element: elem_id, action: url, silently: true }) } }, seconds * 1000 );
      } 
//      interval_reload('changed_articles_body', 'Article/print_recently_changed/', 60); 
//      interval_reload('viewed_articles_body', 'Article/print_recently_viewed/', 20); 

      Cuba.check_hashvalue(); 

/* ==============================================
   === END FILE: public/inc/setup.js 
   ==============================================*/
