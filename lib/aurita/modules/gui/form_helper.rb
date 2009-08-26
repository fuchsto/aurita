
require('aurita-gui/form')
require('aurita-gui/form/template_helper')

module Aurita
module GUI

  # Usage: 
  #
  #   <% gui.form_for(:model => Person, :action => :perform_add) do |f| %>
  #     <%= form.boolean(:name  => :is_admin, :value => true, :label => 'Are you an admin?') 
  #     <%= form.radio(:name  => :some_option, :label => 'Which color?', :value => 1, 
  #                    :options => { 0 => :red, 
  #                                  1 => :blue, 
  #                                  2 => :greem })
  #   <% end %>
  #
  module Form_Helper

    def form_for(*args, &block)
      action = ''
      model  = false
      case args[0]
      when Hash
        params   = args[0]
        instance = params[:instance]
        model    = params[:model]
        model  ||= instance.class if instance
        action   = params[:action]
        params.delete(:model)
        params.delete(:action)
        params.delete(:instance)
      when String
        parts    = args[0].split('.')
        params   = args[1]
        params ||= {}
        model    = parts[0]
        action   = parts[1]
      end
      if !(model.kind_of?(Aurita::Model)) then
        begin 
          model = eval(model.to_s)
        rescue ::Exception => e
          raise ::Exception.new("Could not resolve model klass for '#{model}': #{e.message}") 
        end
      end
      raise ::Exception.new("Could not resolve model klass: '#{model.inspect}'") unless model
      params[:name] = model.model_name.downcase.gsub('::','__') + "__#{action}_form" unless params[:name]
      form = Ajax_Form.new(params)
      render form.header_string 
      render '<ul class="form_fields">'
      render form.hidden(:name => :controller, 
                         :value => model.model_name, 
                         :required => true)
      render form.hidden(:name => :action, 
                         :value => action, 
                         :required => true)

      if instance then
        model.get_primary_keys.each_pair { |table, keys|
          keys.each { |key|
            # TODO: Prettify - attribute value map is not necessary
            # and rather expensive. 
            table_attribs = instance.get_attribute_value_map[table]
            if table_attribs && table_attribs[key]then
              render Hidden_Field.new(:name => "#{table}.#{key}", 
                                      :value => table_attribs[key].to_s, 
                                      :required => true).string
            end
          }
        }
      end
      yield(form)
      render '</ul>'
      render '</form>'
    end

  end

end
end
