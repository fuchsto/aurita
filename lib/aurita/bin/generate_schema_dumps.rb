#!/usr/bin/env ruby

require('aurita')
Aurita.load_project :default
Aurita.bootstrap

def import_from_model_folder(folder_path, dump_path, plugin_name=false)
  if plugin_name then
    model_ns_name = plugin_name.split('_').map { |part| part.capitalize }.join('_')
  end
  num_plugin_tables = 0
  command = "pg_dump --schema-only \n"
  Dir.glob("#{folder_path}/*").each {|p|
  if p.include?('.rb') && !p.include?('custom_') && !p.include?('_ext.rb') then
    model_name = p.split('/')[-1].gsub('.rb','')
    model_class_name = model_name.split('_').map { |part| part.capitalize }.join('_')
    puts "\t" << model_class_name
    begin
      require(p)
      model_ns = Aurita::Plugins.const_get(model_ns_name) if plugin_name
      model_ns = Aurita::Main unless plugin_name
      model_klass = model_ns.const_get(model_class_name)
      table = model_klass.table_name
      command << " -t #{table} -t #{table}_id_seq \n"
      num_plugin_tables += 1
    rescue PGError => e
      STDERR.puts e.message
      return false
    end
  end
  }
  if num_plugin_tables > 0 then
    command << " aurita > #{dump_path}"
    STDERR.puts command
    system(command.gsub("\n", ' '))
  end
  return true
end

import_from_model_folder("#{Aurita::Configuration.base_path}/main/model", 
                         "#{Aurita::Configuration.base_path}/setup/schema_dump.sql" )
Dir.glob("#{Aurita.project_path}#{'plugins'}/*").each {|f| 
  num_plugin_tables = 0
  puts '-------------------------'
  plugin_name = f.split('/')[-1].gsub('.rb','')
  puts plugin_name
  import_from_model_folder("#{Aurita::Configuration.plugins_path}#{plugin_name}/model", 
                           "#{Aurita::Configuration.plugins_path}#{plugin_name}/schema_dump.sql", 
                           plugin_name)
}

