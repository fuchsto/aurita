/** XHConn - Simple XMLHTTP Interface - bfults@gmail.com - 2005-04-08        **
 ** Code licensed under Creative Commons Attribution-ShareAlike License      **
 ** http://creativecommons.org/licenses/by-sa/2.0/                           **/
function XHConn()
{
  var xmlhttp, bComplete = false;

  try {
      //    netscape.security.PrivilegeManager.enablePrivilege("UniversalBrowserRead");
  } catch (e) {
    alert("Permission UniversalBrowserRead denied.");
  }

  try { xmlhttp = new ActiveXObject("Msxml2.XMLHTTP"); }
  catch (e) { try { xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); }
  catch (e) { try { xmlhttp = new XMLHttpRequest(); }
  catch (e) { xmlhttp = false; }}}
  if (!xmlhttp) return null;
  
  //this.connect = function(sURL, sVars, fnDone, element)
  this.connect = function(sURL, sMethod, fnDone, element, postVars) {
  
      if(postVars == undefined) { postVars = ""; }
      if (!xmlhttp) return false;
      bComplete = false;

      try {
        if(sMethod == 'GET') { 
            sURL += '&randseed='+Math.round(Math.random()*100000);
            //    sMethod = sMethod.toUpperCase();
            //    xmlhttp.open(sMethod, sURL+"?"+sVars, true);
            xmlhttp.open(sMethod, sURL, true);
            sVars = ""; 
        }
        else {
            xmlhttp.open(sMethod, sURL, true);
            xmlhttp.setRequestHeader("Method", "POST "+sURL+" HTTP/1.1");
            xmlhttp.setRequestHeader("Content-Type",
                   "application/x-www-form-urlencoded");
        }
        xmlhttp.onreadystatechange = function() {
          if (xmlhttp.readyState == 4 && !bComplete) {
            bComplete = true;
            if(fnDone) { 
              fnDone(xmlhttp, element, sMethod=='POST');
            }
          }
        };
        xmlhttp.send(postVars); 
      }
      catch(z) { 
        alert(z);  
        return false; 
      }
      return true;
  };

  this.get_string = function(sURL, responseFun, sMethod, postVars) {

   result = '';
   if(postVars == undefined) { postVars = ""; }
   if(sMethod == undefined) { sMethod = 'GET'; }
      if (!xmlhttp) return false;
      bComplete = false;

      try {
        if(sMethod == 'GET') { 
            //    sMethod = sMethod.toUpperCase();
            //    xmlhttp.open(sMethod, sURL+"?"+sVars, true);
            xmlhttp.open(sMethod, sURL, true);
            sVars = ""; 
        }
        else {
            xmlhttp.open(sMethod, sURL, true);
            xmlhttp.setRequestHeader("Method", "POST "+sURL+" HTTP/1.1");
            xmlhttp.setRequestHeader("Content-Type",
                   "application/x-www-form-urlencoded");
        }
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 && !bComplete) {
          bComplete = true;
          responseFun(xmlhttp.responseText);
            }
        };
        xmlhttp.send(postVars); 
      }
      catch(z) { 
        alert(z);  
        return false; 
      }
      return result;
  };
  
  return this;
}

/*
// Maps interface names to init functions. Means "Call this function 
// after this interface has been requested"
Cuba.init_functions = { 
    'Wiki::Article.show' : init_article_interface, 
    'Wiki::Container.update' : init_all_editors, 
    'App_Main.login' : init_login_screen
};

// Maps element ids to init functions. Means: "Call this function when 
// updating this element". This Hash is to be filled automatically. 
Cuba.element_init_functions = {}
Cuba.update_targets = {}; 
*/
function update_element(xml_conn, element, do_update_source)
{
    if(element) {
	response = xml_conn.responseText;

	if(response == "\n") 
	{
	    if(element.id == 'context_menu') {
		context_menu_close(); 
	    }
	    element.display = 'none';
	} 
	else
	{
	    element.innerHTML = response; 

	    init_fun = Cuba.element_init_functions[element.id]
	    if(init_fun) { init_fun(element); }
	}
    }
    if(do_update_source) {
	for(var target in Cuba.update_targets) {
	    url = Cuba.update_targets[target];
	    cb__update_element(target, url); 
	}
    }
}
function update_element_and_targets(xml_conn, element, update_targets) // update_targets is ignored here
{
    t = '';
    for(var target in Cuba.update_targets) {
	t += target;
    }
//  alert('update '+t+':'+update_targets);
    update_element(xml_conn, element, true); 
}


function cb__get_remote_string(url, response_fun)
{
    var xml_conn = new XHConn; 
    xml_conn.get_string(url, response_fun);
}

function cb__get_form_values(form_id)
{
    form = document.getElementById(form_id);
    
    string = ''
    for(index=0; index<form.elements.length; index++) {
	element = form.elements[index]; 
	if(element.value != '' && element.name != '') { 
	    element_value = element.value;
	    element_value = element_value.replace(/&auml;/g,'ä'); 
	    element_value = element_value.replace(/&ouml;/g,'ö'); 
	    element_value = element_value.replace(/&uuml;/g,'ü'); 
	    element_value = element_value.replace(/&Auml;/g,'Ä'); 
	    element_value = element_value.replace(/&Ouml;/g,'Ö'); 
	    element_value = element_value.replace(/&Uuml;/g,'Ü'); 
	    element_value = element_value.replace(/&szlig;/g,'ß'); 
	    element_value = element_value.replace(/&nbsp;/g,' '); 

	    string += element.name + '=' + element_value + '&'; 
	}
    }
    return string
}

