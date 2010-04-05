#!/usr/bin/env ruby1.8

require('aurita')

if ARGV.length != 1 then
  STDERR.puts "No project name given"
  STDERR.puts "Usage: gen_style.rb <project_name>"
  exit(1)
end

Aurita.load_project ARGV[0].to_sym

$core_styles = [ 
  :basic, 
  :main, 
  :form, 
  :calendar
]

def path_to_token(path)
  path.split('/')[-1].gsub('.rb','').to_sym
end

$plugin_styles = Dir.glob("#{Aurita.project.base_path}plugins/*.rb").map { |path|
  path_to_token(path)
}

project_style_base = "#{Aurita.project.base_path}public/css/"
$project_styles = Dir.glob("#{project_style_base}*.css").map { |path|
  path = path.split('/')[-1].gsub('.css','').to_sym 
}
$project_styles -= [ :aurita_bundle ]

def append_style(file_to, path_from)
  File.open(path_from, "r") { |f|
    file_to.write("\n/* =====================================================")
    file_to.write("\n * BEGIN #{path_from}")
    file_to.write("\n * ===================================================== */")
    file_to.write(f.read)
    file_to.write("\n/* =====================================================")
    file_to.write("\n * END #{path_from}")
    file_to.write("\n * ===================================================== */")
  }
end

target_file = "#{project_style_base}aurita_bundle.css"
File.open(target_file, "w") { |out|
  $core_styles.each do |style_filename|
    core_style    = "#{Aurita::App_Configuration.base_path}main/public/shared/css/#{style_filename}.css"
    project_style = "#{project_style_base}main/#{style_filename}.css"
    if File.exists?(project_style) then
      core_style = project_style
    end
    puts "Using #{core_style}"
    append_style(out, core_style)
  end
  $plugin_styles.each do |plugin_name|
    plugin_style_base = "#{Aurita::App_Configuration.plugins_path}#{plugin_name}/lib/public/css/"
    Dir.glob("#{plugin_style_base}*.css") { |style_filename|
      style_filename = path_to_token(style_filename)
      project_style = "#{project_style_base}#{plugin_name}/#{style_filename}"
      plugin_style  = "#{plugin_style_base}#{style_filename}"
      if File.exists?(project_style) then
        plugin_style = project_style
      end
      puts "Using #{plugin_style}"
      append_style(out, plugin_style)
    }
  end
  $project_styles.each do |style_filename|
    project_style = "#{project_style_base}#{style_filename}.css"
    puts "Using #{project_style}"
    append_style(out, project_style)
  end
}

puts "Written to #{target_file}"
