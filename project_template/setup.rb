
require('aurita')
Aurita.import_plugin_module :wiki, :media_asset_importer

# Some examples of how to add custom thumbnail variants: 

Aurita::Plugins::Wiki::Media_Asset_Importer.add_variant(:circle) { |org_img, asset|
  d = 150
  r = d/2
  img = org_img.crop_resized(d,d)
  circle = Magick::Draw.new
  circle.fill('transparent')
  circle.stroke('#505050')
  circle.stroke_width(1)
  circle.define_clip_path('circle_mask') { circle.circle(r,r,1,r-1) }
  circle.push
  circle.clip_path('circle_mask')
  circle.composite(0,0,d,d,img)  
  circle.pop
  circle.circle(r,r,1,r-1)
  canvas = Magick::Image.new(d,d) { 
    self.background_color = '#505050'
  }
  circle.draw(canvas)
  canvas.compression = Magick::LZWCompression
  canvas.transparent('#505050').write(Aurita.project_path + "public/assets/circle/asset_#{asset.media_asset_id}.gif") 
}

Aurita::Plugins::Wiki::Media_Asset_Importer.add_variant(:preview) { |org_img, asset|
  img = org_img.resize_to_fit(300,150).write(Aurita.project_path + "public/assets/preview/asset_#{asset.media_asset_id}.jpg") { self.quality = 82 }
  org_img
}

