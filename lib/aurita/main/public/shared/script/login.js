
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
      document.location.href = '/aurita/App_Main/start/';
    }
  },

  remote_login: function(login, pass)
  {
    login = MD5(login); 
    pass  = MD5(pass); 
    Aurita.get_remote_string('App_Main/validate_user/mode=async&login='+login+'&pass='+pass, Login.check_success); 
  }

} // Namespace Login
