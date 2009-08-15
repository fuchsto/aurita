
var Login = { 

  check_success: function(success)
  {
    var failed = true; 

    if(success != "\n0\n") 
    { 
      user_params = eval(success); 
      if(user_params.session_id) {
        setCookie('cb_login', user_params.session_id, 0, '/'); 
        failed = false; 
      }
    }
    if(failed) 
    {
      new Effect.Shake('login_box'); 
    }
    else { 
      new Effect.Fade('login_box', {queue: 'front', duration: 1}); 
//    new Effect.Appear('start_button', {queue: 'end', duration: 1}); 
      document.location.href = '/aurita/';
    }
  },

  remote_login: function(login, pass)
  {
    login = MD5(login); 
    pass  = MD5(pass); 
    cb__get_remote_string('/aurita/App_Main/validate_user/cb__mode=dispatch&login='+login+'&pass='+pass, Login.check_success); 
  }

} // Namespace Login

var Aurita = {

    last_username: '', 
    username_input_element: '0',

    check_username_available: function(result) { 
	if(result.match('true')) { 
	    Element.setStyle(Aurita.username_input_element, { 'border-color': '#00ff00' });
	} else { 
	    Element.setStyle(Aurita.username_input_element, { 'border-color': '#ff0000' });
	}
    },

    username_available: function(input_element) { 
	if(input_element.value == Aurita.last_username) { return; }
	Aurita.username_input_element = input_element; 
	Aurita.last_username = input_element.value; 
	cb__get_remote_string('/aurita/RBAC::User_Group/username_available/cb__mode=dispatch&user_group_name='+input_element.value, Aurita.check_username_available);
    }

} // namespace Aurita
