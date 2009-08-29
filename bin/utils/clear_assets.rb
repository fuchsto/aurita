
require 'aurita'

Aurita.load_project :cfmaier
Aurita.bootstrap
Aurita.import_plugin_model :wiki, :media_asset
include Aurita::Plugins::Wiki


def recurse_folder(folder_id)
  puts 'FOLDER: ' + folder_id.to_s
  files = Media_Asset.all_with(Media_Asset.media_folder_id == folder_id).entities
  files.each { |f|
    puts f.media_asset_id + f.title.to_s
    begin
    f.deleted = 't'
    f.commit
    rescue ::Exception => e
    end
  }
  
  count = files.length

  Media_Asset_Folder.all_with(Media_Asset_Folder.media_folder_id__parent == folder_id).each { |folder|
    count += recurse_folder(folder.media_asset_folder_id)
  }
  folder = Media_Asset_Folder.load(:media_asset_folder_id => folder_id)
  folder.delete 
  return count

end

recurse_folder(2000)
