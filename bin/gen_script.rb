#!/usr/bin/env ruby1.8

require('aurita')

if ARGV.length != 1 then
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
  :helpers, 
  :cookie, 
  :xhconn, 
  :md5, 
  :aurita, 
  :error, 
  :backbutton, 
  :message_box, 
  :context_menu, 
  :aurita_gui, 
  :editor, 
  :login, 
  :main
]

$core_scripts_after = [
  :onload
]

def path_to_token(path)
  path.split('/')[-1].gsub('.rb','').to_sym
end

$plugin_scripts = Dir.glob("#{Aurita.project.base_path}plugins/*.rb").map { |path|
  path_to_token(path)
}

project_script_base = "#{Aurita.project.base_path}public/inc/"
$project_scripts = Dir.glob("#{project_script_base}*.js").map { |path|
  path = path.split('/')[-1].gsub('.js','').to_sym 
}
$project_scripts -= [ :dump ]

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

File.open("#{Aurita.project.base_path}public/inc/dump.js", "w") { |out|
  $core_scripts.each do |script_filename|
    core_script    = "#{Aurita::App_Configuration.base_path}main/public/shared/script/#{script_filename}.js"
    project_script = "#{project_script_base}main/#{script_filename}.js"
    if File.exists?(project_script) then
      core_script = project_script
    end
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
      append_script(out, plugin_script)
    }
  end
  $project_scripts.each do |script_filename|
    project_script = "#{project_script_base}#{script_filename}.js"
    append_script(out, project_script)
  end
  $core_scripts_after.each do |script_filename|
    core_script    = "#{Aurita::App_Configuration.base_path}main/public/shared/script/#{script_filename}.js"
    project_script = "#{project_script_base}main/#{script_filename}.js"
    if File.exists?(project_script) then
      core_script = project_script
    end
    append_script(out, core_script)
  end
}

