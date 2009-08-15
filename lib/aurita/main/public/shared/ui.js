

Aurita.center_element = function(element_id) { 
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
    duration: 0.5
  });
}
