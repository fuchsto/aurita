
require('aurita')
require('aurita-gui')
require('aurita-gui/widget')
require('aurita-gui/form/date_field')

Aurita.import_module :gui, :i18n_helpers


module Aurita
module GUI

  # Overload default behaviour from Aurita::GUI
  class Date_Field < Form_Field
  include Aurita::GUI::I18N_Helpers

    alias basic_element element
    def element
      value   = @value
      value ||= "#{@year_range.to_a.first}-1-1"
      @date_format = tl(:date_field_format)

      field_id  = @attrib[:name].gsub('.','_')
      target_id = "#{field_id}_target"

      onchange  = "Aurita.GUI.update_date_field('#{target_id}');"

      year_element().dom_id    = "#{field_id}_target_year"
      month_element().dom_id   = "#{field_id}_target_month"
      day_element().dom_id     = "#{field_id}_target_day"
      year_element().onchange  = onchange
      month_element().onchange = onchange
      day_element().onchange   = onchange
      field = basic_element << HTML.input(:type  => :hidden, 
                                          :id    => target_id, 
                                          :name  => @attrib[:name], 
                                          :value => value)
      field
    end
  end

  class Duration_Field < Form_Field
  include Aurita::GUI::I18N_Helpers

    def initialize(params, &block)
      @day_range    = params[:day_range]
      @day_range  ||= (0..7)
      @hour_range   = params[:hour_range]
      @hour_range ||= (0..23)
      super(params, &block)
      @value ||= [0,0]
    end

    def element
      HTML.div { 
        HTML.div.duration_days { Select_Field.new(:name => "#{@attrib[:name]}_days", :options => @day_range, :value => @value[0]) +
         tl(:days) } + 
        HTML.div.duration_hours { Select_Field.new(:name => "#{@attrib[:name]}_hours", :options => @hour_range, :value => @value[1]) + 
         tl(:hours) } 
      }
    end
  end

  class Datepick_Field < Form_Field
  include Aurita::GUI::I18N_Helpers

    def initialize(params, &block)
      params[:id] = params[:name]
      super(params, &block)
      add_css_class(:datepick)
    end

    def element
      name = dom_id().to_s.gsub('.','_')
      trigger_name = "#{name}_trigger"
      trigger_onclick = "Aurita.GUI.open_calendar('#{name}','#{trigger_name}');"
      clear_onclick   = "$('#{name}').value = '';"

      @attrib[:onclick] = trigger_onclick
      HTML.div.datepick_field { 
        Input_Field.new(@attrib.update(:value => @value, :readonly => true, :id => name)).decorated_element + 
        Text_Button.new(:class   => :datepick_clear, 
                        :onclick => clear_onclick) { 'X' }  + 
        Text_Button.new(:id      => trigger_name, 
                        :class   => :datepick, 
                        :onclick => trigger_onclick) { tl(:choose_date) } 
      }
    end

  end

  # Redefines Aurita::GUI::Timefield from aurita-gui
  #
  class Time_Field < Form_Field
  include Aurita::GUI::I18N_Helpers

    attr_accessor :from, :to

    def element
      name          = @attrib[:name]
      select_fields = []
      @time_format.to_s.split('').each { |c|
        case c
        when 'h' then
          select_fields << hour_element() 
        when 'm' then
          select_fields << minute_element() 
        when 's' then
          select_fields << second_element() 
        end
      }
      HTML.div(@attrib) { 
        HTML.input(:type  => :hidden, 
                   :name  => name, 
                   :value => "00:00", 
                   :id    => "#{name}_target") + 
        select_fields
      }
    end

    def js_initialize
      base_name = @attrib[:name]
      
      code = <<JS
        $('#{base_name}_hour').observe('change', function(evt) { 
          $('#{base_name}_target').value = $('#{base_name}_hour').value + ':' + $('#{base_name}_minute').value;
        });
        $('#{base_name}_minute').observe('change', function(evt) { 
          $('#{base_name}_target').value = $('#{base_name}_hour').value + ':' + $('#{base_name}_minute').value;
        });
JS
    end

  end

  class Timespan_Field < Form_Field
  include Aurita::GUI::I18N_Helpers

    attr_accessor :from, :to

    def initialize(params={}, &block)
      @from = params[:value][0] if params[:value].is_a?(Array)
      @to   = params[:value][1] if params[:value].is_a?(Array)
      @from = params[:value][:from] if params[:value].is_a?(Hash)
      @to   = params[:value][:to] if params[:value].is_a?(Hash)
      @minute_range = params[:minute_range]
      @minute_range ||= [0, 15, 30, 45]
      params.delete(:value)
      params.delete(:from)
      params.delete(:to)
      params.delete(:minute_range)
      params.delete(:time_format)
      super(params, &block)
    end

    def decorated_element
      Decobox.new(:class => :form_field) { 
        element
      }
    end

    def element
      name      = @attrib[:name]
      from_name = "#{name}_from"
      to_name   = "#{name}_to"

      Time_Field.new(:name         => "#{from_name}", 
                     :id           => "#{from_name}", 
                     :value        => @from, 
                     :parent       => self, 
                     :class        => [ :timespan, :from ], 
                     :time_format  => 'hm', 
                     :minute_range => @minute_range) + 
      HTML.div(:class  => :timespan_delimiter) { tl(:timespan_to) } + 
      Time_Field.new(:name         => "#{to_name}", 
                     :id           => "#{to_name}", 
                     :value        => @to, 
                     :parent       => self, 
                     :class        => [ :timespan, :to ], 
                     :time_format  => 'hm', 
                     :minute_range => @minute_range) 
    end

  end

end
end

