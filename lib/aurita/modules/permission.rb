
require('aurita')
Aurita.import_module :gui, :i18n_helpers

module Aurita

  # Class storing a type of action that needs 
  # explicit permission to be performed. 
  # Example: 
  #
  #   p = Permission.new(:may_delete_events, :type => :bool, :default => false)
  #
  # Available types are: 
  #
  # - bool (yes / no)
  # - string (arbitrary)
  # - integer (any number)
  # - options (one of several options)
  # - selection (none or more of several options)
  #
  # Types :options and :selection expect parameter :options to be set. 
  # Example: 
  #
  #   p = Permission.new(:may_delete_events, :type => :option, 
  #                      :options => [ :foreign_events, :events_in_own_categories, :all_events ]
  #
  class Permission
  include Aurita::GUI::I18N_Helpers

    attr_accessor :name, :type, :params
    
    @@type_map = { 
      :bool      => Proc.new { |name, params| Aurita::GUI::Pg_Boolean_Field.new(:name => name, :value => params[:default]) }, 
      :string    => Proc.new { |name, params| Aurita::GUI::Text_Field.new(:name => name,       :value => params[:default]) }, 
      :integer   => Proc.new { |name, params| Aurita::GUI::Text_Field.new(:name => name,       :value => params[:default]) }, 
      :option    => Proc.new { |name, params| Aurita::GUI::Select_Field.new(:name => name,     :value => params[:default], :options => params[:options]) }, 
      :selection => Proc.new { |name, params| Aurita::GUI::Checkbox_Field.new(:name => name,   :value => params[:default], :options => params[:options]) }
    }

    def initialize(name, params={})
      @name     = name
      @params   = params
      @type     = params[:type]
      @type   ||= :bool
      @plugin   = params[:plugin]
      @plugin ||= :main
      @params.delete(:type)
      @params[:default] = false if params[:default].nil? 
    end

    def element
      e = @@type_map[@type].call(@name, @params)
      e.label = Lang.get(@plugin, @name.to_s)
      return e
    end

  end

end