function cb__update_element(element_id, interface_url)
{
    element = document.getElementById(element_id);
    var xml_conn = new XHConn; 

    interface_call = interface_url.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,'$1.$2');
    interface_call = interface_call.replace('/','');

    init_fun = Cuba.init_functions[interface_call];
    if(init_fun) { Cuba.element_init_functions[element.id] = init_fun; }

    xml_conn.connect(interface_url+'&cb__mode=dispatch&randseed='+Math.round(Math.random()*100000), 'GET', update_element, element); 
}

function cb__remote_submit(form_id, target_id, targets)
{
    context_menu_autoclose = true; 
    target_url     = '/aurita/dispatch'; 
    postVars       = Cuba.get_form_values(form_id);
    postVarsHash   = Cuba.get_form_values_hash(form_id);
    postVars += 'cb__mode=dispatch'; 
    Cuba.update_targets = targets

    interface_call = postVarsHash['cb__model']+'.'+postVarsHash['cb__controller']
    interface_call = interface_call.replace('/','');

    init_fun = Cuba.init_functions[interface_call];
    if(init_fun) { Cuba.element_init_functions[element.id] = init_fun; }

    var xml_conn = new XHConn; 
    element = document.getElementById(target_id); 

    //    xml_conn.connect(target_url, 'POST', update_element_and_targets, element, postVars); 
    xml_conn.connect(target_url, 'POST', update_element, element, postVars); 
}

function cb__async_call(target_id, interface_url, on_complete_fun)
{
    var xml_conn = new XHConn; 
    interface_url += '&cb__mode=dispatch'; 
    element = document.getElementById(target_id); 
    element.innerHTML = '<img src="/aurita/images/icons/loading.gif" />'; 
    if(on_complete_fun == undefined) { on_complete_fun = update_element; }
    xml_conn.connect(interface_url, 'GET', on_complete_fun, element);
}

function cb__dispatch_interface(target_id, interface_url, update_fun)
{
//  new Effect.Appear(document.getElementById(target_id), {from:0.0, to:0.9, duration:0.5});
    var xml_conn = new XHConn; 
    interface_url += '&cb__mode=dispatch'; 
    element = document.getElementById(target_id); 
    element.innerHTML = '<img src="/aurita/images/icons/loading.gif" />'; 

    interface_call = interface_url.replace(/aurita\/([^\/]+)\/([^/]+)\/(.+)?/,'$1.$2');
    interface_call = interface_call.replace('/','');
    
    init_fun = Cuba.init_functions[interface_call];
    if(init_fun) { Cuba.element_init_functions[element.id] = init_fun; }
    
    if(update_fun == undefined && interface_url.match('Wiki::Article/show')) { update_fun = init_article; }
    if(update_fun == undefined) { update_fun = update_element; }
    xml_conn.connect(interface_url, 'GET', update_fun, element); 
}

function cb__load_interface(target_id, interface_url, targets)
{
    var xml_conn = new XHConn; 
    interface_url += '&cb__mode=dispatch&randseed='+Math.round(Math.random()*100000); 
    element = document.getElementById(target_id); 
    element.innerHTML  = '<img src="/aurita/images/icons/loading.gif" />'; 
    Cuba.update_targets = targets; 
    if(interface_url.match('Wiki::Article/show')) { update_fun = init_article; }
    else { update_fun  = update_element; }
    xml_conn.connect(interface_url, 'GET', update_fun, element); 
}
function cb__load_interface_silently(target_id, interface_url)
{
    var xml_conn = new XHConn; 
    interface_url += '&cb__mode=dispatch&randseed='+Math.round(Math.random()*100000); 
    element = document.getElementById(target_id); 
    xml_conn.connect(interface_url, 'GET', update_element, element); 
}

// Only function allowed to close the 
// currently opened context menu. 
// Also responsible for cleanup-procedure. 
function cb__cancel_dispatch()
{
    context_menu_close();
    return; 
//    dispatcher_hide(); 
//    setTimeout('cb__unfade()',1000); 
    if(context_menu_opened) {
	context_menu_opened = false; 
	document.getElementById('context_menu').style.display = 'none'; 
	unfocus_element(context_menu_active_element_id); 
    } 
    else {
	new Effect.Fade('dispatcher', {duration: 0.5});
    }
}

function cb__show_fullscreen_cover()
{
    new Effect.Appear('app_fullscreen', { from: 0, to: 1 }); 
    Element.setStyle('app_body', { 'overflow-y': 'hidden' });  // override document scroll bars
    $('app_main_content').innerHTML = ''; 
}
function cb__hide_fullscreen_cover()
{
    Element.setStyle('app_body', { 'overflow-y': 'scroll' }); // reactivate document scroll bars
    Element.setStyle('app_fullscreen', { display: 'none' }); 
    $('app_fullscreen').innerHTML = ''; 
}
