
Cuba.toggle_user_functions = function(result) 
{ 
  log_debug('toggling user functions'); 
  result = result.replace(' ','').replace("\n",''); 
  if(result.match('1') || result.match('2')) { 
    Element.show('button_App_Profile'); 
  } 
  if(result.match('2')) { 
    Element.show('button_App_Expert'); 
  }
  if(result.match('0') || result == '') { 
    Element.hide('button_App_Profile'); 
    Element.hide('button_App_Expert'); 
  }
}

Cuba.toggle_mail_notifier = function(result) 
{ 
  result = result.replace(' ','').replace("\n",''); 
  var new_mail = (result.lastIndexOf("0") == -1 && result != ''); 
  log_debug('new mail: '+ result+' -> '+new_mail); 
  if (new_mail) { 
    Element.setStyle('new_mail_notifier', { display: '' });
    $('unread_mail_amount').innerHTML = '(' + result + ')'; 
  } 
  else { 
    Element.setStyle('new_mail_notifier', { display: 'none' });
  }
}

Cuba.last_feedback = { }; 
Cuba.handle_feedback = function(response) 
{
  if(!response) return; 
  feedback = eval('('+response+')'); 

  if(feedback.unread_mail && Cuba.last_feedback.unread_mail != feedback.unread_mail) { 
    log_debug('-- unread_mail: '+feedback.unread_mail); 
    $('mail_notifier').innerHTML = feedback.unread_mail; 
  }
  if(feedback.random_image) { 
    if($('random_image') && Cuba.last_feedback.random_image != feedback.random_image) { 
      log_debug('-- random_image: '+feedback.random_image); 
      $('random_image').src = '/aurita/Wiki::Media_Asset/image/id='+feedback.random_image+'x=220'; 
    }
  }
  if(feedback.registered != undefined) { 
    if(feedback.registered != Cuba.last_feedback.registered) { 
      log_debug('-- user_registered'); 
      Cuba.load( { element: 'account_box', action: 'App_Main/account_box', silently: true }); 
      Cuba.load( { element: 'system_box', action: 'App_Main/system_box_body', silently: true }); 
      Cuba.get_remote_string('/aurita/User_Group/is_registered/cb__mode=none&rand='+Cuba.random(), Cuba.toggle_user_functions);
    }
  }
  if(feedback.recently_changed) { 
    if(!Cuba.last_feedback.recently_changed || 
       !Cuba.compare_arrays(Cuba.last_feedback.recently_changed, feedback.recently_changed)) { 
      log_debug('-- recently_changed'); 
      Cuba.load({ element: 'changed_articles_body', action: 'Wiki::Article/print_recently_changed/', nocache: true }); 
    }
  }
  if(feedback.recently_viewed) { 
    if(!Cuba.last_feedback.recently_viewed || 
       !Cuba.compare_arrays(Cuba.last_feedback.recently_viewed, feedback.recently_viewed)) { 
      log_debug('-- recently_viewed'); 
      Cuba.load({ element: 'viewed_articles_body', action: 'Wiki::Article/print_recently_viewed/', nocache: true }); 
    }
  }
  if(feedback.recently_viewed_media) { 
    if(!Cuba.last_feedback.recently_viewed_media || 
       !Cuba.compare_arrays(Cuba.last_feedback.recently_viewed_media, feedback.recently_viewed_media)) { 
      log_debug('-- recently_viewed_media'); 
      Cuba.load({ element: 'viewed_media_body', action: 'Wiki::Article/print_recently_viewed_media/', nocache: true }); 
    }
  }
  Cuba.last_feedback = feedback; 
}
Cuba.poll_feedback = function()
{
  Cuba.get_remote_string('Async_Feedback/get/cb__mode=none&'+Cuba.random(), Cuba.handle_feedback); 
}
setInterval(Cuba.poll_feedback, 15000); 
Cuba.poll_feedback(); 
