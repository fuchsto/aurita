Aurita.GUI = { 

  init_left : function(element)
  {
     log_debug('init left'); 
     Aurita.GUI.collapse_boxes(); 
//   Sortable.create('left_column_components');
     Element.show(element); 
  }, 
  init_main : function(element)
  {
     log_debug('init main'); 
     Aurita.GUI.collapse_boxes(); 
//   Sortable.create('workspace_components');
     Element.show(element); 
  }, 
        
  load_layout : function(setup_name)
  {
    log_debug('load layout '+setup_name); 
    Aurita.load({ element: 'app_left_column', action: setup_name+'/left/', onload: function() { Element.show('app_left_column'); } } ); 
    Aurita.load({ action: setup_name+'/main/' }); 

    body_elem = $('app_body'); 
    body_elem.removeAttribute('class'); 
    body_elem.addClassName('site_body'); 
    body_elem.addClassName(setup_name); 
  }, 

  active_button : false, 
  switch_layout : function(setup_name)
  {
    Element.hide('app_left_column'); 
//    Element.hide('app_main_content'); 
    if(active_button) { 
      active_button.className = 'header_button';
    }

    active_button = document.getElementById('button_'+setup_name.replace('::','__')); 
    active_button.className = 'header_button_active';

    Aurita.GUI.load_layout(setup_name); 
    return; 

    setTimeout(function() { Aurita.GUI.load_layout(setup_name) }, 550); 
  }, 


  toggle_box : function(box_id) { 
    log_debug('toggling '+box_id); 

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
      log_debug('Slide down'); 
//    new Effect.SlideDown(box_id + '_body', { duration: 0.5 });
      Element.show(box_id + '_body'); 
    } else { 
      collapsed_boxes.push(box_id); 
      setCookie('collapsed_boxes', collapsed_boxes.join('-')); 
      $('collapse_icon_'+box_id).src = '/aurita/images/icons/plus.gif'
      log_debug('Slide up'); 
//    new Effect.SlideUp(box_id + '_body', { duration: 0.5 });
      Element.hide(box_id + '_body'); 
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
    var pos_top  = ((scroll_top + vph) - (elem_height/2)); 

    new Effect.Move(element_id, { 
      x: pos_left, 
      y: scroll_top + 50, 
//    y: 120, 
      mode: 'absolute', 
      afterFinish: function() { Element.show(element_id); }, 
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
  }, 

  init_sortable_components : function(container, params) { 
    params['format']   = /^component_(.+)$/;
    params['onUpdate'] = function(container) { 
      position_values = Sortable.serialize(container.id); 
      Aurita.call({ method: 'POST', 
                    action: 'Component_Position/set/'+position_values+'&context='+container.id }); 
    }
    Sortable.create(container, params)
  }, 

  Autocomplete : function(element_id, params) { 
    var elem_id       = element_id;
    var params        = params;
    var poll          = false; 
    var autocompleter = this; 
    var last_key      = '';

    $(elem_id).observe('click', function(evt) { 
    //  if (params.onfocus) { params.onfocus(); }
    
      // use variable autocompleter here to reference back 
      // to the original instance, as we are in a closure 
      // here. 
      autocompleter.active = true; 
      autocompleter.poll   = setInterval(function() { 
        tkey = Form.Element.getValue($(elem_id)); 
        if (tkey.length > 2 && autocompleter.last_key != tkey) {
          autocompleter.last_key = tkey; 
          call_action = params.action + 'key=' + tkey;
          if (params.onupdate) { params.onupdate(); }
          Aurita.load_silently({ action: call_action, 
                                 element: params.element, 
                                 method: 'POST', 
                                 onload: params.onload });
        }
      }, 400);
    });
    $(elem_id).observe('blur', function(evt) { 
      this.active = false; 
      clearInterval(poll);
      if (params.onblur) { params.onblur(); }
    });
  }, 

  Tooltip: Class.create({ 
    initialize: function(element, params) { 
      this.hover_elem = $(element); 
      this.box_elem   = $(params.tooltip); 

      this.hover_elem.observe('mouseover', this.show_box.bind(this));
      this.hover_elem.observe('mousemove', this.update_box_position.bind(this));
      this.hover_elem.observe('mouseout', this.hide_box.bind(this));
    }, 

    show_box : function(evt) { 
      this.box_elem.show(); 
    }, 
    update_box_position : function(evt) { 
      new Effect.Move(this.box_elem, { mode: 'absolute', 
                                       duration: 0,
                                       x: Event.pointerX(evt)-134, 
                                       y: Event.pointerY(evt)-60 });
    }, 
    hide_box : function(evt) { 
      this.box_elem.hide(); 
    }
  })

};

