
Aurita.message_box = false;  
Aurita.MessageBox = function(params)
{
    var m_action       = params['action'];
    var m_content      = params['content']; 
    var m_is_draggable = (params['draggable'] != false); 
    var m_draggable    = false; 

    var fill_box = function(message_string) { 
      $('message_box').innerHTML = message_string; 
      show(); 
    };
    var show = function()
    {
      $('message_box').show(); 
      Aurita.GUI.center_element('message_box');
      Aurita.message_box = this;
      if(m_is_draggable) { 
        m_draggable = new Draggable('message_box'); 
      }
    };
    
    this.open = function()
    {
      if(m_content) { 
        $('message_box').innerHTML = m_content; 
        show(); 
      } else {
        Aurita.get_remote_string(m_action, fill_box); 
      }
      m_opened = true; 
      if(Aurita.message_box) { 
        Aurita.message_box.close(); 
      }
      if(m_is_draggable) { 
        m_draggable = new Draggable('message_box'); 
      }
      Aurita.message_box = this;
    };

    this.load = function() { 
      Aurita.load({ action: m_action, 
                    element: 'message_box', 
                    silently: true, 
                    onload: function() { 
                      Aurita.message_box = this;
                      Aurita.GUI.center_element('message_box');
                      $('message_box').show(); 
                    }});
    };

    this.close = function() {
      $('message_box').innerHTML = ''; 
      Element.setStyle('message_box', { 'display': 'none' });
      if(m_draggable) { 
        m_draggable.destroy(); 
      }
    };

}
