
  
function show_image(text, li)
{
    media_asset_id = text.id; 
    cb__load_interface('media_folder_content', '/aurita/Wiki::Media_Asset/show/media_asset_id='+media_asset_id);
};

var drop_target_folder; 
function activate_target(draggable, droppable, overlap_perc)
{
    drop_target_folder = droppable; 
};
function drop_image_in_folder(element)
{
    element.style.display = 'none'; 
    if (element.id.search('image') != -1)
    {
    	cb__load_interface_silently('','/aurita/Wiki::Media_Asset/move_to_folder/media_folder_id='+drop_target_folder.id+'&media_asset_id='+element.id);
   	}
   	else if(element.id.search('folder') != -1)
   	{
    	cb__load_interface_silently('','/aurita/Wiki::Media_Asset_Folder/move_to_folder/media_folder_id='+drop_target_folder.id+'&media_folder_asset_id='+element.id);
   	}
};

Cuba.media_asset_draggables = {}; 
Cuba.create_media_asset_draggable = function(element_id, options) { 
  if(Cuba.media_asset_draggables[element_id] == undefined) {
    Cuba.media_asset_draggables[element_id] = new Draggable(element_id, options);
  }
};

Cuba.destroy_draggables = function() {
  for(var x in Cuba.media_asset_draggables) { 
    Cuba.media_asset_draggables[x].destroy(); 
  }
  Cuba.media_asset_draggables = {}; 
};

Cuba.droppables = {};

Cuba.remove_droppables = function() {
  for(var x in Cuba.droppables) {
      Droppables.remove(document.getElementById('folder_'+Cuba.droppables[x]));
  }
	Cuba.droppables = {};
}

Cuba.shutdown_media_management = function() {
  Cuba.remove_droppables(); 
  Cuba.destroy_draggables(); 
  cb__hide_fullscreen_cover(); 
  Cuba.expanded_folder_ids = {}; 
}

Cuba.expanded_folder_ids = {}
Cuba.load_media_asset_folder_level = function(parent_folder_id, indent) {
  if(Cuba.expanded_folder_ids[parent_folder_id]) {
    $('folder_expand_icon_'+parent_folder_id).src = '/aurita/images/icons/plus.gif'; 
    Cuba.expanded_folder_ids[parent_folder_id] = false; 
    $('folder_children_'+parent_folder_id).innerHTML = '';
    return;
  }
  else { 
    Cuba.expanded_folder_ids[parent_folder_id] = true; 
    $('folder_expand_icon_'+parent_folder_id).src = '/aurita/images/icons/minus.gif'; 
    Cuba.load({ element: 'folder_children_'+parent_folder_id, action: 'Wiki::Media_Asset/print_media_asset_folder_level/media_folder_id='+parent_folder_id+'&indent='+indent, on_update: init_media_interface}); 
  }
}

Cuba.select_media_asset = function(params) {
    var hidden_field_id = params['hidden_field']; 
    var user_id = params['user_id']; 
    var hidden_field = $(hidden_field_id); 
    var select_box_id = 'select_box_'+hidden_field_id;
    select_box = $(select_box_id); 
    Cuba.load({ element: select_box_id, 
                action: 'Wiki::Media_Asset/choose_from_user_folders/user_group_id='+user_id+'&element_id_to_update='+hidden_field_id }); 
    Element.setStyle(select_box, { display: 'block' });
    Element.setStyle(select_box, { width: '100%' });
}; 
Cuba.select_media_asset_click = function(media_asset_id, element_id_to_update) { 
    var hidden_field = $(element_id_to_update);
    var image = $('image_'+element_id_to_update); 
    select_box = $('select_box_'+element_id_to_update); 

    Element.setStyle(select_box, { display: 'none' }); 
    image.src = ''; 
    if(media_asset_id == 0) { 
      image.style.display = 'none';
      hidden_field.value = ''; 
      $('clear_selected_image_button').style.display = 'none'; 
        } else { 
      image.src = '/aurita/assets/asset_'+media_asset_id+'.jpg';
      image.style.display = 'block';
      hidden_field.value = media_asset_id; 
      $('clear_selected_image_button').style.display = ''; 
    }
}; 

Cuba.reload_image = function(element) { 
	var image = $('reloadable_image'); 
	var src = image.src; 
	image.src = ""; 
	image.src = src + '?' + Math.round(Math.random()*1000); 
};

Cuba.folder_hierarchy = new Array();
Cuba.folder_hierarchy.push(0);

Cuba.add_folder_to_hierarchy = function(value) {
  
}

Cuba.open_folder = 0;

Cuba.change_folder_icon = function(value) { 
	folder_to_open = $("folder_icon_" + value);
  folder_to_close = $("folder_icon_" + Cuba.open_folder);
  if(folder_to_close) { 
	  folder_to_close.src = "/aurita/images/icons/folder_closed.gif"; 
  }
	folder_to_open.src = "/aurita/images/icons/folder_opened.gif"; 
  Cuba.open_folder = value;
};

Cuba.reload_background_image = function(element) {
	image = $('image_preview');
	url = image.style.backgroundImage
	url = url.replace(/url\(([^\)]+)\)/,'$1');
	image.style.backgroundImage = ""; 
	image.style.backgroundImage = 'url(' + url + '?' + Math.round(Math.random()*1000) + ')'; 
};

Cuba.rotation_counter = 0;

Cuba.increment_rotation_counter = function() {
	Cuba.rotation_counter += 1;
};

