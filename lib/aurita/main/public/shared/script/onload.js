
try { 

  tinyMCE.init({
    // do not provide mode! Editor inits are handled event-based when needed. 
    mode: 'specific_textareas', 
    editor_selector : "full", 
    plugins : "autoresize,safari,spellchecker,table,iespell,inlinepopups,insertdatetime,fullscreen,visualchars,xhtmlxtras,auritalink,auritafile,link",
    theme : "advanced",
    relative_urls : true,
    valid_elements : "*[*]",
    extended_valid_elements : "hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]",
    content_css : "/aurita/shared/editor_content_full.css",
    theme_advanced_styles : "Header 1=header1;Header 2=header2;Header 3=header3;Code=code", 
    theme_advanced_toolbar_align : "left", 
    theme_advanced_buttons1 : "bold,italic,underline,strikethrough,|,justifyleft,justifycenter,justifyright,|,formatselect,removeformat,|,insertdate,inserttime,|,forecolor,backcolor,auritalink,unlink", 
    theme_advanced_buttons2 : "auritafile,bullist,numlist,outdent,indent,|,tablecontrols,|,hr,fullscreen,code", 
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
    content_css : "/aurita/shared/editor_content_simple.css",
    theme_advanced_styles : "Header 1=header1;Header 2=header2;Header 3=header3;Code=code", 
    theme_advanced_toolbar_align : "left", 
    theme_advanced_buttons1 : "bold,italic,underline,strikethrough,removeformat,|,bullist,numlist,|,insertdate,inserttime,|,forecolor,backcolor", 
    theme_advanced_buttons2 : "", 
    theme_advanced_buttons3 : "", 
    theme_advanced_toolbar_location : "top", 
    theme_advanced_resizing : false, 
    auto_resize : false,
    language : "de"

  });

} catch(e) { 
  log_debug("Error when trying to load tinyMCE: " + e); 
}


Aurita.on_page_load = function() { 
  try { 
    Aurita.loading_icon = new Image(); 
    Aurita.loading_icon.src = '/aurita/images/icons/loading.gif'; 

    Aurita.context_menu_draggable = new Draggable('context_menu', { starteffect: 0, endeffect: 0 } );

    Aurita.disable_context_menu_draggable = function() { 
      Aurita.context_menu_draggable.destroy(); 
    }; 

    Aurita.enable_context_menu_draggable = function() { 
      Aurita.context_menu_draggable = new Draggable('context_menu');
    }; 

    Aurita.poll_load('users_online_box_body', 'App_General/users_online_box_body', 120); 
  } 
  catch(e) { } 

  setInterval(function() { Aurita.check_hashvalue(); }, 300);
  setInterval(function() { Aurita.poll_feedback(); }, 60000);

  try { 
    Element.hide('cover'); 
    Aurita.GUI.collapse_boxes();  
  } catch(e) { 
  }

//  new Draggable('message_box'); 
  if($('debug_box')) { 
    new Draggable('debug_box', { handle: 'debug_toolbar', starteffect: 0, endeffect: 0 } );
  }
  try { 
  new accordion('app_left_column', { 
                   classNames: { 
                     content: 'accordion_box_body', 
                     toggle: 'accordion_box_header', 
                     toggleActive: 'accordion_box_header_active' 
                   } 
                });
  } catch(e) { } 

  function custom_autocomplete_onupdate() { 
    Element.hide('indicator');
    Element.show('indicator_');
    Element.setStyle('autocomplete_choices', { width: '419px', top: '25px', left: '-200px' }); 
    Element.show('autocomplete_choices');
  }
  function custom_autocomplete() { 
    Element.show('indicator');
    Element.hide('indicator_');
    Aurita.load_silently({ action: 'Autocomplete/all/key='+($('autocomplete').value), 
                           element: 'autocomplete_choices', 
                           onload: custom_autocomplete_onupdate });
  };


  function show_article(text, li)
  {
    generic_id = text.id; 
    req_parts = generic_id.split('__'); 

    if(generic_id.match('find_all__')) {	
      tag = generic_id.replace('find_all__','');
      Aurita.load({ action: 'App_Main/find_all/key='+tag }); 
    }
    else if(generic_id.match('find_full__')) {	
      tag = generic_id.replace('find_full__','');
      Aurita.load({ action: 'App_Main/find_full/key='+tag }); 
    }
    else { 
      if(req_parts[0] == 'url') { 
        req_url = req_parts[1]; 
        window.open(req_url);
        return; 
      }
      else { 
        if(req_parts[2]) { 
          req_url = (req_parts[0] + '::' + req_parts[1] + '/show/id=' + req_parts[2]); 
          Aurita.load({ action: req_url }); 
        }
        else { 
          req_url = (req_parts[0] + '/show/id=' + req_parts[1]); 
          Aurita.load({ action: req_url }); 
        }
      } 
    }
  }

  function fix_rollout(element, query) { 
    Element.setStyle('autocomplete_choices', { width: '419px', top: '29px', left: '-200px' }); 
    Element.setOpacity('autocomplete_choices', 1.0);
    return query; 
  }

  if($('autocomplete')) { 
    new Ajax.Autocompleter("autocomplete", 
                           "autocomplete_choices", 
                           "/aurita/poll", 
                           { 
                             minChars: 2, 
                             updateElement: show_article, 
                             indicator: 'indicator', 
                             tokens: [], 
                             frequency: 0.2, 
                             callback: fix_rollout, 
                             parameters: 'controller=Autocomplete&action=all&mode=none'
                           }
    );
  }

  Aurita.init_page(); // Calls onload scripts defined in decorator
} 

window.onload = Aurita.on_page_load; 


