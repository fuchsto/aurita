/**
 * $Id: editor_plugin_src.js 162 2007-01-03 16:16:52Z spocke $
 *
 * @author Moxiecode
 * @copyright Copyright © 2004-2007, Moxiecode Systems AB, All rights reserved.
 */

/* Import plugin specific language pack */
tinyMCE.importPluginLanguagePack('advlink');

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
			case "link":
				return tinyMCE.getButtonHTML(cn, 'lang_link_desc', '{$themeurl}/images/link.gif', 'auritaLink');
		}

		return "";
	},

	execCommand : function(editor_id, element, command, user_interface, value) {
		switch (command) {
			case "auritaLink":
				tinyMCE.openWindow('/aurita/Wiki::Text_Asset/editor_link_dialog', {editor_id : editor_id, inline : "yes"});
//			        context_menu_handle.open({ url: 'Wiki::Text_Asset/editor_link_dialog', autoclose: false }); 

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
