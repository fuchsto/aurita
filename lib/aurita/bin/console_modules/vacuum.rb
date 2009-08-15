
require('aurita')

module Aurita
module Console

  class Vacuum
  include Aurita::Plugins::Wiki

    def initialize(argv)
    end

    def run
      vacuum_media_assets()
      vacuum_tags()
    end

    def permdelete_folder(folder_id)
      return

      Media_Asset.all_with(:media_folder_id.is(folder_id)).each { |m| 
        m.deleted = 't'
        m.media_folder_id = 10
        m.commit
      }
      Media_Asset_Folder.all_with(:media_folder_id__parent.is(folder_id)).each { |f|
        permdelete_folder(f.media_asset_folder_id)
        f.delete
        puts f.physical_path
      }
    end

    def vacuum_media_assets
      Media_Asset.all_with(Media_Asset.deleted == 't').each { |m|
        begin
          File.delete(m.fs_path)
        rescue ::Exception => e
          puts 'could not delete ' << m.fs_path
        end
        begin
          if m.has_preview? then
            # TODO: Get variant names from Wiki::Media_Asset_Importer

            File.delete("#{Aurita.project.base_path}public/assets/tiny/asset_#{m.media_asset_id}.jpg")
            File.delete("#{Aurita.project.base_path}public/assets/small/asset_#{m.media_asset_id}.jpg")
            File.delete("#{Aurita.project.base_path}public/assets/thumb/asset_#{m.media_asset_id}.jpg")
            File.delete("#{Aurita.project.base_path}public/assets/medium/asset_#{m.media_asset_id}.jpg")
            File.delete("#{Aurita.project.base_path}public/assets/large/asset_#{m.media_asset_id}.jpg")
          end
        rescue ::Exception => e
          puts 'could not delete preview of ' << m.fs_path
        end
        m.delete
      }
    end

    def vacuum_tags
      Tag_Relevance.all.entities.each { |t|
        tag = t.tag
        puts 'Testing tag ' + tag
        content = Content.find(1).with(Content.tags.has_element_ilike(tag)).entity
        if !content then
          Tag_Index.delete { |e| e.where(e.tag == tag) }
          Tag_Relevance.delete { |e| e.where(e.tag == tag) }
        end
      }
    end

  end

end
end

