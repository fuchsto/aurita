
require('aurita/model')
require('aurita/base/configuration')
require('lore/cache/memcache_entity_cache')


class Aurita::Project_Configuration < Aurita::Configuration

  project_name :test

  host 'http://yourdomain.com'
  app_path '/aurita/'
  title 'aurita'

  default_theme { 'default' }

  db_cache Lore::Cache::Memcache_Entity_Cache

  databases(:production  => { 'myproject'      => [ 'dbuser', 'dbpass' ] }, 
            :test        => { 'myproject_test' => [ 'dbuser', 'dbpass' ] }, 
            :development => { 'myproject_dev'  => [ 'dbuser', 'dbpass' ] }) 

  cluster_ports(:production  => [ 3001, 3002, 3003, 3004 ], 
                :test        => [ 3050 ], 
                :development => [ 3060 ])

end

