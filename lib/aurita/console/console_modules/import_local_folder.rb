
require('aurita')
Aurita.import_plugin_model :wiki, :media_asset
Aurita.import_plugin_model :wiki, :media_asset_folder
Aurita.import_plugin_model :wiki, :media_asset_folder_category
Aurita.import_plugin_module :wiki, :media_asset_importer
Aurita::Main.import_model :content_category

module Aurita
module Console

  # Console module that imports a local directory into aurita 
  # wiki plugin. 
  # Files are imported as Wiki::Media_Asset instances, directories 
  # as Wiki::Media_Asset_Folder instances. 
  #
  # Usage: 
  #
  #   aurita <project name> import_local_directory <path> <target folder id> <owner_id>
  #
  # Target folder has to be a valid Wiki::Media_Asset_Folder.media_asset_folder_id. 
  # Owner has to be valid User_Group.user_group_id. 
  # Owner id defaults to 5 (user 'aurita'). 
  #
  # Example: 
  #
  #   aurita default import_local_directory /tmp/import_me 123 1
  #   
  #
  class Import_Local_Directory
  include Aurita::Plugins::Wiki

    def initialize(argv)
      @encoding         = argv[:db_client_encoding]
      @path             = argv[:path]
      @parent_folder_id = argv[:to_folder]
      @user_group_id    = argv[:user_id]
      @uaer_group_id  ||= 5
    end

    def run
      visit_folder()
    end

    def visit_folder(path=nil, parent_folder_id=nil)
      path ||= @path
      parent_folder_id ||= @parent_folder_id

      folder_path = path.split('/')
      folder_name = folder_path[-1]
      tags = path.split('/')[3..-1].dup.map { |e| e.downcase }
      puts "-- Create folder #{path} "
      puts "    tags: " << tags.inspect
      asset_folder = Media_Asset_Folder.create(:physical_path => folder_name, 
                                               :user_group_id => @user_group_id, 
                                               :media_folder_id__parent => parent_folder_id, 
                                               :access => 'PUBLIC', 
                                               :trashbin => 'f')
      folder_id = asset_folder.media_asset_folder_id
      Media_Asset_Folder_Category.create(:media_asset_folder_id => folder_id, 
                                         :category_id => 104)
      Dir.glob("#{path}**").each { |f|
        if File.ftype(f) == 'file' then
          begin
            puts '    Create file: ' << f
            STDOUT << '     ' << tags.inspect
            filename = tags[-1].split('.')[0..-2].join('.')
            extension = f.split('.')[-1].downcase
            mime = MIME::Types.of(f).first
            mime = mime.content_type if mime
            mime = '?/?' unless mime
            STDOUT << ' mime: ' << mime.inspect
            STDOUT << ' ext: ' << extension << "\n"
            STDOUT << ' Filename: ' << filename + "\n"
            media_asset = Media_Asset.create(:user_group_id => @user_group_id, 
                                             :tags => (tags + [ f.split('/')[-1], extension ]), 
                                             :mime => mime,
                                             :media_folder_id => asset_folder.media_asset_folder_id, 
                                             :extension => extension, 
                                             :title => f.split('/')[-1], 
                                             :original_filename => f.split('/')[-1], 
                                             :description => f.split('/')[-1])
            Content_Category.create(:content_id => media_asset.content_id, 
                                    :category_id => 104)
            Media_Asset_Importer.new(media_asset).import_local_file(f)
          rescue ::Exception => e
            STDERR.puts 'ERROR: '
            STDERR.puts e.message
            STDERR.puts e.backtrace.join("\n")
          end
        elsif File.ftype(f) == 'directory' then
          visit_folder(f+'/', folder_id)
        end
      }
    end


  end

end
end

