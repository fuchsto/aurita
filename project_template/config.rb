
require('aurita/model')
require('aurita/base/configuration')
require('lore/cache/memcache_entity_cache')

Aurita.import_module :gui, :extras, :fancy_form_fields

class Aurita::Project_Configuration < Aurita::Configuration

  project_name :aha
  namespace 'AHA'

  host 'http://yourdomain.com'
  app_path '/aurita/'
  title 'AHA!'

  default_theme { 'default' }
  default_language :de

  db_cache Lore::Cache::Memcache_Entity_Cache

  databases(:production  => { 'aha'      => [ 'aurita', 'aurita23' ] }, 
            :test        => { 'aha_test' => [ 'aurita', 'aurita23' ] }, 
            :development => { 'aha'      => [ 'aurita', 'aurita23' ] }) 

  cluster_ports(:production  => [ 4000 ], 
                :test        => [ 4000 ], 
                :development => [ 4000 ])

end

