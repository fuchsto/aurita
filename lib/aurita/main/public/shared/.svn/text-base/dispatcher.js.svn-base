
//  if(document.oncontextmenu) {
//		document.oncontextmenu = false; 
//       }
function click(e)
{
    return; 
    if (navigator.appName == 'Netscape') 
	{
	    if (e.which == 3) 
		{
		    return false;
		} 
	    else 
		{
		    return false;
		}
	}
    else if (navigator.appName == 'Microsoft Internet Explorer') {
	if (e.button==2) 
	    {
		return false;
	    } 
	else 
	    {
		return false;
	    }
    }
    
    return false;
}
//	if(document.onmousedown) {
//		document.onmousedown = click; 
//	}


var active_box = 0; 
function rd_admin__notify(message)
{
      active_box = document.getElementById('rd_admin__ui__error');
      document.getElementById('alert_message_string').innerHTML = message; 
      document.getElementById('rd_admin__ui__error').style.display = ""; 
}
function rd_admin__message(message)
{
    active_box = document.getElementById('rd_admin__ui__message');
    document.getElementById('message_string').innerHTML = message; 
    document.getElementById('rd_admin__ui__message').style.display = ""; 
}
function close()
{
    active_box.style.display = "none"; 
}
function loading()
{
    //  active_box = document.getElementById('rd_admin__ui__loading');
    //  document.getElementById('rd_admin__ui__loading').style.display = ""; 
}
function popup_link(url)
{
    return "javascript: popup_site('"+url+"');"; 
}
function mail_link(mail)
{
    return 'mailto: '+mail; 
}

var tasks_visible = false; 
function show_tasks()
{
    task_buffer_frame = get_handle_by_id('task_buffer'); 
    if (!task_buffer_frame.src) {
        task_buffer_frame.src = '/aurelia.admin/dispatch/GUI_Composer/task_buffer/default/'; 
    }
    task_buffer = get_object_by_id('rd_admin__ui__task_buffer'); 
    task_buffer.display = ''; 
      tasks_visible = true; 
}
function hide_tasks()
{
    task_buffer = get_object_by_id('rd_admin__ui__task_buffer'); 
      task_buffer.display = 'none'; 
      tasks_visible = false; 
}
function toggle_tasks()
{
    if (tasks_visible) {
        hide_tasks(); 
    } else {
	show_tasks(); 
    }
}

context_help_visible = false; 
function show_context_help(tag)
{
    help_buffer_frame = get_handle_by_id('context_help_buffer'); 
    help_buffer_frame.innerHTML = tag; 
    context_help_buffer = get_object_by_id('rd_admin__ui__context_help_buffer'); 
    context_help_buffer.display = ''; 
    context_help_visible = true; 
}
function hide_context_help()
{
    context_help_buffer = get_object_by_id('rd_admin__ui__context_help_buffer'); 
    context_help_buffer.innerHTML = ''; 
    context_help_buffer.display = 'none'; 
    context_help_visible = false; 
}

function cb__form_element_focused(tag) 
{
    //	parent.rd_admin__ui__dispatcher.show_context_help(tag); 
}
function cb__form_element_unfocused(tag) 
{
    //	parent.rd_admin__ui__dispatcher.hide_context_help(); 
}

