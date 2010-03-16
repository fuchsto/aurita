
require('aurita/config')
require('aurita/base/application')
require('aurita/base/log/system_logger')
require('aurita/modules/file_helpers')

module Aurita

  class Application < Aurita::Base_Application

    @app_base_path = Aurita::App_Configuration.base_path 

    @app_base_url  = '/aurita/'
    @app_namespace = Aurita

    def self.base_path
      @app_base_path
    end
    def self.base_url
      @app_base_url
    end

  end # class 
  
  $:.push Aurita::Application.base_path
  
  # Import a file from Aurita's base directory. 
  # Parameter 'path' is path to the file to be 
  # included, relative to Aurita's base directory. 
  #
  # Example: 
  #
  #   Aurita.import :lib, :vendor, :fuse
  #
  # Imports <aurita base dir>/lib/vendor/fuse.rb
  #
  # Returns result of require call. 
  #
  def self.import(*rel_path)
    rel_path.flatten! 
    rel_path = rel_path.join('/')
    path = Aurita::Application.base_path + rel_path.to_s
    r = require(rel_path)
    r
  end
  
  # Import module from <aurita base dir>/modules.  
  #
  # Parameter is array definition of file system path, 
  # relative to Aurita's base module directory. 
  # the last interpreted as file name. 
  #
  # Example: 
  #
  #   Aurita.import_module :vendor, :render_helpers
  #
  def self.import_module(*path)
    import("modules/#{path.join('/')}.rb")
  end

  # Import all files in a directory within Aurita's base 
  # directory. 
  # Parameter 'rel_path' is path to the file to be 
  # included, relative to Aurita's base directory. 
  #
  # Examples: 
  #
  #   Aurita.import :lib, :vendor, :fuse
  #
  #   Aurita.import 'lib/vendor/fuse'
  #
  # Imports <aurita base dir>/lib/vendor/fuse.rb
  #
  def self.import_folder(rel_path)
    Dir.glob("#{rel_path}/*.rb").each {|f| require f }
  end

  # Proxy class handling paths for current project. 
  # Useful when importing project-specific controllers / 
  # models / modules etc. 
  #
  # Examples: 
  #
  #   Aurita::Project.import_controller :custom_project_controller
  #
  #   Aurita::Project.import :vendor, :custom_lib
  #
  #
  module Project

    # Import file from currently loaded project space. 
    # Example: 
    #
    #   Aurita::Project.import :vendor, :custom_lib
    #
    # Imports file <path to project>/vendor/custom_lib.rb
    #
    # Returns result of require call. 
    #
    def self.import(path)
      path = "#{Aurita::App_Configuration.projects_base_path}#{Aurita.project.project_name.to_s.downcase}/#{path}"
      r = require(path)
      Aurita.log('imported ' << path.to_s) if r
      r
    end

    def self.import_controller(namespace, controller=nil)
      if controller.nil? then
        Aurita::Project.import('controllers/' << namespace.to_s) 
      else
        Aurita::Project.import('controllers/' << namespace.to_s << '/' << controller.to_s)
      end
    end

    # Import model from currently loaded project space. 
    # Example: 
    #
    #   Aurita::Project.import_model :shopping_cart
    #
    # Imports file <path to project>/models/shopping_cart.rb
    #
    # Project specific models are useful when overloading / 
    # redefining existing models just in one project. 
    #
    def self.import_model(namespace, *model)
      if model.length == 0 then
        Aurita::Project.import('model/' << namespace.to_s) 
      else
        model = fs_path(model)
        Aurita::Project.import('model/' << namespace.to_s << '/' << model.to_s)
      end
    end

    # Import module from currently loaded project space. 
    # Example: 
    #
    #   Aurita::Project.import_module :shopping_cart
    #
    # Imports file <path to project>/modules/shopping_cart.rb
    #
    # Project specific modules are useful when overloading / 
    # redefining existing modules just in one project. 
    #
    def self.import_module(namespace, module_name=nil)
      if module_name.nil? then
        Aurita::Project.import('modules/' << namespace.to_s) 
      else
        Aurita::Project.import('modules/' << namespace.to_s << '/' << module_name.to_s)
      end
    end

  end

  # Aurita::Main behaves like a plugin but is defined within Aurita. 
  # It provides basic models, controllers and modules that are supposed 
  # to be needed in every application based on Aurita, like 
  # User_Group, Category, Tag_Index, Tag_Relevance, Role, and many more. 
  #
  # Controller methods defined in Aurita::Main can be registered to 
  # plugin hooks just like controller methods in plugins. 
  #
  module Main
  extend Aurita::File_Helpers

    class Application < Aurita::Base_Application

      @app_base_path = Aurita::Application.base_path + 'main/'
      @app_base_url  = '/aurita/'
      @app_namespace = Aurita::Main
      
      @@logger = Aurita::Log::System_Logger.new('Aurita::Main::Application')
      
      def self.base_path
        @app_base_path
      end
      def self.base_url
        @app_base_url
      end

      def self.import_module(mod,file=nil)
        Aurita::Main::import_module(mod,file)
      end
      
      # Import controller from Aurita::Main. 
      # Example: 
      #
      #   Aurita::Main.import_controller :user_login_data
      #
      # Imports <aurita base dir>/main/model/user_login_data.rb
      #   
      def self.import_controller(namespace, controller=nil)
        Aurita::Main.import_controller(namespace, controller)
      end

      # Returns a model klass by given name. 
      # Model classes can possibly be defined in the following places: 
      # 
      # - In Aurita::Main itself
      # - In a plugin
      # - In the currently loaded project
      #
      # If model_klassname includes a namespace, like 'Wiki::Article', 
      # a plugin model is assumed. 
      # Otherwise, a core model klass is assumed. Core models are either 
      # defined by Aurita itself, or in the project. 
      # If the model is present in the project space (<project path>/model), 
      # it is a project specific model and will be loaded even if 
      # a matching model class exists in Aurita's on model path 
      # (<aurita base dir>/model). 
      # 
      # This way, project specific models may behave differently to 
      # core models. You could, for example, define a custom user model, 
      # it just has to be compatible to Aurita's own user model. 
      #
      def self.get_model_klass(model_klassname)
        name_parts = model_klassname.split('::')
        model_name = name_parts.last
        if name_parts.length > 1 then 
          # Plugin model
          namespace = name_parts[0]
          if File.exists?("#{Aurita::App_Configuration.plugins_path}#{namespace.downcase}/model/#{model_name.downcase}.rb") then
            Aurita.import_plugin_model(namespace.downcase, model_name.downcase)
            namespace = Aurita::Plugins.const_get(name_parts[0])
            model = namespace.const_get(model_name)
          end
        else
          # App model
          if File.exists?(Aurita.project.base_path + "model/#{model_name.downcase}.rb") then
            Aurita::Project.import_model(model_name.downcase)
            begin
              model = Aurita::Main.const_get(model_name)
            rescue ::Exception => e
            end
            model ||= Aurita.const_get(Aurita.project.namespace).const_get(model_name)
          elsif File.exists?(Aurita::Main::Application.base_path + "model/#{model_name.downcase}.rb") then
            Aurita::Main.import_model(model_name.downcase)
            model = Aurita::Main.const_get(model_name)
          end
        end
        return model
      end

      # Returns a controller klass by a model name. 
      # Note that every controller has exactly one model it is responsible for, 
      # and naming convention is: 
      #
      #   <controller name> = <model name>_Controller
      #
      # Controllers can possibly be defined in the following places: 
      # 
      # - In Aurita::Main itself
      # - In a plugin
      # - In the currently loaded project
      #
      # If model_klassname includes a namespace, like 'Wiki::Article', 
      # a plugin controller is assumed. 
      # Otherwise, a core controller is assumed. Core controllers are either 
      # defined by Aurita itself, or in the project. 
      # If the controller is present in the project space (<project path>/controllers), 
      # it is a project specific controller and will be loaded even if 
      # a matching controller class exists in Aurita's on controller path 
      # (<aurita base dir>/controllers). 
      # 
      # This way, project specific controllers may behave differently to 
      # core controllers. You could, for example, define a custom user controller, 
      # it just has to be compatible to Aurita's own user controller. 
      #
      def self.get_controller_klass(model_klassname)
        name_parts      = model_klassname.split('::')
        controller_name = name_parts.last
        # Plugin controller
        if name_parts.length > 1 then 
          namespace = name_parts[0]
          # Search in project first: 
          if File.exists?("#{Aurita.project_path}controllers/#{namespace.downcase}/#{controller_name.downcase}.rb") then
            Aurita::Project.import_controller(namespace.downcase, controller_name.downcase)
            controller_name << '_Controller'
            controller = Aurita.const_get(Aurita.project_namespace).const_get(namespace).const_get(controller_name)
          elsif File.exists?("#{Aurita::App_Configuration.plugins_path}#{namespace.downcase}/controllers/#{controller_name.downcase}.rb") then
            namespace = Aurita::Plugins.const_get(name_parts[0])
            controller_name << '_Controller'
            controller = namespace.const_get(controller_name)
          elsif File.exists?("#{Aurita::App_Configuration.plugins_path}#{namespace.downcase}/lib/controllers/#{controller_name.downcase}.rb") then
            namespace = Aurita::Plugins.const_get(name_parts[0])
            controller_name << '_Controller'
            controller = namespace.const_get(controller_name)
          end
        # App controller
        else
          # Search in project first: 
          if File.exists?("#{Aurita.project_path}controllers/#{controller_name.downcase}.rb") then
            Aurita::Project.import_controller(controller_name.downcase)
            controller_name << '_Controller'
            controller = Aurita.const_get(Aurita.project_namespace).const_get(controller_name)
          # Then search in native main controllers: 
          elsif File.exists?(Aurita::Main::Application.base_path + "controllers/#{controller_name.downcase}.rb") then
            Aurita::Main.import_controller(controller_name.downcase)
            controller_name << '_Controller'
            controller = Aurita::Main.const_get(controller_name)
          end
        end
        return controller
      end

    end # class 
    
    # Import file from Aurita::Main. 
    # Example: 
    #
    #   Aurita::Main.import :vendor, :additional_lib
    #
    # Imports <aurita base dir>/main/vendor/additional_lib.rb
    #
    def self.import(path)
      path = Aurita::Main::Application.base_path + path.to_s
      r = require(path)
      Aurita.log('imported ' << path.to_s) if r
      r
    end
    
    # Import model from Aurita::Main. 
    # Example: 
    #
    #   Aurita::Main.import_model :user_login_data
    #
    # Imports <aurita base dir>/main/model/user_login_data.rb
    #   
    def self.import_model(*model)
      model = fs_path(model)
      Aurita::Main.import('model/' << model.to_s)
    end

    # Import controller from currently loaded project space. 
    # Example: 
    #
    #   Aurita::Project.import_controller :shopping_cart
    #
    # Imports file <path to project>/controllers/shopping_cart.rb
    #
    # Project specific controllers are useful when overloading / 
    # redefining existing controllers just in one project. 
    #
    def self.import_controller(namespace, interface=nil)
      if interface.nil? then
        Aurita::Main.import('controllers/' << namespace.to_s) 
      else
        Aurita::Main.import('controllers/' << namespace.to_s << '/' << interface.to_s)
      end
    end

    # Import module from Aurita::Main. 
    # Example: 
    #
    #   Aurita::Main.import_module :gui, :entity_table
    #
    # Imports <aurita base dir>/main/modules/gui/entity_table.rb
    #   
    def self.import_module(namespace, modu=nil)
      if modu.nil? then
        Aurita::Main.import('modules/' << namespace.to_s) if modu.nil?
      else
        Aurita::Main.import('modules/' << namespace.to_s << '/' << modu.to_s)
      end
    end

  end
  
end # module

