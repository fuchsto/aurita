
require('aurita')
require('RMagick')
require('fileutils')
Aurita.load_project :cfmaier
Aurita.bootstrap

include Aurita::Plugins::Wiki
include Magick

pdf_assets = Media_Asset.all_with(:mime.ilike('%pdf')).entities
amount = pdf_assets.length
count = 0
pdf_assets.each { |pdf|
  count += 1
  puts pdf.media_asset_id + ' | ' << pdf.extension.to_s << "(#{count} of #{amount}) |" << pdf.tags 
  
  begin
    id  = pdf.media_asset_id
    ext = 'pdf[0]' 
    img = ImageList.new(Aurita.project_path + 'public/assets/asset_' << id + '.' << ext)
    img.write(Aurita.project_path + 'public/assets/asset_' << id + '.jpg')
    Image_Manipulation.new(pdf).create_image_versions()
  rescue ::Exception => e
    puts 'Error when trying to create image versions: ' << e.message
    puts e.backtrace.join("\n")
    exit
  end
}
