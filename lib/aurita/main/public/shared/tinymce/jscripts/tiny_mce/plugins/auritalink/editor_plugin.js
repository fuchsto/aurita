/**
 * $Id: editor_plugin_src.js 162 2007-01-03 16:16:52Z spocke $
 *
 * @author Moxiecode
 * @copyright Copyright © 2004-2007, Moxiecode Systems AB, All rights reserved.
 */

/* Import plugin specific language pack */
tinyMCE.importPluginLanguagePack('auritalink');

var TinyMCE_AuritaLinkPlugin = {
	getInfo : function() {
		return {
			longname : 'aurita link',
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
				return tinyMCE.getButtonHTML(cn, 'lang_link_desc', '{$themeurl}/images/link.gif', 'auritalink');
		}

		return "";
	},

	execCommand : function(editor_id, element, command, user_interface, value) {
		switch (command) {
			case "auritalink":
				var anySelection = false;
				var inst = tinyMCE.getInstanceById(editor_id);
				var focusElm = inst.getFocusElement();
				var selectedText = inst.selection.getSelectedText();

				if (tinyMCE.selectedElement)
					anySelection = (tinyMCE.selectedElement.nodeName.toLowerCase() == "img") || (selectedText && selectedText.length > 0);

				if (anySelection || (focusElm != null && focusElm.nodeName == "A")) {
				   if(false) { 
              var template = new Array();

              template['file']   = '/aurita/Wiki::Text_Asset/editor_link_dialog/cb__mode=popup';
              template['width']  = 380;
              template['height'] = 400;

              tinyMCE.openWindow(template, {editor_id : editor_id, inline : "yes"});
				   }
				   else { 
              Cuba.temp_editor_id = editor_id; 
              Cuba.temp_editor_instance = inst; 
              Cuba.temp_selection = inst.selection;
              Cuba.temp_range = inst.selection.getRng();
              Cuba.temp_focus_element = inst.selection.getFocusElement(); 
              context_menu_handle.open({ url: 'Wiki::Text_Asset/editor_link_dialog/editor_id='+editor_id, 
                                         autoclose: false, 
                                         no_focus: true, 
                                         force_open: true, 
                                         init_fun: init_link_autocomplete_articles }); 
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
				tinyMCE.switchClass(editor_id + '_auritalink', 'mceButtonSelected');
				return true;
			}
		} while ((node = node.parentNode));

		if (any_selection) {
			tinyMCE.switchClass(editor_id + '_auritalink', 'mceButtonNormal');
			return true;
		}

		tinyMCE.switchClass(editor_id + '_auritalink', 'mceButtonDisabled');

		return true;
	}
};

tinyMCE.addPlugin("auritalink", TinyMCE_AuritaLinkPlugin);
