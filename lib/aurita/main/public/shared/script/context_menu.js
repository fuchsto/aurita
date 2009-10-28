
var context_menu_cache = {};  
var ie_right_click = false; 
function ContextMenu(menu_element_id, params)
{
    var m_menu = document.getElementById(menu_element_id);
    var m_active_element_id; 
    var m_highlight_element_id; 
    var m_focussed_element_id; 

    var m_opened = false; 
    var m_autoclose = true; 

    var m_interface;
    var m_clicked_element_id;
    var m_args; 

    var m_other_interface; 
    var m_other_clicked_element_id; 
    var m_other_args; 

    var m_params = params; 
    var m_no_focus = false; 

    var m_active   = true; 

    var m_init_fun = false; 

    this.is_opened = function() { return m_opened; };

    //////////////////////////////////////////////////////////////////
    var open_menu = function(params) {

        if(!params['force_open']) { 
          if(!m_clicked_element_id) { return; }
        //  if(!is_mouse_over($(m_clicked_element_id))) { return; }
        }
        m_init_fun = params.init_fun; 
        m_no_focus = params.no_focus; 
        m_menu.innerHTML = '<img src="/aurita/images/icons/loading.gif" border="0" />'; 
        Element.setOpacity(m_menu, 1.0); 
        Element.show(m_menu); 

        if(m_opened && m_clicked_element_id != m_active_element_id) { 
            close_menu(); // close old context menu
        } 
        else if(m_opened && m_clicked_element_id == m_active_element_id) {
            return; 
        }
        
        m_active_element_id = m_clicked_element_id; 
        
        m_autoclose = params['autoclose']; 
        if(params.targets) { m_update_targets = params.targets; }
        if(params.url)     { m_interface      = params.url; }

        m_interface += '&mode=none'; 
        if(context_menu_cache[m_interface]) { 
          log_debug('Loading context menu from cache'); 
          m_menu.innerHTML = context_menu_cache[m_interface];
          show(); 
          if(m_init_fun) m_init_fun(); 
        }
        else {
            m_menu.innerHTML = '<img src="/aurita/images/icons/loading.gif" border="0" />'; 
            
            var xml_conn = new XHConn; 
            params['onupdate'] = update_menu;
            xml_conn.connect(m_interface, 'GET', params['onupdate'], m_menu); 
        }
        m_opened = true; 

    }; 

    this.no_autoclose = function() { 
      m_autoclose = false; 
    }; 

    this.set = function(params) {     
       
      m_autoclose = params['autoclose']; 
      if(params.targets) { Aurita.update_targets = params.targets; }
      if(params.url)     { m_interface         = params.url; }

      m_interface += '&mode=none'
      m_menu.innerHTML = '<img src="/aurita/images/icons/loading.gif" border="0" />'; 

      var xml_conn = new XHConn; 
      if(!params['onupdate']) params['onupdate'] = update_menu;
      m_init_fun = params.init_fun; 
      m_no_focus = params.no_focus; 
      xml_conn.connect(m_interface, 'GET', params['onupdate'], m_menu); 
      
      m_opened = true; 
    };

    //////////////////////////////////////////////////////////////////
    var update_menu = function(xml_conn, element) {
      if(element) {
        response = xml_conn.responseText;
        
        abort = false; 
        if(response.length < 10) {
          stripped = response.replace(/^([\s|\n])+/g,'');
          if(stripped == '') { abort = true; }
        }
        if(abort) {
            Aurita.context_menu_close(); 
        } 
        else {
          show(); 
    
          element.innerHTML = response;
          context_menu_cache[m_interface] = response; 
          log_debug('menu init_fun: '+m_init_fun); 
          if(m_init_fun) m_init_fun(); 
        }
      }
    };

    var show = function() { 
      Element.setStyle(m_menu, { display: '' }); 
      if(m_clicked_element_id && !m_no_focus) { 
        if(!m_focussed_element_id) { 
          // Enable for focussing on context menu load (instead immediately on click)
          // focus_element(m_highlight_element_id); 
          // m_focussed_element_id = m_highlight_element_id; 
          log_debug('focussing ' + m_highlight_element_id); 
        } 
      }
    }; 
    
    //////////////////////////////////////////////////////////////////
    var close_menu = function() {
        if(m_opened) {
            // IE fix: 
            m_opened = false; 
            Element.setStyle(m_menu, { display: 'none' }); 
            unfocus_element(m_focussed_element_id); 
            $('context_menu').innerHTML = ''; 
        } 
    };
    this.open = function(params) { 
      params['url'] = '/aurita/'+params.url;
      log_debug('Opening context menu with interface '+params.url);
      log_debug('init_fun: '+params.init_fun); 
      open_menu(params);
    }; 

    this.close = function() { 
        close_menu(); 
    }; 

    this.enable = function() { 
       m_enabled = true;
    }; 
    this.disable = function() { 
       m_enabled = false;
    }; 
    this.activate = function() { 
       m_active = true;
    }; 
    this.deactivate = function() { 
       m_active = false;
    }; 
    this.is_active = function() { 
      return m_active; 
    }
    this.is_opened = function() { 
       return m_opened; 
    }; 

    //////////////////////////////////////////////////////////////////
    this.element_hover = function(type, args, elem_id, highlight_element_id) {
      if(highlight_element_id) m_highlight_element_id = highlight_element_id; 
      else m_highlight_element_id = elem_id; 
      type_parts = type.split('::'); 
      context_menu_controller = ''; 
      if(type_parts.length > 1) { 
        context_menu_controller = type_parts[0] + '::Context_Menu'; 
        type = type_parts[1].toLowerCase(); 
      } else {
        context_menu_controller = 'Context_Menu'; 
      }
      m_clicked_element_id = elem_id; 
      m_args = args; 
      m_interface = '/aurita/'+context_menu_controller+'/'+type.toLowerCase()+'/'+args;
    };

    //////////////////////////////////////////////////////////////////
    this.handle_click = function(ev, is_right_click) {
      if(!m_active) { return true; }
      if(!ev) { ev = window.event; }
    // ?  var is_right_click = false; 
      if(ev) { 
        if(ev.button && ev.button == 2) { is_right_click = true; }
        if(ev.which && ev.which == 3)   { is_right_click = true; }
        if(ie_right_click)              { is_right_click = true; ie_right_click = false; }
      }
      
      capture_mouse(ev); 

      if(m_opened && m_autoclose == true && !is_mouse_over(m_menu)) {
        close_menu(); 
      }
      
      if(ie_right_click || is_right_click || Aurita.enable_left_click_menu) {

          Aurita.enable_left_click_menu = false; 

          mouse_coords = get_mouse(ev); 
          Element.setStyle('context_menu', { left: mouse_coords[0]+'px', top: mouse_coords[1]+'px', display: '' }); 
          
          unfocus_element(m_focussed_element_id); 
          m_focussed_element_id = m_highlight_element_id; 

          if(m_opened && m_other_clicked_element_id != undefined) {
            m_clicked_element_id = m_other_clicked_element_id; 
            m_args       = m_other_args; 
            m_interface  = m_other_interface; 
          }
          if(m_enabled) { 
            focus_element(m_highlight_element_id); 
            m_focussed_element_id = m_highlight_element_id; 
            open_menu({ autoclose: true }); 
          } else { 
            Element.hide(m_menu); 
          }
          return false; 
      } else { 
        if(window.event) { 
          // return true if default action is to be performed, false otherwise:
          prevent_click = Aurita.prevent_default_onclick; 
          Aurita.prevent_default_onclick = false; 
          return !prevent_click; 
        } 
        else { 
          return true
        }
      }
    };

    this.handle_key = function(ev) { 

      if(!m_opened && ev.which == 109) { // only act on char 'm'
          m_menu.style.left = mouse_x;
          m_menu.style.top = mouse_y;
          
          if(m_opened && m_other_clicked_element_id != undefined) {
          m_clicked_element_id = m_other_clicked_element_id; 
          m_args       = m_other_args; 
          m_interface  = m_other_interface; 
          }
          open_menu({ autoclose: true }); 
      }
    };

    return this; 
}
Aurita.context_menu = new ContextMenu('context_menu'); 

