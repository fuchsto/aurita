
require('aurita-gui')

module Aurita
module GUI

  class Autocomplete_Result < Element

    attr_accessor :entries

    @@pseudo_index = 0

    def initialize(params={})
      @entries   = params[:entries]
      @entries ||= []
      @element   = params[:element]

      params.delete(:element)

      params[:tag]   = :pseudo
      params[:style] = 'width: 419px;' unless params[:style]
      super(params)
      add_css_class(:autocomplete)
      add_css_class(:autocomplete_default)
    end
    def element
      list_elements = []
      default_classes = css_classes
      @entries.each_with_index { |e,count|
        if count == 0 then
          classes = default_classes + [:autocomplete_first_entry] 
        elsif count == @entries.length then
          classes = default_classes + [:autocomplete_last_entry] 
        else 
          classes = default_classes
        end
        classes = classes + [ e[:class] ] if e[:class]

        element = e[:element]
        element ||= HTML.nobr { 
                      HTML.b { e[:title] } + 
                      HTML.span(:class => :informal) { HTML.br + e[:informal] } 
                    }

        # Delimiters must provide an id, too! 
        list_elements << HTML.li(:class => :delimiter, :id => "none_#{@@pseudo_index}") { e[:header] } if count == 0
        list_elements << HTML.li(:class => classes, 
                                 :style => 'width: 419px;', 
                                 :id    => e[:id]) { 
          element
        }
      }
      @@pseudo_index += 1
      list_elements
    end
  end

end
end
