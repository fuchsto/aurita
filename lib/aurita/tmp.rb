
require 'aurita'

Aurita.load_project :default
Aurita.bootstrap

include Aurita::Main

Aurita::Main.import_model :session_key

p Session_Key.__attributes__.inspect

ses = Session_Key.find(1).entity
ses.time_mod = 'foo'

puts '-------------------'
p ses.touched
puts '-------------------'
ses.commit
