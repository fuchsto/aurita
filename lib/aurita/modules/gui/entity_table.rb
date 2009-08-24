
require('aurita')
require('aurita-gui/table')
Aurita.import_module :gui, :context_menu

module Aurita
module GUI


  # Usage: 
  #   
  #   t = Entity_Table.new(articles, 
  #                        :headers => [ :title, :author, :tags ], 
  #                        :attributes => [ :title, :user_group_id, :tags ])
  #
  # Or 
  #   t = Entity_Table.new(articles, 
  #                        :headers => :auto)
  #
  # Apart from constructor parameters, Entity_Table instances 
  # behave like a regular Table: 
  #
  #   t.headers.map! { |h| h.capitalize }
  #
  #   t[0].class    == Entity_Table_Row
  #   t[0][0].class == Table_Cell
  #
  # An Entity_Table_Row also allows access to its underlying 
  # DB entity: 
  #
  #   t[0].entity.class == Wiki::Article
  #   puts t[0].entity.title
  #
  class Entity_Table < Table
    attr_accessor :entities, :attributes

    def initialize(entities=[], params={})
      @entities     = entities
      @attributes   = params[:attributes]
      @attributes ||= entities.first.class.get_fields_flat() if entities.first
      @row_class    = Entity_Table_Row
      if params[:headers] == :auto then
        @headers = @attributes.dup
        params.delete(:headers)
      end

      params.delete(:attributes)
      super(params)
    end

    def rows()
      row_vector = []
      @entities.each { |e|
        row_vector << Context_Menu_Element.new(@row_class.new(e, :parent => self), :entity => e)
      }
      row_vector
    end

    def headers=(headers)
      count = 0
      headers.map! { |e|
        e = HTML.th { e } unless e.is_a?(Element)
        e.id = "#{count}_col_header"
        if count > 0 then
          e.onmouseover = "hover_element('#{e.dom_id}');"
          e.onmouseout  = "unhover_element('#{e.dom_id}');"
        end
        count += 1
        e
      }
      super(headers)
    end
    alias set_headers headers=

  end

  class Entity_Table_Row < Table_Row
    attr_accessor :entity

    def initialize(entity, params={})
      @parent   = params[:parent]
      @entity ||= entity
      super(cells(), params)
    end

    def cells()
      row_data = []
      @parent.attributes.each { |a|
        row_data << @entity.__send__(a.to_sym)
      }
      row_data
    end
  end

end
end

