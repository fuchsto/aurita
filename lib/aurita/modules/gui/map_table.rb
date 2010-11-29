
require('aurita-gui/table')

module Aurita
module GUI

  class Map_Table < Table

    def initialize(params={}, &block)
      params[:column_css_classes] = [ :left, :right ]
      super(params, &block)
      add_css_class(:map_table)
    end

  end

end
end
