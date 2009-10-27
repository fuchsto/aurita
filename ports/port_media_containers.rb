
require('aurita')

Aurita.load_project :cfmaier

Lore.enable_logging
Lore.enable_query_log

Lore.logfile = STDERR

Aurita.bootstrap

include Aurita::Plugins::Wiki

Media_Container.delete_all
Media_Container_Entry.delete_all

Container.all_with(Container.content_type == 'IMAGE').each { |container|
  
  media_asset = Media_Asset.find(1).with(Media_Asset.content_id == container.content_id_child).entity
  text_asset  = Text_Asset.find(1).with(Text_Asset.content_id == container.content_id_parent).entity

  if media_asset && text_asset then
    media_container = Media_Container.create(:tags          => [ :media_container ], 
                                             :user_group_id => 1)

    if text_asset.article then
      Container.create(:content_id_parent => text_asset.article.content_id, 
                       :asset_id_child    => media_container.asset_id)

      Media_Container_Entry.create(:media_container_id => media_container.media_container_id, 
                                   :media_asset_id  => media_asset.media_asset_id)
    end

  end
}