Aurita.enable_left_click_menu = false; 

Aurita.context_menu_click = function(params)
{
    Aurita.context_menu.no_autoclose(); 
    Element.hide('context_menu'); 
    Aurita.load({ element: 'context_menu', 
                  action: params.url, 
                  onload: function() { Aurita.GUI.center_element('context_menu'); } }); 
}; 

Aurita.context_menu_close = function()
{
    Aurita.context_menu.close(); 
    if(Aurita.message_box) { 
      Aurita.message_box.close();
    } 
}; 

// Function to use on elements providing a 
// context menu (onMouseOver). Sets states for 
// context menu to be opened on right-click, but 
// doesn't open it itself. 
Aurita.last_hovered = false; 
Aurita.context_menu_over = function(type, args, elem_id, highlight_element_id) 
{
  Aurita.context_menu.element_hover(type, args, elem_id, highlight_element_id); 

  if(Aurita.last_hovered) { 
    Element.removeClassName(Aurita.last_hovered, 'context_hover'); 
  }
  if(highlight_element_id) { elem_id = highlight_element_id; } 

  if(!Aurita.context_menu_opened()) { 
    Element.addClassName(elem_id, 'context_hover'); 
    if($(elem_id+'_wrap')) { 
      Element.show(elem_id+'_wrap'); 

      if(Aurita.last_hovered != elem_id && $(Aurita.last_hovered+'_wrap')) { 
        Element.hide(Aurita.last_hovered+'_wrap'); 
      }
    }
  }
  Aurita.last_hovered = elem_id; 
  Aurita.context_menu.enable(); 
}; 

Aurita.context_menu_opened = function() { 
  return Aurita.context_menu.is_opened(); 
}; 

Aurita.context_menu_out = function(element) 
{ 
  Aurita.context_menu.disable(); 
  Element.removeClassName(Aurita.last_hovered, 'context_hover'); 
  if($(Aurita.last_hovered+'_wrap')) { 
    Element.hide(Aurita.last_hovered+'_wrap'); 
    Aurita.enable_left_click_menu = false; 
  }
}; 

Aurita.open_context_menu = function() { 
  Aurita.enable_left_click_menu = true; 
  Aurita.context_menu.handle_click(false, true); 
};


