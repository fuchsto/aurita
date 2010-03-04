/* For tinymce version 2.x: 

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
*/

(function() { 

 tinymce.create('tinymce.plugins.AuritaLinkPlugin', { 
   init: function(ed,url) {
     ed.addCommand('mceAuritaLink', function() {

			 var se = ed.selection;
       // No selection and not in link
       if (se.isCollapsed() && !ed.dom.getParent(se.getNode(), 'A')) { return; }

       new Aurita.MessageBox({
          action: 'Wiki::Text_Asset/editor_link_dialog', 
          width: 300, 
          draggable: true, 
          height: 200 }).load();  
     }); 
     ed.addButton('auritalink', { title: 'Link', cmd: 'mceAuritaLink', image: url + '/img/link.gif' }); 
     ed.onNodeChange.add(function(ed, cm, n) { 
       cm.setActive('auritalink', n.nodeName == 'A'); 
     }); 
   },

   createControl: function(n, cm) { 
     return null; 
   }, 

   getInfo: function() { 
     return { 
       longname: 'Aurita Link plugin', 
       author: 'Tobias Fuchs (twh.fuchs@gmail.com)', 
       authorurl: '', 
       infourl: '', 
       version: '0.5'
     }; 
   }
 }); 

 tinymce.PluginManager.add('auritalink', tinymce.plugins.AuritaLinkPlugin); 

})(); 



