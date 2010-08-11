#!/usr/bin/env ruby

require('aurita')

if !ARGV[0] then
  exit 1
end

Aurita.load_project ARGV[0]
Aurita.bootstrap

def import_from_model_folder(folder_path, dump_path, plugin_name=false)
  if plugin_name then
    model_ns_name = plugin_name.split('_').map { |part| part.capitalize }.join('_')
  end
  num_plugin_tables = 0
  command = "pg_dump --schema-only \n"
  STDERR.puts "Inspecting #{folder_path}"
  Dir.glob("#{folder_path}/*").each {|p|
    if p.include?('.rb') && !p.include?('custom_') && !p.include?('_ext.rb') then
      model_name = p.split('/')[-1].gsub('.rb','')
      model_class_name = model_name.split('_').map { |part| part.capitalize }.join('_')
      puts "\t" << model_class_name
      begin
        require(p)
        model_ns = Aurita::Plugins.const_get(model_ns_name) if plugin_name
        model_ns = Aurita::Main unless plugin_name
        begin
          model_klass = model_ns.const_get(model_class_name)
          table = model_klass.table_name
          command << " -t #{table} -t #{table}_id_seq \n"
          num_plugin_tables += 1
        rescue NameError => e
          STDERR.puts "No definition found for #{model_class_name} - Probably missing table?"
        end
      rescue PGError => e
        STDERR.puts e.message
        return false
      end
    else 
      STDERR.puts "Nothing to do in #{p}"
    end
  }
  if num_plugin_tables > 0 then
    command << " aurita > #{dump_path}"
    puts command
    system(command.gsub("\n", ' '))
  else 
    STDERR.puts 'No tables found'
  end
  return true
end

import_from_model_folder("#{Aurita::App_Configuration.base_path}/main/model", 
                         "#{Aurita::App_Configuration.base_path}/setup/schema_dump.sql" )
Dir.glob("#{Aurita.project_path}#{'plugins'}/*").each {|f| 
  num_plugin_tables = 0
  puts '-------------------------'
  plugin_name = f.split('/')[-1].gsub('.rb','')
  if plugin_name != 'main' then
    puts plugin_name
    import_from_model_folder("#{Aurita::App_Configuration.plugins_path}#{plugin_name}/lib/model", 
                             "#{Aurita::App_Configuration.plugins_path}#{plugin_name}/schema_dump.sql", 
                             plugin_name)
  end
}

