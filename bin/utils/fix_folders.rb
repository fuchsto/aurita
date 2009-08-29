
require('aurita')
Aurita.load_project :maecki
Aurita.bootstrap

include Aurita::Plugins::Wiki

User_Group.select { |f| 
    f.join(Media_Asset_Folder).using(:user_group_id) { |fu|
      fu.where(:access.is('PRIVATE'))
    }
}.each { |user_folder|
  puts user_folder.physical_path
  Media_Asset_Folder_Category.create(:category_id => user_folder.category_id, 
                                     :media_asset_folder_id => user_folder.media_asset_folder_id)
}
Media_Asset_Folder.select { |f| 
  f.where(:access.is('PUBLIC'))
}.each { |folder|
  puts folder.physical_path
  Media_Asset_Folder_Category.create(:category_id => 104, 
                                     :media_asset_folder_id => folder.media_asset_folder_id)
}
