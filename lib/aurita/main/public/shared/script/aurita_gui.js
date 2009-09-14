Aurita.GUI = { 

  init_page : function(xml_conn, element)
  {
     log_debug('init page'); 
     element.innerHTML = xml_conn.responseText; 
  // Sortable.create('workspace_components');
  // Sortable.create('left_column_components');
      // collapse hierarchy boxes
     collapsed_boxes = getCookie('collapsed_boxes'); 
     if(collapsed_boxes) {
       collapsed_boxes = collapsed_boxes.split('-'); 
       for(b=0; b<collapsed_boxes.length; b++) { 
         box_id = collapsed_boxes[b]; 
         if($(box_id)) { 
           Aurita.GUI.close_box(box_id); 
         }
       }
     }
     // display content
     Effect.Appear(element, {duration: 0.5}); 
     if(init_fun) { init_fun(element); }
  }, 
        
  load_layout : function(setup_name)
  {
    log_debug('load layout '+setup_name); 
    Aurita.load({ element: 'app_left_column', 
                  action: setup_name+'/left/', 
                  on_update: Aurita.GUI.init_page }); 
    Aurita.load({ element: 'app_main_content', 
                  action: setup_name+'/main/', 
                  on_update: Aurita.GUI.init_page }); 
  }, 

  active_button : false, 
  switch_layout : function(setup_name)
  {
    new Effect.Fade('app_left_column', {duration: 0.5}); 
    new Effect.Fade('app_main_content', {duration: 0.5}); 
    if(active_button) { 
      active_button.className = 'header_button';
    }

    active_button = document.getElementById('button_'+setup_name.replace('::','__')); 
    active_button.className = 'header_button_active';

    setTimeout(function() { Aurita.GUI.load_layout(setup_name) }, 100); 
  }, 

  toggle_box : function(box_id) { 
    Element.toggle(box_id + '_body'); 
    collapsed_boxes = getCookie('collapsed_boxes'); 
    if(collapsed_boxes) { 
      collapsed_boxes = collapsed_boxes.split('-'); 
    } else { 
      collapsed_boxes = []; 
    }
    if($('collapse_icon_'+box_id).src.match('plus.gif')) { 
      $('collapse_icon_'+box_id).src = '/aurita/images/icons/minus.gif'
      box_id_string = ''
      for(b=0; b<collapsed_boxes.length; b++) {
        bid = collapsed_boxes[b]; 
        if(bid != box_id) { 
          box_id_string +=  bid + '-';
        }
      }
      setCookie('collapsed_boxes', box_id_string); 
    } else { 
      collapsed_boxes.push(box_id); 
      setCookie('collapsed_boxes', collapsed_boxes.join('-')); 
      $('collapse_icon_'+box_id).src = '/aurita/images/icons/plus.gif'
    }
  }, 

  close_box : function(box_id) { 
    Element.hide(box_id + '_body'); 
    $('collapse_icon_'+box_id).src = '/aurita/images/icons/plus.gif'
  }, 

  collapse_boxes : function() 
  {
     collapsed_boxes = getCookie('collapsed_boxes'); 
     if(collapsed_boxes) {
       collapsed_boxes = collapsed_boxes.split('-'); 
       for(b=0; b<collapsed_boxes.length; b++) { 
         box_id = collapsed_boxes[b]; 
         if($(box_id)) { 
           Aurita.GUI.close_box(box_id); 
         }
       }
     }
  }, 

  calendar : false; 
  open_calendar : function(field_id, button_id)
  {
    log_debug('opening calendar'); 
    
    var onSelect = function(calendar, date) { 
      document.getElementById(field_id).value = date; 
      if (calendar.dateClicked) {
          calendar.callCloseHandler(); // this calls "onClose" (see above)
      };
    }
    var onClose = function(calendar) { calendar.hide(); }
  }, 

  autocomplete_username_handler : function(text, li)
  {
    generic_id = text.id; 
  }

};

Aurita.GUI.calendar = new Calendar(1, null, onSelect, onClose);
Aurita.GUI.calendar.create(); 
Aurita.GUI.calendar.showAtElement(document.getElementById(field_id), 'Bl'); 
