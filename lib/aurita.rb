require('aurita/env.rb')
require('aurita/base/log/system_logger.rb')
require('aurita/base/log/class_logger.rb')
require('aurita/config.rb')
require('stringio')
require('tempfile')
require('iconv')

require('aurita/application.rb')

require('aurita/base/log/class_logger')
require('aurita/base/bits/entities')
require('aurita/base/bits/string')
require('aurita/base/bits/integer')
require('aurita/base/bits/array')
require('aurita/base/bits/hash')
require('aurita/base/bits/time')
require('aurita/base/bits/time_ago')
require('aurita/base/bits/file')
require('aurita/base/bits/nil')
require('aurita/base/bits/mock')

require('aurita/modules/file_helpers')

if not defined? RUBY_PATCHLEVEL or (RUBY_VERSION <= '1.8.5' and RUBY_PATCHLEVEL < 2)
  raise SecurityError, 'Please use Ruby 1.8.5-p2 or later!'
end

Aurita.import_module :gui, :lang

# Module Aurita holds some useful methods itself. 
#
# Most are used for bootstrapping an application, 
# some provide access to global data, like session, 
# user, project etc.
# 
# To initiate an aurita project: 
#
#   Aurita.load_project :the_project # Activate a project
#   Aurita.bootstrap                 # Load really everything
#
# The project is imported, but current user will 
# be guest, with almost no privileges. 
# To fake a user, e.g. for testing: 
#   
#   Aurita.session.user = User_Group.load(:user_group_id => 123)
#
module Aurita
  extend Aurita::File_Helpers

  def self.runmode(mode=nil)
    if mode then
      @@runmode = mode
    else
      return @@runmode || :development
    end
  end

  def self.runmode=(mode)
    @@runmode = mode
  end

  # Returns current session object, which is an instance 
  # of Aurita::Session. 
  # A session is always bound to Thread.current, So this is thread safe. 
  def self.session
    return Thread.current['request'][:_session] if (Thread.current['request'] && Thread.current['request'][:_session])
    return Aurita::Mock_Session.new

    if !@session || @session.is_a?(Aurita::Mock_Session) then
      @session   = Thread.current['request'][:_session] if Thread.current['request'] 
      @session ||= Aurita::Mock_Session.new 
    end
    @session
  end

  # Overwrite the current session. Expects instance of 
  # Aurita::Rack_Session, which again expects the request's env: 
  #
  #    Aurita.session = Aurita::Session.new(env)
  #
  # You could have received env from a request object, like a 
  # Mongrel::Request or Rack::Request
  # 
  def self.session=(session)
    Thread.current['request'][:_session] = session
    @session = session
  end

  # Retreive DB record of the user holding the 
  # current session. 
  # In case user is logged in, this returns the 
  # record associated with user_group_id set in 
  # Aurita.session. Returns record of guest user 
  # (user_group_id 0) otherwise. 
  def self.user
    Aurita.session.user
  end

  # Base path of active project. 
  def self.project_path(*folders)
    @@project.base_path + folders.join('/')
  end

  # Return namespace of active project. 
  # Project namespace is the camelcased project 
  # name, so :the_project --> The_Project. 
  def self.project_namespace
    @@project.namespace || @@project.base_path.split('/').at(-1).camelcase
  end

  @@base_path = Aurita::App_Configuration.base_path
  # Return base path
  # (set as Aurita::App_Configuration.base_path in 
  # aurita/config.rb)
  def self.base_path 
    @@base_path
  end

  @@app_base_path = Aurita::App_Configuration.app_base_path
  # Return application base path
  # (set as Aurita::App_Configuration.app_base_path in 
  # aurita/config.rb)
  def self.app_base_path
    @@app_base_path
  end

  # Activate a project by loading its config.rb and 
  # establishing a DB connection. 
  # Project can later be retreived via Aurita.project. 
  def self.load_project(project_name, runmode=:development)
    
    require("#{Aurita::App_Configuration.projects_base_path}#{project_name.to_s}/config.rb")

    @@project = Aurita::Project_Configuration
    runmode   = runmode.to_sym

    Lore.add_login_data @@project.databases[runmode] 
    Lore::Context.enter @@project.databases[runmode].keys.first
    Aurita.import('base/session')

    Aurita.runmode = runmode
  end

  # Return active project. 
  # (instance of Aurita::Project_Configuration). 
  def self.project
    begin
      @@project
    rescue ::Exception => e
      raise ::Exception.new('No project loaded. Call Aurita.load_project :your_project first.')
    end
  end

  # Whether a project has been loaded using Aurita.load :the_project
  def self.project_loaded?
    begin
      return @@project.is_a?(Aurita::Project)
    rescue ::Exception => ignore
    end
    return false
  end
    
  # Import a plugins. Imports all plugin models, controllers, 
  # modules, permission configuration, and its language packs. 
  def self.import_plugin(plugin_name)
    if File.exists?("#{project_path()}/plugins/#{plugin_name.to_s}.rb") then

      Lang.add_plugin_language_pack(plugin_name)

      begin
        Aurita.log { "Trying to load #{plugin_name} from gem ..." } 
        require("aurita-#{plugin_name}-plugin")
        require("aurita-#{plugin_name}-plugin/plugin.rb")
      rescue ::Exception => no_gem_found
        Aurita.log { "Trying to load #{plugin_name} from #{Aurita::App_Configuration.plugins_path} ..." } 
        # No gem found, so try to load from Aurita::App_Configuration.plugins_path.
      
        if(File.exists?("#{Aurita::App_Configuration.plugins_path}#{plugin_name.to_s}/lib")) then
          plugin_path = "#{plugin_name}/lib"
        else 
          plugin_path = plugin_name.to_s.dup
        end

        if File.exists?("#{project_path()}/lang/#{plugin_name}/") then
          Lang.add_project_language_pack(plugin_name)
        end
        Aurita.log { "Importing plugin #{plugin_name}" }
        Aurita.import_folder "#{Aurita::App_Configuration.plugins_path}#{plugin_path}/lang/"
        Aurita.import_folder "#{Aurita::App_Configuration.plugins_path}#{plugin_path}/modules/"
        Aurita.import_folder "#{Aurita::App_Configuration.plugins_path}#{plugin_path}/model/"
        Aurita.import_folder "#{Aurita::App_Configuration.plugins_path}#{plugin_path}/controllers/"

        perms_file = "#{Aurita::App_Configuration.plugins_path}#{plugin_path}/permissions.rb"
        if File.exists?(perms_file) then
          require perms_file
        end
      end
    end

    begin
      require("#{project_path()}/plugins/#{plugin_name.to_s}.rb")
    rescue LoadError => ignore
      Aurita.log('Skipping plugin ' << plugin_name.to_s + ' (LoadError)')
    end
  end

  # Import a single model from a plugin. 
  # Example: 
  #
  #   Aurita.import_plugin_model :wiki, :article
  #
  def self.import_plugin_model(plugin, *model)
    r = false
    model = fs_path(model)
    begin
      r = require("#{Aurita::App_Configuration.plugins_path}#{plugin}/model/#{model}")
    rescue LoadError => e
      plugin = "#{plugin}/lib"
      r = require("#{Aurita::App_Configuration.plugins_path}#{plugin}/model/#{model}")
    end
    Aurita.log "imported model #{plugin}/#{model}" if r
    r
  end
  # Import a single controller from a plugin. 
  # Example: 
  #
  #   Aurita.import_plugin_controller :wiki, :article
  #
  def self.import_plugin_controller(plugin, controller)
    r = false
    begin
      r = require("#{Aurita::App_Configuration.plugins_path}#{plugin}/controllers/#{controller}")
    rescue LoadError => e
      plugin = "#{plugin}/lib"
      r = require("#{Aurita::App_Configuration.plugins_path}#{plugin}/controllers/#{controller}")
    end
    Aurita.log "imported controller #{plugin}/#{controller}" if r
    r
  end
  # Import a single module from a plugin. 
  # Example: 
  #
  #   Aurita.import_plugin_module :wiki, :article_hierarchy_default_decorator
  #
  def self.import_plugin_module(plugin, *path)
    path = fs_path(*path)
    r = false
    begin
      r = require("#{Aurita::App_Configuration.plugins_path}#{plugin}/modules/#{path}")
    rescue LoadError => e
      plugin = "#{plugin}/lib"
      r = require("#{Aurita::App_Configuration.plugins_path}#{plugin}/modules/#{path}")
    end
    Aurita.log "imported module #{plugin}/#{path}" if r
    r
  end

  # Boostraps Aurita. Imports models and controllers from 
  # Aurita::Main and all plugins active in this project. 
  # That is, all models and controllers will be loaded at 
  # once and thus prevents models to be late-fetched. 
  # Bootstrapping takes some time (depending on plugin 
  # configuration, up to 1 second) and should be used in 
  # production mode only. 
  def self.bootstrap
    Aurita.log('Bootstrapping ...')

    Aurita::Main.import :permissions

    Dir.glob("#{Aurita::Application.base_path}main/model/*.rb").each { |model| 
      Aurita::Main.import_model(model.split('/').last) 
    }
    Dir.glob("#{Aurita::Application.base_path}main/controllers/*.rb").each { |controller| 
      Aurita::Main.import_controller(controller.split('/').last) 
    }
    Dir.glob("#{Aurita::App_Configuration.plugins_path}/*").each { |plugin_folder| 
      Aurita.import_plugin(plugin_folder.split('/').last) 
    }
    Dir.glob("#{Aurita.project.base_path}model/*.rb").each { |model| 
      Aurita::Project.import_model(model.split('/').last) 
    }
    if File.exists?("#{project_path()}policy.rb") then
      require("#{project_path()}policy.rb")
    else 
      Aurita::Main.import :policy
    end
    if File.exists?("#{project_path()}plugins/main.rb") then
      require("#{project_path()}plugins/main.rb")
    end

    Lang.add_project_language_pack 'main'

    if File.exists?("#{project_path()}setup.rb") then
      require("#{project_path()}setup.rb")
    end
  end

  # Returns array of all active model classes in this project. 
  # Includes models from Aurita::Main as well as plugin models. 
  def self.active_models
    return @models if @models
    @models = []
    Dir.glob("#{Aurita::Application.base_path}main/model/*.rb").each { |model| 
      begin
        @models << Aurita::Main.const_get(model.split('/').last.gsub('.rb','').camelcase) 
      rescue ::Exception => e
        puts e.message
      end
    }
    Dir.glob("#{Aurita::App_Configuration.plugins_path}/*").each { |plugin_folder| 
      Dir.glob("#{Aurita::App_Configuration.plugins_path}/#{plugin_folder.split('/').last.gsub('.rb','')}/model/*").each { |model| 
        begin
          plugin = plugin_folder.split('/').last
          model_klass = model.split('/').last.gsub('.rb','')

          @models << Aurita::Plugins.const_get(plugin.camelcase).const_get(model_klass.camelcase) 
        rescue ::Exception => e
          puts e.message
        end
      }
    }
    return @models
  end

  def self.memory_usage
    `ps -o rss= -p #{Process.pid}`.to_i 
  end

  module Plugins
  end

end

include Aurita
include Aurita::Main
include Aurita::Plugins

