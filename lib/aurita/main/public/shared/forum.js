
Cuba.show_toolbar_for = function(textarea) { 
  Element.setStyle(textarea.id+'_toolbar', { display: '' } ); 
}
Cuba.hide_toolbar_for = function(textarea) { 
  Element.setStyle(textarea.id+'_toolbar', { display: 'none' } ); 
}

Cuba.insert_at_cursor = function(textarea_element_id, text) { 
  textarea = $(textarea_element_id); 
  //IE 
  if (document.selection) {
    textarea.focus();
    sel = document.selection.createRange();
    sel.text = text;
  }
  //MOZILLA
  else if (textarea.selectionStart || textarea.selectionStart == 0) {
    var startPos = textarea.selectionStart;
    var endPos = textarea.selectionEnd;
    textarea.value = textarea.value.substring(0, startPos)
    + text
    + textarea.value.substring(endPos, textarea.value.length);
  } else {
    textarea.value += text;
  }
}

