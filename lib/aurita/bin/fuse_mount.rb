
require('aurita')
Aurita.load_project :default

STDERR.puts 'Bootstrapping aurita'
Aurita.bootstrap
STDERR.puts 'Importing aurita fuse module'
Aurita.import_module :fuse, :mediafs

Aurita::Main::Fuse::Media_Filesystem.mount('/home/paracelsus/aurita_fs')