Cuba.check_if_internet_explorer = function() {
  var nAgt = navigator.userAgent;
  if ((verOffset = nAgt.indexOf("MSIE")) != -1) {
    return 1;
  }
  else {
    return 0;
  }
};

Cuba.calculate_aspect_ratio = function() {
  Cuba.check_if_internet_explorer();
	image = $('image_preview');
  url = Element.getStyle('image_preview', 'height');
	url = url.replace(/url\(([^\)]+)\)/,'$1');
  Element.setStyle('image_preview', {'src': url});
	height = Element.getHeight('image_preview'); 
	width = Element.getWidth('image_preview');
	ratio = height / width;
	height = parseInt(width / ratio); 
	if(Cuba.check_if_internet_explorer() == 1) {
    Element.setStyle('crop_line_bottom', { 'top': height-8 } ); 
	}
  else {
    Element.setStyle('crop_line_bottom', { 'top': height-6 } ); 
  }
  Element.setStyle('crop_line_left',   { 'height': height+4 } ); 
  Element.setStyle('crop_line_right',  { 'height': height+4 } ); 
	image.style.height = height;
};

Cuba.ignore_manipulation = false; 
Cuba.image_brightness    = 1.0; 
Cuba.image_hue           = 1.0; 
Cuba.image_saturation    = 1.0; 
Cuba.image_contrast	     = 100; 

Cuba.image_manipulate_brightness = function(value) { 
	Cuba.image_brightness = value; 
	Cuba.manipulate_image();
};
Cuba.image_manipulate_hue = function(value) { 
	Cuba.image_hue = value; 
	Cuba.manipulate_image(); 
};
Cuba.image_manipulate_saturation = function(value) { 
	Cuba.image_saturation = value; 
	Cuba.manipulate_image(); 
};
Cuba.image_manipulate_contrast = function(value) { 
	Cuba.image_contrast = value; 
	Cuba.manipulate_image(); 
};

Cuba.manipulate_image = function(slider_value) // Ignore param
{
   if(!Cuba.ignore_manipulation) { 
     action = 'Wiki::Media_Asset/manipulate/media_asset_id='+ Cuba.active_media_asset_id;
     action += '&brightness='+Cuba.image_brightness;
     action += '&hue='+Cuba.image_hue;
     action += '&saturation='+Cuba.image_saturation; 
     action += '&contrast='+Cuba.image_contrast;
     Cuba.load({ action: action, 
		         element: 'dispatcher', 
		         on_update: Cuba.reload_background_image });
     }
}

Cuba.init_image_manipulation_sliders = function() {
	Cuba.image_brightness_slider = new Control.Slider('brightness_handle', 'brightness_track', {
	    onChange: Cuba.image_manipulate_brightness, 
		range: $R(0,2), 
		sliderValue: 1 }); 
	Cuba.image_hue_slider = new Control.Slider('hue_handle', 'hue_track', {
	    onChange: Cuba.image_manipulate_hue, 
		range: $R(0,2), 
		sliderValue: 1 });
	Cuba.image_saturation_slider = new Control.Slider('saturation_handle', 'saturation_track', {
	    onChange: Cuba.image_manipulate_saturation, 
		range: $R(0,2), 
		sliderValue: 1 });	
	Cuba.image_contrast_slider = new Control.Slider('contrast_handle', 'contrast_track', {
	    onChange: Cuba.image_manipulate_contrast, 
		range: $R(1,200), 
		sliderValue: 100 });
};

Cuba.reset_image = function() { 
    Cuba.ignore_manipulation = true; 
	Cuba.image_brightness_slider.setValue(1);
	Cuba.image_hue_slider.setValue(1);
	Cuba.image_saturation_slider.setValue(1);
	Cuba.image_contrast_slider.setValue(100);
	if(Cuba.rotation_counter % 2 == 1)
	{
		Cuba.calculate_aspect_ratio();
	}
	Cuba.rotation_counter = 0;
	Cuba.reload_background_image();
	Cuba.ignore_manipulation = false; 

};


Cuba.init_crop_lines = function() {
    
    new Draggable('crop_line_left', { revert: false, constraint: 'horizontal', containment: 'image_preview' }); 
    new Draggable('crop_line_right', { revert: false, constraint: 'horizontal', containment: 'image_preview' }); 
    new Draggable('crop_line_top', { revert: false, constraint: 'vertical', containment: 'image_preview' }); 
    new Draggable('crop_line_bottom', { revert: false, constraint: 'vertical', containment: 'image_preview' }); 
};

Cuba.resolve_slider_positions = function() {
	image = $('image_preview');
	url = image.style.backgroundImage
	url = url.replace(/url\(([^\)]+)\)/,'$1');
	image_file = new Image(); 
	image_file.src = url; 
	image_height = image_file.height; 

	position_top = parseInt($('crop_line_top').style.top) + 405;
	position_bottom = parseInt($('crop_line_bottom').style.top) - image_height + 6;
	position_left = parseInt($('crop_line_left').style.left) + 305;
	position_right = parseInt($('crop_line_right').style.left) - 299;
	Cuba.slider_positions = {top: position_top, bottom: position_bottom, left: position_left, right: position_right, height: image_height };
}

Cuba.init_image_manipulation = function(xml_conn, element) { 
	element.innerHTML = xml_conn.responseText;
	Cuba.init_image_manipulation_sliders();
	Cuba.init_crop_lines(); 
}; 

