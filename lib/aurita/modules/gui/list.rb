
module Aurita
module GUI

  class List < Widget

    attr_reader :items, :header

    def initialize(params={}, &block)
      @params = params
      @items  = params[:items]
      @items  = yield if block_given?
      @header = params[:header]
      @params.delete(:header)
      @params.delete(:items)
      super()
    end

    def element
      item_index = 0
      HTML.div.listbox(@params) { 
        HTML.h4 { @header } + 
        HTML.div.items { 
          @items.map { |i|
            item = HTML.div.item { i }
            item.add_css_class("item_#{item_index}")
            if item_index == 0 then
              item.add_css_class(:first) 
            elsif item_index == (@items.length-1)
              item.add_css_class(:last) 
            end
            item
          }
        }
      }
    end

  end

end
end

