
require 'aurita'
Aurita.load_project :default
Aurita.import_plugin_model :wiki, :media_asset

require 'rubygems'
require 'mime/types'

session.user = User_Group.load(:user_group_id => 1)

include Aurita::Plugins::Wiki

Media_Asset.all.each { |a| 
    types = MIME::Types.of(a.fs_path).first
    ext = 'jpg'
    ext = types.extensions.first if types
    ext = 'jpg' if ext == 'jpeg'
    a.extension = ext unless a.extension
    skip_file = false
    begin
      a['filesize'] = File.size(a.fs_path)
    rescue ::Exception => e
      puts e.message
      puts 'skipped ' << a.media_asset_id
      skip_file = true
    end
    a['tags'] = '{' << a.tags.gsub(/\s+/,' ').gsub(' ',',') + '}'
    begin 
      a.commit unless skip_file
    rescue Lore::Exception::Invalid_Klass_Parameters => ikp
      puts ikp.serialize
    end
}

