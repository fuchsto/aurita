
Aurita.calculate_aspect_ratio = function() {
	image = $('image_preview');
  url = Element.getStyle('image_preview', 'height');
	url = url.replace(/url\(([^\)]+)\)/,'$1');
  Element.setStyle('image_preview', {'src': url});
	height = Element.getHeight('image_preview'); 
	width = Element.getWidth('image_preview');
	ratio = height / width;
	height = parseInt(width / ratio); 
	if(Aurita.check_if_internet_explorer() == 1) {
    Element.setStyle('crop_line_bottom', { 'top': height-8 } ); 
	}
  else {
    Element.setStyle('crop_line_bottom', { 'top': height-6 } ); 
  }
  Element.setStyle('crop_line_left',   { 'height': height+4 } ); 
  Element.setStyle('crop_line_right',  { 'height': height+4 } ); 
	Element.setStyle(image, { 'height': height } );
  Aurita.image_rotated = false; 
};

Aurita.rotation_counter = 0;
Aurita.ignore_manipulation = false; 
Aurita.image_brightness    = 1.0; 
Aurita.image_hue           = 1.0; 
Aurita.image_saturation    = 1.0; 
Aurita.image_contrast	     = 100; 
Aurita.image_mirror_h      = false; 
Aurita.image_mirror_v      = false; 
Aurita.image_rotation      = 0; 
Aurita.image_rotated       = false; 

Aurita.image_manipulate_brightness = function(value) { 
	Aurita.image_brightness = parseInt(value*100)/100; 
	Aurita.manipulate_image();
};
Aurita.image_manipulate_hue = function(value) { 
	Aurita.image_hue = parseInt(value*100)/100; 
	Aurita.manipulate_image(); 
};
Aurita.image_manipulate_saturation = function(value) { 
	Aurita.image_saturation = parseInt(value*100)/100; 
	Aurita.manipulate_image(); 
};
Aurita.image_manipulate_contrast = function(value) { 
	Aurita.image_contrast = parseInt(value*100)/100; 
	Aurita.manipulate_image(); 
};
Aurita.rotate_left = function() { 
  Aurita.image_rotation -= 90; 
  Aurita.rotation_counter--; 
	Aurita.manipulate_image(); 
  Aurita.image_rotated = true; 
}; 
Aurita.rotate_right = function() { 
  Aurita.image_rotation += 90; 
  Aurita.rotation_counter++; 
	Aurita.manipulate_image(); 
  Aurita.image_rotated = true; 
}; 
Aurita.mirror_horizontal = function() { 
  Aurita.image_mirror_h = !Aurita.image_mirror_h; 
	Aurita.manipulate_image(); 
}; 
Aurita.mirror_vertical = function() { 
  Aurita.image_mirror_v = !Aurita.image_mirror_v; 
	Aurita.manipulate_image(); 
}; 

Aurita.manipulate_image = function(slider_value) // Ignore param
{
   if(!Aurita.ignore_manipulation) { 
     Aurita.hide_image(); 
     action = 'Wiki::Image_Editor/manipulate/media_asset_id='+ Aurita.active_media_asset_id;
     action += '&brightness='+Aurita.image_brightness;
     action += '&hue='+Aurita.image_hue;
     action += '&saturation='+Aurita.image_saturation; 
     action += '&contrast='+Aurita.image_contrast;
     action += '&rotation='+Aurita.image_rotation;
     action += '&mirror_h='+Aurita.image_mirror_h;
     action += '&mirror_v='+Aurita.image_mirror_v;
     Aurita.load({ action: action, 
                 element: 'dispatcher', 
                 on_update: Aurita.reload_background_image });
   }
}; 

Aurita.save_image = function() { 
  Aurita.resolve_slider_positions(); 
     Aurita.hide_image(); 
     action = 'Wiki::Image_Editor/save/media_asset_id='+ Aurita.active_media_asset_id;
     action += '&brightness='+Aurita.image_brightness;
     action += '&hue='+Aurita.image_hue;
     action += '&saturation='+Aurita.image_saturation; 
     action += '&contrast='+Aurita.image_contrast;
     action += '&rotation='+Aurita.image_rotation;
     action += '&mirror_h='+Aurita.image_mirror_h;
     action += '&mirror_v='+Aurita.image_mirror_v;
     action += '&crop_top='+Aurita.slider_positions.top; 
     action += '&crop_bottom='+Aurita.slider_positions.bottom; 
     action += '&crop_right='+Aurita.slider_positions.right; 
     action += '&crop_left='+Aurita.slider_positions.left; 
     action += '&height='+Aurita.slider_positions.height; 
     Aurita.load({ action: action, 
                 element: 'dispatcher', 
                 on_update: function() { alert('Bild wurde gespeichert'); } });
}; 

Aurita.init_image_manipulation_sliders = function() {
	Aurita.image_brightness_slider = new Control.Slider('brightness_handle', 'brightness_track', {
	    onChange: Aurita.image_manipulate_brightness, 
		range: $R(0,2), 
		sliderValue: 1 }); 
	Aurita.image_hue_slider = new Control.Slider('hue_handle', 'hue_track', {
	    onChange: Aurita.image_manipulate_hue, 
		range: $R(0,2), 
		sliderValue: 1 });
	Aurita.image_saturation_slider = new Control.Slider('saturation_handle', 'saturation_track', {
	    onChange: Aurita.image_manipulate_saturation, 
		range: $R(0,2), 
		sliderValue: 1 });	
	Aurita.image_contrast_slider = new Control.Slider('contrast_handle', 'contrast_track', {
	    onChange: Aurita.image_manipulate_contrast, 
		range: $R(1,200), 
		sliderValue: 100 });
};

Aurita.reset_image = function() { 
  Aurita.hide_image(); 
  Aurita.ignore_manipulation = true; 
	Aurita.image_brightness_slider.setValue(1);
	Aurita.image_hue_slider.setValue(1);
	Aurita.image_saturation_slider.setValue(1);
	Aurita.image_contrast_slider.setValue(100);
  Aurita.image_mirror_h      = false; 
  Aurita.image_mirror_v      = false; 
  Aurita.image_rotation      = 0; 
	if(Aurita.rotation_counter % 2 == 1)
	{
		Aurita.calculate_aspect_ratio();
	}
  action = 'Wiki::Image_Editor/reset/media_asset_id='+ Aurita.active_media_asset_id;
  Aurita.load({ action: action, 
              element: 'dispatcher', 
              on_update: Aurita.reload_background_image });
	Aurita.rotation_counter = 0;
	Aurita.reload_background_image();
	Aurita.ignore_manipulation = false; 
};

Aurita.init_crop_lines = function() {
    
    new Draggable('crop_line_left', { revert: false, constraint: 'horizontal', containment: 'image_preview' }); 
    new Draggable('crop_line_right', { revert: false, constraint: 'horizontal', containment: 'image_preview' }); 
    new Draggable('crop_line_top', { revert: false, constraint: 'vertical', containment: 'image_preview' }); 
    new Draggable('crop_line_bottom', { revert: false, constraint: 'vertical', containment: 'image_preview' }); 
};

Aurita.resolve_slider_positions = function() {
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
	Aurita.slider_positions = {top: position_top, bottom: position_bottom, left: position_left, right: position_right, height: image_height };
}

Aurita.init_image_manipulation = function() { 
	Aurita.init_image_manipulation_sliders();
	Aurita.init_crop_lines(); 
}; 

