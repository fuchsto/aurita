/**
 * $Id: editor_plugin_src.js 162 2007-01-03 16:16:52Z spocke $
 *
 * @author Moxiecode
 * @copyright Copyright © 2004-2007, Moxiecode Systems AB, All rights reserved.
 */

/* Import plugin specific language pack */
tinyMCE.importPluginLanguagePack('auritacode');

var TinyMCE_AuritaCodePlugin = {
  getInfo : function() {
    return {
      longname : 'aurita code',
      author : 'Tobias Fuchs',
      authorurl : 'www.wortundform.d',
      infourl : '',
      version : tinyMCE.majorVersion + "." + tinyMCE.minorVersion
    };
  },

  initInstance : function(inst) {
  },

  getControlHTML : function(cn) {
    switch (cn) {
      case "auritalink":
        return tinyMCE.getButtonHTML(cn, 'lang_code_desc', '{$themeurl}/images/sup.gif', 'auritacode');
    }

    return "";
  },

  execCommand : function(editor_id, element, command, user_interface, value) {
    switch (command) {
      case "auritacode":
        var anySelection = false;
        var inst = tinyMCE.getInstanceById(editor_id);
        var focusElm = inst.getFocusElement();
        var selectedText = inst.selection.getSelectedText();

        if (tinyMCE.selectedElement)
          anySelection = (tinyMCE.selectedElement.nodeName.toLowerCase() == "img") || (selectedText && selectedText.length > 0);

        if (anySelection || (focusElm != null && focusElm.nodeName == "A")) 
        {
          Cuba.temp_editor_id = editor_id; 
          Cuba.temp_editor_instance = inst; 
          Cuba.temp_selection = inst.selection;
          Cuba.temp_range = inst.selection.getRng();
          Cuba.temp_focus_element = inst.selection.getFocusElement(); 

          plaintext = Cuba.temp_range.text; 
          if(Cuba.check_if_internet_explorer() == '1') 
          { 
            marker_key = 'find_and_replace_me';
            Cuba.temp_range.text = marker_key; 
            editor_html = Cuba.temp_editor_instance.getBody().innerHTML; 
            pos = editor_html.indexOf(marker_key); 
            if(pos != -1) 
            { 
              Cuba.temp_editor_instance.getBody().innerHTML = editor_html.substring(0,pos) + '<pre>'+plaintext+'</pre>' + editor_html.substring(pos+marker_key.length);
            }
          } 
          else 
          { 
            tinyMCE.execInstanceCommand(Cuba.temp_editor_id, 'mceInsertRawHTML', false, '<pre>'+plaintext+'</pre>');
          }
        }
        return true;
    }
    return false;
  },

  handleNodeChange : function(editor_id, node, undo_index, undo_levels, visual_aid, any_selection) {
    if (node == null)
      return;
    do {
      if (node.nodeName == "A" && tinyMCE.getAttrib(node, 'href') != "") {
        tinyMCE.switchClass(editor_id + '_auritacode', 'mceButtonSelected');
        return true;
      }
    } while ((node = node.parentNode));

    if (any_selection) {
      tinyMCE.switchClass(editor_id + '_auritacode', 'mceButtonNormal');
      return true;
    }

    tinyMCE.switchClass(editor_id + '_auritacode', 'mceButtonDisabled');

    return true;
  }
};

tinyMCE.addPlugin("auritacode", TinyMCE_AuritaLinkPlugin);
