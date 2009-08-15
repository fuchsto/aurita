
function MessageBox(params)
{
    var m_interface = params['interface_url'];
    var m_content   = params['content']; 

    var fill_box = function(message_string) { 
      $('message_box').innerHTML = message_string; 
      show(); 
    };
    var show = function()
    {
      offset = (screen.width-(Element.getDimensions('message_box').width+1)) / 2; 
      Element.setStyle('message_box', { 'left': '50%' }); 
      Element.setStyle('message_box', { 'marginLeft': '-100px', 
                                        'left': '50%', 
                                        'top': '200px',
                                        'display': '' }); 
//      if(Browser.is_ie) { 
        scrollTo(0,0); 
//      }
    };
    
    this.open = function()
    {
//    new Effect.Appear('cover', { 'duration': 1, to: 0.5});
    if(m_content) { 
	    $('message_box').innerHTML = m_content; 
	    show(); 
    } else {
	    Cuba.get_remote_string(m_interface+'&mode=none', fill_box); 
    }
    m_opened = true; 
    new Draggable('message_box'); 
    };

    this.close = function() {
      $('message_box').innerHTML = ''; 
      Element.setStyle('message_box', { 'display': 'none' });
      Element.setStyle('cover', { 'display': 'none' }); 
    };

}
