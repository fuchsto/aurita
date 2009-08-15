
Cuba.toggle_box = function(box_id) { 
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
}; 
Cuba.close_box = function(box_id) { 
  Element.hide(box_id + '_body'); 
  $('collapse_icon_'+box_id).src = '/aurita/images/icons/plus.gif'
}; 

