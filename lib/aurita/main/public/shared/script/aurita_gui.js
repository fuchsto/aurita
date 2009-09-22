Aurita.GUI = { 

  init_left : function(element)
  {
     log_debug('init left'); 
     Aurita.GUI.collapse_boxes(); 
//   Sortable.create('left_column_components');
     Effect.Appear(element, {duration: 0.5}); 
  }, 
  init_main : function(element)
  {
     log_debug('init main'); 
     Aurita.GUI.collapse_boxes(); 
//   Sortable.create('workspace_components');
     Effect.Appear(element, {duration: 0.5}); 
  }, 
        
  load_layout : function(setup_name)
  {
    log_debug('load layout '+setup_name); 
    Aurita.load({ element: 'app_left_column', 
                  action: setup_name+'/left/', 
                  onload: Aurita.GUI.init_left }); 
    Aurita.load({ element: 'app_main_content', 
                  action: setup_name+'/main/', 
                  onload: Aurita.GUI.init_main }); 
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

    setTimeout(function() { Aurita.GUI.load_layout(setup_name) }, 550); 
  }, 


  toggle_box : function(box_id) { 
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
      new Effect.SlideDown(box_id + '_body', { duration: 0.5 });
    } else { 
      collapsed_boxes.push(box_id); 
      setCookie('collapsed_boxes', collapsed_boxes.join('-')); 
      $('collapse_icon_'+box_id).src = '/aurita/images/icons/plus.gif'
      new Effect.SlideUp(box_id + '_body', { duration: 0.5 });
    }
  }, 

  close_box : function(box_id) { 
    if($(box_id + '_body')) { 
      Element.hide(box_id + '_body'); 
      $('collapse_icon_'+box_id).src = '/aurita/images/icons/plus.gif'
    }
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

  calendar : false, 
  open_calendar : function(field_id, button_id)
  {
    log_debug('opening calendar'); 
    
    var onSelect = function(calendar, date) { 
      $(field_id).value = date; 
      if (calendar.dateClicked) {
          calendar.callCloseHandler(); // this calls "onClose" (see above)
      };
    }
    var onClose = function(calendar) { calendar.hide(); }; 

    Aurita.GUI.calendar = new Calendar(1, null, onSelect, onClose);
    Aurita.GUI.calendar.create(); 
    Aurita.GUI.calendar.showAtElement($(field_id), 'Bl'); 
  }, 


  set_dialog_link : function(url) { 
    plaintext = Aurita.temp_range.text; 
    url = 'http://' + url.replace('http://',''); 
    if(Aurita.check_if_internet_explorer() == '1') { 
      marker_key = 'find_and_replace_me';
      Aurita.temp_range.text = marker_key; 
      editor_html = Aurita.temp_editor_instance.getBody().innerHTML; 
      pos = editor_html.indexOf(marker_key); 
      if(pos != -1) { 
        Aurita.temp_editor_instance.getBody().innerHTML = editor_html.substring(0,pos) + '<a href="'+url+'" target="_blank">'+plaintext+'</a>' + editor_html.substring(pos+marker_key.length);
      }
    } 
    else 
    { 
      tinyMCE.execInstanceCommand(Aurita.temp_editor_id, 'mceInsertRawHTML', false, '<a href="'+url+'" target="_blank">'+Aurita.temp_range+'</a>');
    }
    Aurita.context_menu_close(); 
  }, 

  center_element : function(element_id) { 
    var d = document; 
    var rootElm = (d.documentelement && d.compatMode == 'CSS1Compat') ? d.documentelement : d.body

    var vpw = self.innerWidth ? self.innerWidth : rootElm.clientWidth; // viewport width 
    var vph = self.innerHeight ? self.innerHeight : rootElm.clientHeight; // viewport height 

    var elem_width  = $(element_id).getWidth(); 
    var elem_height = $(element_id).getHeight(); 

    var scroll_top = (window.pageYOffset)? window.pageYOffset : document.scrollTop; 

    var pos_left = ((vpw - elem_width) / 2); 
    var pos_top  = (scroll_top + (vph - elem_height)/2 ); 

    new Effect.Move(element_id, { 
      x: pos_left, 
      y: pos_top, 
      mode: 'absolute', 
      duration: 0
    });
  }, 
  
  reorder_hierarchy_id : false, 
  on_hierarchy_entry_reorder : function(entry)
  {
      position_values = Sortable.serialize(entry.id);
      Aurita.load_silently({ element: 'dispatcher', 
                             method: 'POST', 
                             action: 'Hierarchy/perform_reorder/' + position_values + '&hierarchy_id=' + reorder_hierarchy_id }); 
  }

};

