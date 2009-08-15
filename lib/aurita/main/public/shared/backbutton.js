
Cuba.app_domains = ['wortundform2.selfip.com']; 

Cuba.append_autocomplete_value = function(field_id, value) { 
  field = $(field_id); 
  fullvalue = field.value.replace(',', ' ').replace(/\s+/, ' '); 
  values = fullvalue.split(' '); 
  values.pop(); 
  values.push(value); 
  field.value = values.join(' '); 
  field.focus(); 
}

Cuba.get_ie_history_fix_iframe_code = function() 
{
  try { 
    // Requesting the src attribute is faster, as iframe does not have to be loaded, 
    // but this method is prohibited in most cases: 
    hashcode = parent.ie_fix_history_frame.location.href; 
    for(var i in Cuba.app_domains) {
      hashcode = hashcode.replace('http://'+Cuba.app_domains[i]+'/aurita/get_code.fcgi?code=',''); 
    }
  } catch(e) { 
    hashcode = parent.ie_fix_history_frame.get_code(); 
  }
  return hashcode; 
}


Cuba.last_hashvalue = ''; 
var home_loaded = false; 
wait_for_iframe_sync = '0'; 
Cuba.check_hashvalue = function() 
{
    current_hashvalue = document.location.hash.replace('#',''); 


    if(current_hashvalue.match(/(.+)?_anchor/)) { return;  } 

    if(Cuba.check_if_internet_explorer() == 1) { 
      iframe_hashvalue = Cuba.get_ie_history_fix_iframe_code(); 
      if(iframe_hashvalue != 'no_code' && iframe_hashvalue != current_hashvalue && !Cuba.force_load && iframe_hashvalue != '' && !iframe_hashvalue.match('about:')) { 
        current_hashvalue = iframe_hashvalue; 
      }
      if(document.location.hash != '#'+current_hashvalue) { document.location.hash = current_hashvalue; }
    }

    if(Cuba.force_load || current_hashvalue != Cuba.last_hashvalue && current_hashvalue != '') 
    { 
      window.scrollTo(0,0);

      Cuba.force_load = false; 
      log_debug("loading interface for "+current_hashvalue); 
      flush_editor_register(); 
      Cuba.last_hashvalue = current_hashvalue;

      if(current_hashvalue.match('article--')) { 
          aid = current_hashvalue.replace('article--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Wiki::Article/show/article_id='+aid, 
                      on_update: init_article }); 
      }
      else if(current_hashvalue.match('user--')) { 
          uid = current_hashvalue.replace('user--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Community::User_Profile/show_by_username/user_group_name='+uid }); 
      }
      else if(current_hashvalue.match('media--')) { 
          maid = current_hashvalue.replace('media--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Wiki::Media_Asset/show/media_asset_id='+maid }); 
      }
      else if(current_hashvalue.match('folder--')) { 
          mafid = current_hashvalue.replace('folder--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Wiki::Media_Asset_Folder/show/media_folder_id='+mafid }); 
      }
      else if(current_hashvalue.match('playlist--')) { 
          pid = current_hashvalue.replace('playlist--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Community::Playlist_Entry/show/playlist_id='+pid }); 
      }
      else if(current_hashvalue.match('video--')) { 
          vid = current_hashvalue.replace('video--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'App_Main/play_youtube_video/playlist_entry_id='+vid }); 
      }
      else if(current_hashvalue.match('find--')) { 
          pattern = current_hashvalue.replace('find--','').replace(/ /g,''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'App_Main/find/key='+pattern }); 
      }
      else if(current_hashvalue.match('find_full--')) { 
          pattern = current_hashvalue.replace('find_full--','').replace(/ /g,''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'App_Main/find_full/key='+pattern }); 
      }
      else if(current_hashvalue.match('topic--')) { 
          tid = current_hashvalue.replace('topic--',''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'Community::Forum_Topic/show/forum_topic_id='+tid }); 
      }
      else if(current_hashvalue.match('app--')) { 
          action = current_hashvalue.replace('app--','').replace('+','').replace(/ /g,''); 
          Cuba.load({ element: 'app_main_content', 
                      action: 'App_Main/'+action+'/' }); 
      }
      else if(current_hashvalue.match('calendar--')) { 
          action = current_hashvalue.replace('calendar--','').replace('+','').replace(/ /g,''); 
          if(action.substr(0,5) == 'day--') { 
            action = 'day/date=' + action.replace('day--','');
          }
          Cuba.load({ element: 'app_main_content', 
                      action: 'Calendar/'+action+'/' }); 
      }
      else {
        action = current_hashvalue.replace('--','/');
          // split hash into controller--action--param1--value1--param2--value2...
          Cuba.load({ element: 'app_main_content', 
                      action: action }); 
      }

    } 
}; 
window.setInterval(Cuba.check_hashvalue, 1000); 

function PageLocator(propertyToUse, dividingCharacter) {
    this.propertyToUse = propertyToUse;
    this.defaultQS = 1;
    this.dividingCharacter = dividingCharacter;
}
PageLocator.prototype.getLocation = function() {
    return eval(this.propertyToUse);
}
PageLocator.prototype.getHash = function() {
    var url = this.getLocation();
    if(url.indexOf(this.dividingCharacter) > -1) {
        var url_elements = url.split(this.dividingCharacter);
        return url_elements[url_elements.length-1];
    } else {
        return this.defaultQS;
    }
}
PageLocator.prototype.getHref = function() {
    var url = this.getLocation();
    var url_elements = url.split(this.dividingCharacter);
    return url_elements[0];
}
PageLocator.prototype.makeNewLocation = function(new_qs) {
    return this.getHref() + this.dividingCharacter + new_qs;
}




