
(function() { 

 tinymce.create('tinymce.plugins.AuritaFilePlugin', { 
   init: function(ed,url) {
     ed.addCommand('mceAuritaFile', function() {

			 var se = ed.selection;
       var bm = ed.selection.getBookmark();
       Aurita.Wiki.editor_selection_bookmark = bm; // Save to global for IE

       new Aurita.MessageBox({
          action: 'Wiki::Media_Asset/editor_insert_dialog', 
          draggable: true, 
          width: 600, 
          height: 400 }).load();  

     }); 
     ed.addButton('auritafile', { title: 'Datei', cmd: 'mceAuritaFile', image: url + '/img/file.gif' }); 
   },

   createControl: function(n, cm) { 
     return null; 
   }, 

   getInfo: function() { 
     return { 
       longname: 'Aurita File plugin', 
       author: 'Tobias Fuchs (twh.fuchs@gmail.com)', 
       authorurl: '', 
       infourl: '', 
       version: '0.5'
     }; 
   }
 }); 

 tinymce.PluginManager.add('auritafile', tinymce.plugins.AuritaFilePlugin); 

})(); 



