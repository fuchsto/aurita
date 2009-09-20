
tinyMCE.init({
  // do not provide mode! Editor inits are handled event-based when needed. 
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

Aurita.loading_icon = new Image(); 
Aurita.loading_icon.src = '/aurita/images/icons/loading.gif'; 

Aurita.context_menu_draggable = new Draggable('context_menu', { starteffect: 0, endeffect: 0 } );

Aurita.disable_context_menu_draggable = function() { 
  Aurita.context_menu_draggable.destroy(); 
}; 

Aurita.enable_context_menu_draggable = function() { 
  Aurita.context_menu_draggable = new Draggable('context_menu');
}; 

Aurita.poll_load = function(elem_id, url, seconds)
{
  setInterval(function() { 
    Aurita.load({ element: elem_id, action: url, silently: true }) 
  }, seconds * 1000);
}; 

Aurita.poll_call = function(elem_id, url, seconds)
{
  setInterval(function() { 
    Aurita.call({ element: elem_id, action: url, silently: true }) 
  }, seconds * 1000);
} 

Aurita.poll_load('users_online_box_body', 'App_General/users_online_box_body', 120); 

setInterval(function() { Aurita.check_hashvalue(); }, 300);
setInterval(function() { Aurita.poll_feedback(); }, 60000);

window.onload = function() { 
  Element.hide('cover'); 
  Aurita.GUI.collapse_boxes();  
}
