
require('aurita')
require('mime/types')

Aurita.load_project :wfv
Aurita.session.user = User_Group.load(:user_group_id => 1144)
Aurita.import_plugin_model :wiki, :media_asset
Aurita.import_plugin_model :wiki, :media_asset_folder
Aurita.import_plugin_model :wiki, :media_asset_folder_category
Aurita.import_plugin_module :wiki, :media_asset_importer
Aurita::Main.import_model :content_category

Aurita.bootstrap

include Aurita::Plugins::Wiki

Lore::Connection.perform("set client_encoding = Latin1;")

def visit_folder(path, parent_folder_id=200)

  tr = Iconv.new("UTF-8", "Latin1")

  raise ::Exception.new("No path specified") unless path

  STDOUT << "Importing directory #{path}\n"

# folder_path = tr.iconv(path).split('/')
  folder_path = path.split('/')
  folder_name = folder_path[-1]
  dirs = path.split('/').reject { |d| d == '.' || d == '..' }
  path = dirs.join('/') + '/'
  tags = []
  tags = dirs[1..-1].dup.map { |e| e.downcase } if dirs.length > 1
  tags = tags.reject { |t| t.length < 3 }

  puts "-- Create folder #{path} "
  puts "    tags: " << tags.inspect
  asset_folder = Media_Asset_Folder.create(:physical_path => folder_name, 
                                           :user_group_id => 5, 
                                           :media_folder_id__parent => parent_folder_id, 
                                           :access => 'PUBLIC', 
                                           :trashbin => 'f')
  folder_id = asset_folder.media_asset_folder_id
  Media_Asset_Folder_Category.create(:media_asset_folder_id => folder_id, 
                                     :category_id => 267)
  Dir.glob("#{path}**").each { |f|
    puts "recurse into #{f}"
    if File.ftype(f) == 'file' then
      begin
        puts '    Create file: ' << f
        STDOUT << '     ' << tags.inspect
#        f = tr.iconv(f)
        extension = f.split('.')[-1].downcase
#       if extension == 'pdf' then
          mime = MIME::Types.of(f).first
          mime = mime.content_type if mime
          mime = '?/?' unless mime
          STDOUT << ' mime: ' << mime.inspect
          STDOUT << ' ext: ' << extension.inspect << "\n"
          media_asset = Media_Asset.create(:user_group_id => 5, 
                                           :tags => (tags + [ f.split('/')[-1], extension ]).join(' '), 
                                           :mime => mime,
                                           :media_folder_id => asset_folder.media_asset_folder_id, 
                                           :extension => extension, 
                                           :title => f.split('/')[-1], 
                                           :original_filename => f.split('/')[-1], 
                                           :description => f.split('/')[-1])
          Content_Category.create(:content_id  => media_asset.content_id, 
                                  :category_id => 267)
          Media_Asset_Importer.new(media_asset).import_local_file(f)
#       end
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

visit_folder(ARGV[0], ARGV[1])
