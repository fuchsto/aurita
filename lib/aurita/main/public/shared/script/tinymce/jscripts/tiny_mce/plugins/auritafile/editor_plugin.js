
(function() { 

 tinymce.create('tinymce.plugins.AuritaFilePlugin', { 
   init: function(ed,url) {
     ed.addCommand('mceAuritaFile', function() {

			 var se = ed.selection;

       new Aurita.MessageBox({
          action: 'Wiki::Media_Asset/editor_insert_dialog', 
          draggable: false, 
          width: 600, 
          height: 400 }).load();  

     }); 
     ed.addButton('auritafile', { title: 'Datei', cmd: 'mceAuritaFile', image: url + '/img/file.gif' }); 
     ed.onNodeChange.add(function(ed, cm, n) { 
   //  cm.setActive('auritafile', n.nodeName == 'A'); 
     }); 
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



