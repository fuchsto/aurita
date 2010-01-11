
Aurita.Editor = { 

  tinyMCE : tinyMCE, 
  registered_editors : {}, 

  flush_all : function() {
    log_debug('Aurita.Editor.flush_register');
    for(var editor_id in Aurita.Editor.registered_editors) {
      try { 
        Aurita.Editor.flush(editor_id);     
      } catch(e) { 
        log_debug('Exception in Aurita.Editor.flush_all('+editor_id+'): '+e.message); 
      }
    }
    Aurita.Editor.registered_editors = {}; 
  }, 

  init : function(textarea_element_id) 
  {
    if(!$(textarea_element_id)) { log_debug('No element'); return; }
    if(!Aurita.Editor.registered_editors[textarea_element_id] || 
        Aurita.Editor.registered_editors[textarea_element_id] == null) 
    { 
      if(Element.hasClassName(textarea_element_id, 'saving')) { 
        log_debug('Editor ' + textarea_element_id + ' is saving, skipping init'); 
        return; 
      }
      log_debug('Aurita.Editor.init ' + textarea_element_id); 
      Aurita.Editor.registered_editors[textarea_element_id] = textarea_element_id; 
      try { 
        Element.setStyle(textarea_element_id, { visibility: true }); 
      } catch(e) { 
        log_debug('Exception in Aurita.Editor.init: ' + e.message); 
      }
      if(Element.hasClassName(textarea_element_id, 'full')) { 
        Aurita.Editor.switch_mode_full(); 
      }
      if(Element.hasClassName(textarea_element_id, 'simple')) { 
        Aurita.Editor.switch_mode_simple(); 
      }
      tinyMCE.execCommand('mceAddControl', false, textarea_element_id); 
    }
    else { 
      log_debug('Editor already in register, skipping init'); 
    }
  }, 

  save : function(textarea_element_id) 
  {
    if(!$(textarea_element_id)) { log_debug('No element'); return; }
    if(Aurita.Editor.registered_editors[textarea_element_id] &&
       Aurita.Editor.registered_editors[textarea_element_id] != null) 
    { 
      log_debug('Aurita.Editor.save ' + textarea_element_id); 
      Element.addClassName(textarea_element_id, 'saving');
  //  tinyMCE.execInstanceCommand(textarea_element_id,'mceCleanup');
      tinyMCE.triggerSave(false,true);
      Element.setStyle(textarea_element_id, { visibility: 'hidden' }); 
      tinyMCE.execCommand('mceRemoveControl', false, textarea_element_id);
    }
    else { 
      log_debug('Editor not in register, skipping save'); 
    }
  }, 

  flush : function(textarea_element_id)
  {
    if(!$(textarea_element_id)) { log_debug('No element'); return; }
    if(Aurita.Editor.registered_editors[textarea_element_id] &&
       Aurita.Editor.registered_editors[textarea_element_id] != null) 
    { 
      log_debug('Aurita.Editor.flush ' + textarea_element_id); 
      Element.addClassName(textarea_element_id, 'saving');
      Aurita.Editor.registered_editors[textarea_element_id] = null; 

      Element.setStyle(textarea_element_id, { visibility: 'hidden' }); 
      log_debug('flushing '+textarea_element_id); 
  //  tinyMCE.execInstanceCommand(textarea_element_id,'mceCleanup');
      tinyMCE.triggerSave(false,true);
      tinyMCE.execCommand('mceRemoveControl', false, textarea_element_id);
      tinyMCE.triggerSave(false, true);
    } 
    else { 
      log_debug('Editor not in register, skipping flush'); 
    }
  },

  init_all : function(element) {
//   try { 
      // Could be necessary: 
//    Aurita.Editor.flush_all(element); 
      log_debug('Aurita.Editor.init_all'); 
      elements = document.getElementsByTagName('textarea');
      if(!elements || elements == undefined || elements == null) { 
        log_debug('elements in init_all_editors is undefined'); 
        return; 
      }
      if(elements == undefined || !elements.length) { 
        log_debug('Error: elements.length in init_all_editors is undefined'); 
        return; 
      }
      for (var i = 0; i < elements.length; i++) {
        elem_id = elements.item(i).id; 
        log_debug('entry in register for '+elem_id+': '+Aurita.Editor.registered_editors[elem_id]); 
        if(Aurita.Editor.registered_editors[elem_id] == null) { 
          log_debug('Found textarea to initialize: ' + elem_id);
          inst = $(elem_id); 
          if(inst && Element.hasClassName(inst, 'editor')) { Aurita.Editor.init(elem_id); }
        }
      }
//   } catch(e) { 
//     log_debug('Catched Exception in Aurita.Editor.init_all:' + e.message); 
//     return; 
//   }
  }, 

  save_all : function(element) {
//    try { 
      var inst = false; 
      log_debug('Aurita.Editor.save_all'); 
      Aurita.Editor.flush_all(); 
      elements = document.getElementsByTagName('textarea');
      if(!elements || elements == undefined || elements == null) { 
        log_debug('No textareas found in document, nothing to save. '); 
        return; 
      }
      for (var i = 0; i < elements.length; i++) {
        elem_id = elements.item(i).id; 
          inst = $(elem_id);
        if(inst && Element.hasClassName(inst, 'editor')) { 
          Aurita.Editor.save(elem_id); 
        }
      }
//    } catch(e) { 
//      log_debug('Catched Exception in Aurita.Editor.save_all: ' + e); 
//      return; 
//    }
  }, 

  switch_mode_full : function() { 
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
      theme_advanced_buttons2 : "auritafile,bullist,numlist,outdent,indent,|,tablecontrols,|,hr,fullscreen", 
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
  }, 

  switch_mode_simple : function() { 
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
  }

}; 
