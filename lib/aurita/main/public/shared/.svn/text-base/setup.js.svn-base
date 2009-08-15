
      function on_data(xml_conn, element)
      {
         log_debug('on_data triggered'); 
         element.innerHTML = xml_conn.responseText; 
         // collapse hierarchy boxes
         collapsed_boxes = getCookie('collapsed_boxes'); 
         if(collapsed_boxes) {
           collapsed_boxes = collapsed_boxes.split('-'); 
           for(b=0; b<collapsed_boxes.length; b++) { 
             box_id = collapsed_boxes[b]; 
             if($(box_id)) { 
               Cuba.close_box(box_id); 
             }
           }
         }
         // display content
         Effect.Appear(element, {duration: 0.5}); 
         init_fun = Cuba.element_init_functions[element.id]
         if(init_fun) { init_fun(element); }
      }
      
      function app_load_interfaces(setup_name)
      {
        log_debug('in app_load_interface '+setup_name); 
//      document.getElementById('app_body').className = 'site_body_'+setup_name; 
        cb__dispatch_interface('app_left_column',  '/aurita/'+setup_name+'/left',  on_data); 
        cb__dispatch_interface('app_main_content', '/aurita/'+setup_name+'/main',  on_data); 
      }
      var active_button; 
      function app_load_setup(setup_name)
      {
        alert('button_'+setup_name.replace('::', '__')); 
        new Effect.Fade('app_left_column', {duration: 0.5}); 
        new Effect.Fade('app_main_content', {duration: 0.5}); 
        if(active_button) { 
          active_button.className = 'header_button';
        }
        active_button = document.getElementById('button_'+setup_name.replace('::', '__')); 
        active_button.className = 'header_button_active';
        setTimeout(function() { app_load_interfaces(setup_name) }, 550); 

      }

      tinyMCE.init({
//    do not provide mode! Editor inits are handled event-based when needed. 
        plugins : 'paste, auritalink, auritacode, table',
        theme : "advanced",
        relative_urls : true,
        valid_elements : "*[*]",
        extended_valid_elements : "hr[class|width|size|noshade],font[face|size|color|style],span[class|align|style]",
        content_css : "/aurita/inc/editor_content.css",
        editor_css : "/aurita/inc/editor.css", 
        theme_advanced_styles : "Header 1=header1;Header 2=header2;Header 3=header3;Code=code", 
        theme_advanced_toolbar_align : "left", 
        theme_advanced_buttons1 : "bold,italic,underline,strikethrough,bullist,numlist,pastetext,unlink,preview,insertdatetime", 
        theme_advanced_buttons1_add : 'auritalink,auritacode,table,formatselect',
        theme_advanced_buttons2 : "", 
        theme_advanced_buttons3 : "", 
        theme_advanced_toolbar_location : "top", 
        theme_advanced_resizing : true, 
        theme_advanced_resize_horizontal : false
      });

      loading = new Image(); 
      loading.src = '/aurita/images/icons/loading.gif'; 

      Cuba.context_menu_draggable = new Draggable('context_menu', { starteffect: 0, endeffect: 0 );
      new Draggable('dispatcher');

      Cuba.disable_context_menu_draggable = function() { 
        Cuba.context_menu_draggable.destroy(); 
      }
      Cuba.enable_context_menu_draggable = function() { 
        Cuba.context_menu_draggable = new Draggable('context_menu');
      }

      function interval_reload(elem_id, url, seconds)
      {
        setInterval(function() { if(!Cuba.update_targets) { Cuba.load({ element: elem_id, action: url, silently: true }) } }, seconds * 1000 );
      } 
//    interval_reload('changed_articles_body', 'Article/print_recently_changed/', 60); 
//    interval_reload('viewed_articles_body', 'Article/print_recently_viewed/', 20); 

      Cuba.check_hashvalue(); 

