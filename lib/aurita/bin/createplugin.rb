#!/usr/bin/env ruby


def helpscreen
  puts 'createplugin - Create an Aurita plugin. '
  puts 'Usage: ' 
  puts '  createplugin <plugin_name>'
end

if ARGV[1].nil? then
  helpscreen()
  exit(1)
end

plugin_name = ARGV[1].downcase

File.cp("/usr/share/svnwc/aurita/setup/plugin_template", "/usr/share/svnwc/aurita_plugins/#{plugin_name}")
