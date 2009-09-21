
tinyMCE.init({
  // do not provide mode! Editor inits are handled event-based when needed. 
  mode: 'specific_textareas', 
  editor_selector : "full", 
  plugins : "autoresize,safari,spellchecker,table,iespell,inlinepopups,insertdatetime,fullscreen,visualchars,xhtmlxtras",
  theme : "advanced",
  relative_urls : true,
  valid_elements : "*[*]",
  extended_valid_elements : "hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]",
  content_css : "/aurita/shared/editor_content.css",
  theme_advanced_styles : "Header 1=header1;Header 2=header2;Header 3=header3;Code=code", 
  theme_advanced_toolbar_align : "left", 
  theme_advanced_buttons1 : "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,|,formatselect,removeformat,|,insertdate,inserttime,|,forecolor,backcolor", 
  theme_advanced_buttons2 : "tablecontrols,|,hr,fullscreen", 
  theme_advanced_buttons3 : "", 
  theme_advanced_toolbar_location : "top", 
  theme_advanced_resizing : false, 
  auto_resize : true,
  language : "de", 
  setup : function(editor) { 
    editor.addButton('aurita_save', { 
                      title : 'Speichern', 
                      image : '/aurita/images/icons/editor_save.gif', 
                      onclick : function() { 
                        Aurita.submit_form('container_form_xxxx'); 
                      }
    }); 
    editor.addButton('aurita_cancel', { 
                      title : 'Abbrechen', 
                      image : '/aurita/images/icons/editor_cancel.gif', 
                      onclick : function() { 
                        Aurita.Editor.save_all(); 
                        Aurita.load({ action : 'Wiki::Article/show/article_id=xxxx' });  
                      }
    }); 
  }

});
tinyMCE.init({
  mode: 'specific_textareas', 
  editor_selector : "simple", 
  plugins : "safari,spellchecker,table,iespell,inlinepopups,insertdatetime,fullscreen,visualchars,xhtmlxtras",
  theme : "advanced",
  relative_urls : true,
  valid_elements : "*[*]",
  extended_valid_elements : "hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]",
  content_css : "/aurita/shared/editor_content.css",
  theme_advanced_styles : "Header 1=header1;Header 2=header2;Header 3=header3;Code=code", 
  theme_advanced_toolbar_align : "left", 
  theme_advanced_buttons1 : "bold,italic,underline,strikethrough,removeformat,|,insertdate,inserttime,|,forecolor,backcolor", 
  theme_advanced_buttons2 : "", 
  theme_advanced_buttons3 : "", 
  theme_advanced_toolbar_location : "top", 
  theme_advanced_resizing : false, 
  auto_resize : false,
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
