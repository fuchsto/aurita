
# Setting global environment settings. 
# This file will be included before anything else. 

# Uncomment the following line if using DarwinPorts on OS X: 
# $:.push('/opt/local/lib/ruby/1.8/postgres')


# To enable the ruby1.9 compatible patched version of rio, 
# which can be found at ...
#
# http://github.com/wishdev/rio
#
# ... add site-ruby to path: 
[ 
  '/usr/local/lib/site_ruby/1.9.1/'
].each { |libpath|
  STDERR.puts "Looking for library path #{libpath} ... "
  if File.exists?(libpath) then
    $:.push(libpath) 
    STDERR.puts "Added #{libpath} to library path"
  else
    STDERR.puts "not found"
  end
}

require('rio')
require('rubygems')
require('pp')
require('lore')

