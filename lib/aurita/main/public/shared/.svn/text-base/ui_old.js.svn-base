
function rd_admin__ui__tool_showhide(name, nest)
{
    if(nest != '') {
	var box = get_object_by_id(nest,'');
	var content = get_object_by_id(name,nest);
    }
    else {
	content = get_object_by_id(name, ''); 
    }
    if(content.display == "none") {
	content.display = "";
	if(nest != '') { box.width="240px"; }
    } 
    else {
	content.display = "none"; 
	if(nest != '') { box.width="24px"; }
    }
}
function rd_admin__ui__tool_varwidth_showhide(name, nest, width)
{
    var box = get_object_by_id(nest,'');
    var content = get_object_by_id(name,nest);
    if(content.display == "none") {
	content.display = "";
	box.width=width+"px";
    } 
    else {
	content.display = "none"; 
	box.width="24px";
    }
}
function rd_admin__ui__show(name, nest)
{
    var hide_obj = get_object_by_id(name, nest);
    hide_obj.display = "";
    
}
function rd_admin__ui__hide(name, nest)
{
    var hide_obj = get_object_by_id(name, nest);
    hide_obj.display = "none";
}

function rd_admin__handle_exception(error_name, action)
{
    rd_admin__ui__showhide('rd_admin__ui__error',''); 
    //  parent.rd_admin__ui__scratch.location.href="dispatcher.rhtml?rd__model=Error_Handler&rd__error="+error_name+"&rd__controller="+action; 
}
function rd_admin__raise_exception(	header,message, 
					label1,action1,type1,  
					label2,action2,type2,
					label3,action3,type3)
{
    rd_admin__ui__show('rd_admin__ui__error',''); 
    // apply button styles etc
    if(action1 != '') { 
	rd_admin__ui__show_button('rd_admin__ui__error_button1', 'rd_admin__ui__error', label1, type1); 
	//	apply_style('rd_admin__ui__error_button1', 'rd_admin__ui__error', 'background_color'='#990000');
    }
    if(action2 != '') { 
	rd_admin__ui__show('rd_admin__ui__error_button2', 'rd_admin__ui__error'); 
	//	apply_style('rd_admin__ui__error_button2', 'rd_admin__ui__error', 'class'=type2);
    } 
    else { rd_admin__ui__hide('rd_admin__ui__error_button2', 'rd_admin__ui__error'); }
    if(action3 != '') { 
	rd_admin__ui__show('rd_admin__ui__error_button3', 'rd_admin__ui__error'); 
	//	apply_style('rd_admin__ui__error_button3', 'rd_admin__ui__error', 'class'=type3); 
    }
    else { rd_admin__ui__hide('rd_admin__ui__error_button3', 'rd_admin__ui__error'); }
    
}
function rd_admin__ui__show_button(name, nest, label, type) 
{
    var button = get_object_by_id(name, nest);
    button.display = "";
}

function rd_admin__location(frame, url)
{
    eval(frame+'.location.href='+"'"+url+"'"); 
}

function rd_admin__popup_asset(url, w, h) 
{
    if(w == undefined || w > screen.width)   { w = screen.width/2; resize = '1'; }
    if(h == undefined || h > screen.height)  { h = screen.height/2; resize = '1'; }
    
    LeftPosition = (screen.width) ? (screen.width-w)/2 : 0;
    TopPosition = (screen.height) ? (screen.height-h)/2 : 0;
    settings = 'height='+h+',width='+w+',top='+TopPosition+',left='+LeftPosition+',scrollbars=1,resizable='+resize+',menubar=0,fullscreen=0,status=0'
	win = window.open(url,"app",settings);
    win.focus();
}

function rd_admin__popup(url, width, height)
{
    w=width;
    h=height;
    LeftPosition = (screen.width) ? (screen.width-w)/2 : 0;
    TopPosition = (screen.height) ? (screen.height-h)/2 : 0;
    settings = 'height='+h+',width='+w+',top='+TopPosition+',left='+LeftPosition+',scrollbars=1,resizable=0,menubar=0,fullscreen=0,status=0';
    win = window.open(url,'win'+width+'x'+height,settings);
    
    win.focus();	
}

