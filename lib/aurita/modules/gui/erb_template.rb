
require('erb')
require('aurita/application')

Aurita.import('base/log/class_logger')
Aurita.import_module :gui, :helpers
Aurita.import_module :gui, :form_helper

module Aurita
module GUI

  class ERB_Binding_Params
    
    def initialize(param_hash)
      @params = param_hash
    end

    def get(param)
      @params[param]
    end
      
    def method_missing(method)
      @params[method]
    end

    def plugin_call(hook, call_params=nil)
      Aurita::Plugin_Register.call(hook, @params[:_controller], call_params)
    end
    def plugin_get(hook, call_params=nil)
      Aurita::Plugin_Register.get(hook, @params[:_controller], call_params)
    end
    
  end

  class ERB_Template
  include Aurita::GUI
  include Aurita::GUI::Helpers
  include Aurita::GUI::Form_Helper

  protected

    @@erb = {}
    @@template = {}
    @@logger = Aurita::Log::Class_Logger.new('ERB_Template')

    attr_accessor :output_buffer

  public

    def initialize(template_filename, param_hash={}, plugin=false)

      @output_buffer = ''

      if template_filename.instance_of? Symbol then
        template_filename = template_filename.to_s << '.rhtml' 
      else 
        template_filename = template_filename.to_s << '.rhtml' unless template_filename.split('.')[1]
      end
      if plugin then
        @plugin_name = plugin.to_s
        @template_symbol = (@plugin_name + '__' << template_filename.split('.')[0]).intern
      else
        @plugin_name = 'main'
        @template_symbol = template_filename.split('.')[0].intern
      end

      if @@template[@template_symbol].nil? then
        @@template[@template_symbol] = ''

        if plugin then
          if File.exists?(Aurita.project_path + "views/#{@plugin_name}/#{template_filename}") then
            template_path = Aurita.project_path + "views/#{@plugin_name}/#{template_filename}"
          else
            template_path = Aurita::Configuration.plugins_path + "#{plugin}/views/#{template_filename}"
          end
        end
        if !plugin || !File.exists?(template_path) then
          if File.exists?(Aurita.project_path + "views/#{template_filename}") then
            template_path = Aurita.project_path + "views/#{template_filename}"
          else
            template_path = Aurita::Application.base_path + "main/views/#{template_filename}"
          end
        end
        @@logger.log { 'Using template ' << template_path } 

        @@template[@template_symbol].chomp!("\n")
        IO.foreach(template_path) { |line|
          @@template[@template_symbol] << line
        }

        @@erb[@template_symbol] = ERB.new(@@template[@template_symbol], nil, '', '@output_buffer')
      end

      @binding_params = ERB_Binding_Params.new(param_hash)
      @binding = binding_for(@binding_params)
      
    end

    def set_data(param_hash)
      @binding_params = ERB_Binding_Params.new(param_hash)
      @binding = binding_for(@binding_params)
    end

    def string
      begin
        @@erb[@template_symbol].result(@binding)
      rescue ::Exception => excep
        raise ::Exception.new("Error when loading template #{@template_symbol.to_s} : #{excep.message} | #{excep.backtrace.join("\n")}")
      end
    end

    def concat(string)
      @output_buffer << string
    end
    alias render concat
    alias puts concat

    def plugin_name
      @template_symbol.to_s.split('__')
    end

    def tl(code)
      Lang.get(@plugin_name, code)
    end
    alias translate tl

    def method_missing(method)
      begin
        @binding_params.get(method)
      rescue ::Exception => excep
        puts 'Error when calling ' << method.to_s + ': ' << excep.message
      end
    end

    def print
      puts @@erb[@template_symbol].result(@binding)
    end

protected

    def binding_for(params, gui=Aurita::GUI::ERB_Helpers)
      binding
    end
      
    
  end # class

end # module
end # module

