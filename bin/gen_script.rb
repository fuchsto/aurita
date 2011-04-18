#!/usr/bin/env ruby1.8

require('aurita')

if ARGV.length < 1 then
  STDERR.puts "No project name given"
  STDERR.puts "Usage: gen_script.rb <project_name>"
  exit(1)
end

Aurita.load_project ARGV[0].to_sym

$core_scripts = [ 
  'jscalendar/calendar', 
  'jscalendar/lang/calendar-de', 
  'jscalendar/calendar-setup', 
  :log, 
  :math, 
  :helpers, 
  :cookie, 
  :xhconn, 
  :md5, 
  :aurita, 
  :stats, 
  :error, 
  :backbutton, 
  :message_box, 
  :context_menu, 
  :aurita_gui, 
  :editor, 
  :login, 
  :main, 
  :htmlentities
]
$core_scripts_after = [
  :onload
]

$core_frontend_scripts = [ 
  'jscalendar/calendar', 
  'jscalendar/lang/calendar-de', 
  'jscalendar/calendar-setup', 
  :log, 
  :math, 
  :helpers, 
  :cookie, 
  :xhconn, 
  :md5, 
  :aurita, 
  :error, 
  :backbutton, 
  :message_box, 
  :aurita_gui, 
  :login, 
  :main, 
  :htmlentities
]
$core_frontend_scripts_after = [ 
  :onload
]

if ARGV[1] == 'frontend' || ARGV[1] == 'public' then
  $core_scripts       = $core_frontend_scripts
  $core_scripts_after = $core_frontend_scripts_after
end

def path_to_token(path)
  path.split('/')[-1].gsub('.rb','').to_sym
end

$plugin_scripts = Dir.glob("#{Aurita.project.base_path}plugins/*.rb").map { |path|
  path_to_token(path)
}

project_script_base = "#{Aurita.project.base_path}public/inc/"
$project_scripts = Dir.glob("#{project_script_base}*.js").map { |path|
  if path[-7..-1] != '.src.js' then
    path = path.split('/')[-1].gsub('.js','').to_sym 
    path = nil if [:ie6, :ie7].include?(path)
    path
  else 
    puts 'Ignored ' + path
  end
}
$project_scripts -= [ :aurita_bundle ]
$project_scripts -= [ :aurita_bundle_public ]

$project_scripts.reject! { |s| s.nil? }

def append_script(file_to, path_from)
  File.open(path_from, "r") { |f|
    file_to.write("\n///////////////////////////////////////////////////////")
    file_to.write("\n// BEGIN #{path_from}")
    file_to.write("\n///////////////////////////////////////////////////////\n")
    file_to.write(f.read)
    file_to.write("\n///////////////////////////////////////////////////////")
    file_to.write("\n// END #{path_from}")
    file_to.write("\n///////////////////////////////////////////////////////\n")
  }
end

target_file = "#{project_script_base}aurita_bundle.js"
File.open(target_file, "w") { |out|
  $core_scripts.each do |script_filename|
    core_script    = "#{Aurita::App_Configuration.base_path}main/public/shared/script/#{script_filename}.js"
    project_script = "#{project_script_base}main/#{script_filename}.js"
    if File.exists?(project_script) then
      core_script = project_script
    end
    puts "Using #{core_script}"
    append_script(out, core_script)
  end
  $plugin_scripts.each do |plugin_name|
    plugin_script_base = "#{Aurita::App_Configuration.plugins_path}#{plugin_name}/lib/public/script/"
    Dir.glob("#{plugin_script_base}*.js") { |script_filename|
      script_filename = path_to_token(script_filename)
      project_script = "#{project_script_base}#{plugin_name}/#{script_filename}"
      plugin_script  = "#{plugin_script_base}#{script_filename}"
      if File.exists?(project_script) then
        plugin_script = project_script
      end
      puts "Using #{plugin_script}"
      append_script(out, plugin_script)
    }
  end
  $core_scripts_after.each do |script_filename|
    core_script    = "#{Aurita::App_Configuration.base_path}main/public/shared/script/#{script_filename}.js"
    project_script = "#{project_script_base}main/#{script_filename}.js"
    if File.exists?(project_script) then
      core_script = project_script
    end
    puts "Using #{core_script}"
    append_script(out, core_script)
  end
  $project_scripts.each do |script_filename|
    project_script = "#{project_script_base}#{script_filename}.js"
    puts "Using #{project_script}"
    append_script(out, project_script)
  end
}

puts "Written to #{target_file}"
