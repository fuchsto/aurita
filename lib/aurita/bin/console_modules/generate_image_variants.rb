
require('aurita')

Aurita.import_plugin_model :wiki, :media_asset
Aurita.import_plugin_module :wiki, :media_asset_importer
Aurita.import_plugin_module :wiki, :image_manipulation

module Aurita
module Console

  class Generate_Image_Variants

    def initialize(argv)
      @media_asset_id_from = argv[0].to_i if argv[0]
      @media_asset_id_to   = argv[1].to_i if argv[1]
    end

    def run
      assets = Wiki::Media_Asset.all_with(Wiki::Media_Asset.deleted == 'f')
      assets = Wiki::Media_Asset.all_with(Wiki::Media_Asset.media_asset_id >= @media_asset_id_from) if @media_asset_id_from
      assets = Wiki::Media_Asset.all_with((Wiki::Media_Asset.media_asset_id >= @media_asset_id_from) &
                                          (Wiki::Media_Asset.media_asset_id <= @media_asset_id_to)) if @media_asset_id_to
      assets.sort_by(:media_asset_id, :asc).each { |media_asset|
        asset_id = media_asset.media_asset_id

        destfile = Aurita.project_path + "public/assets/<variants>/asset_#{asset_id}.jpg"
        if media_asset && media_asset.has_preview? then
          puts "Importing #{media_asset.id}"
          begin
            Wiki::Image_Manipulation.new(media_asset).create_image_variants(Wiki::Media_Asset_Importer.image_variants)
          rescue ::Exception => e
            puts e.message
          end
        elsif !media_asset then
          puts "No such Media_Asset: #{destfile}"
        end

        GC.enable
        GC.start
        GC.disable
      }
    end

  end

end
end


