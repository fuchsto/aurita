
require('aurita')
Aurita.load_project :cfmaier
Aurita.bootstrap

include Aurita::Plugins::Wiki

def recurse_folder(folder_id, &block)
  Media_Asset_Folder.all_with(:media_folder_id__parent.is(folder_id)).each { |f|
    recurse_folder(f.media_asset_folder_id, &block)
    yield(f)
    puts f.physical_path
  }

end

recurse_folder(200) { |folder|
  Media_Asset.all_with(:media_folder_id.is(folder.media_asset_folder_id)).each { |m| 
    m.user_group_id = 5
    m.commit
  }
}