function rd_admin__article_preview(project, aid)
{
    rd_admin__popup('/projects/'+project+'/Node/preview_article/rd__article_id='+aid, 1024, 768); 
}
function rd_admin__node_preview(project, bg, cid)
{
    rd_admin__popup('/projects/'+project+'/Site/content/bg='+bg+'&track='+cid+'&x='+screen.width+'&y='+screen.height+'&cid='+cid, screen.width*0.7, screen.height-200); 
}

function rd_admin__select_box_value(select_id)
{
    select_obj = document.getElementById(select_id); 
    with (select_obj) return options[selectedIndex].value;
}

function rd_admin__swap_checkbox(checkbox_id)
{
    checkbox = document.getElementById(checkbox_id);
    if(checkbox.checked) { checkbox.checked = false; }
    else { checkbox.checked = true; } 
}

date_obj = new Date(); 

function swap_image_choice_list()
{
    Element.setStyle('image_choice_list', { display: '' }); 
    Element.setStyle('text_asset_form', { display: 'none' }); 
    Element.setStyle('choose_custom_form', { display: 'none' }); 
    Cuba.disable_context_menu_draggable(); 
}
function swap_text_edit_form()
{
    Element.setStyle('image_choice_list', { display: 'none'}); 
    Element.setStyle('text_asset_form', { display: ''}); 
    Element.setStyle('choose_custom_form', { display: 'none'}); 
    Cuba.enable_context_menu_draggable(); 
}
function swap_choose_custom_form()
{
    Element.setStyle('image_choice_list', { display: 'none'}); 
    Element.setStyle('text_asset_form', { display: 'none'}); 
    Element.setStyle('choose_custom_form', { display: ''}); 
    Cuba.enable_context_menu_draggable(); 
}

function profile_load_interfaces(uid, what)
{
  Cuba.load({ element: 'profile_content', action: 'Community::User_Profile/show_'+what+'/user_group_id='+uid, on_update: on_data }); 
}

var active_profile_button = false;
function profile_load(uid, which)
{
  new Effect.Fade('profile_content', {duration: 0.5}); 
  if($('profile_flag_main')) { 
    $('profile_flag_main').className = 'flag_button'
  }
  if($('profile_flag_own_main')) { 
    $('profile_flag_own_main').className = 'flag_button'
  }
  $('profile_flag_galery').className = 'flag_button'
  $('profile_flag_posts').className  = 'flag_button'
  $('profile_flag_friends').className  = 'flag_button'
  if(!active_profile_button) { 
    document.getElementById('profile_flag_main'); 
  }
  active_profile_button.className = 'flag_button';
  active_profile_button = document.getElementById('profile_flag_'+which); 
  active_profile_button.className = 'flag_button_active';
  setTimeout("profile_load_interfaces('"+uid+"','"+which+"')", 550); 
}

function messaging_load_interfaces(uid, what)
{
  Cuba.load({ element: 'messaging_content', action: 'Community::User_Message/show_'+what+'/user_group_id='+uid, on_update: on_data }); 
}

var active_messaging_button = false;
function messaging_load(uid, which)
{
  new Effect.Fade('messaging_content', {duration: 0.5}); 
  $('messaging_flag_inbox').className = 'flag_button'
  $('messaging_flag_sent').className = 'flag_button'
  $('messaging_flag_read').className  = 'flag_button'
  $('messaging_flag_trash').className  = 'flag_button'
  if(!active_messaging_button) { 
    document.getElementById('messaging_flag_main'); 
  }
  active_messaging_button.className = 'flag_button';
  active_messaging_button = document.getElementById('messaging_flag_'+which); 
  active_messaging_button.className = 'flag_button_active';
  setTimeout("messaging_load_interfaces('"+uid+"','"+which+"')", 550); 
}

function autocomplete_username_handler(text, li)
{
  generic_id = text.id; 
}

