
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
