
require('aurita')
Aurita::Main.import_model :behaviour, :abstract_access_filter

module Aurita

  module Main
    class Content_Category < Aurita::Model # :nodoc:
    end
  end

  module Categorized_Instance_Behaviour < Abstract_Access_Filter_Instance_Behaviour

    # Returns true if model instance is accessible for the 
    # given user, otherwise returns false. 
    #
    def accessible_for(user)
      mapping      = self.class.category_mapping()
      map          = mapping[:map]
      cat_id       = mapping[:cat_id_attrib]
      key          = mapping[:key_attrib]
      user_cat_ids = user.readable_category_ids 

      map.find(1).with(cat_id.in(user_cat_ids)).entity != false
    end
    
    # Returns true if model instance is accessible for the 
    # current session's user (stored in Aurita.user), otherwise 
    # false. 
    # Same as #accessible_for(Aurita.user)
    #
    def accessible
      accessible_for(Aurita.user)
    end

    def category_ids
      if !@category_ids then
        mapping      = self.class.category_mapping()
        map          = mapping[:map]
        cat_id_field = mapping[:cat_id_attrib]
        key_value    = __send__(mapping(:key_attrib_name))
        key_field    = mapping[:key_attrib]

        @category_ids = map.select_values(cat_id_field) { |cat_ids| 
          cat_ids.where(key_field == key_value))
        }.to_a.flatten.map { |cat_id| cat_id.to_i }
      end
      @category_ids
    end

    def categories
      if !@categories then
        mapping      = self.class.category_mapping()
        map          = mapping[:map]
        key_field    = mapping[:key_attrib_name]
        key_value    = __send__(key_field)

        @categories = map.select { |cat| 
          cat.where(key_field == key_value))
        }.to_a
      end
      @categories
    end

    def add_category(cat_id)
      mapping      = self.class.category_mapping()
      map          = mapping[:map]
      key_field    = mapping[:key_attrib_name]
      key_value    = __send__(key_field)
      
      if category_id.respond_to?(:category_id) then
        cat_id = cat_id.category_id
      end
      map.create(cat_id_field => cat_id, 
                 key_field    => key_value)
      
      if @category_ids then
        @category_ids << category_id
        @category_ids.uniq!
      end
    end

    def set_categories(*category_ids)
      mapping      = self.class.category_mapping()
      map          = mapping[:map]
      key_field    = mapping[:key_attrib_name]
      key_value    = __send__(key_field)
      
      map.delete { |e|
        e.where(key_field == key_value)
      }
      category_ids.flatten.each { |cat_id|
        if cat_id.respond_to?(:category_id) then
          cat_id = cat_id.category_id
        end
        map.create(cat_id_field => cat_id, 
                   key_field    => key_value)
      }
      @category_ids = category_ids
    end
    alias set_category_ids set_categories

    def remove_category(cat_id)
      mapping      = self.class.category_mapping()
      map          = mapping[:map]
      key_field    = mapping[:key_attrib_name]
      cat_field    = mapping[:cat_id_attrib_name]
      key_value    = __send__(key_field)
      
      if cat_id.respond_to?(:category_id) then
        cat_id = cat_id.category_id
      end
      map.delete { |e|
        e.where((key_field == key_value) & 
                (cat_field == cat_id))
      }
      @category_ids.delete(category_id) if @category_ids
    end

    def remove_categories()
      set_categories([])
    end

  end

  # Usage: Extend Aurita::Model (esp. Aurita::Main::Content) with 
  # this helper module. 
  # Usage: 
  #
  #   Some_Content.find(10).with(Some_Content.accessible).entities
  #
  # Matches user categories against content categories, filtering 
  # those accessible for this user (Aurita.user instance). 
  #
  module Categorized_Behaviour < Abstract_Access_Filter_Behaviour
    @category_map               = Content_Category
    @category_map_key_attrib    = :content_id
    @category_map_cat_id_attrib = :category_id

    # Tell Categorized_Behaviour to use a mapping model 
    # other than Content_Category. 
    # 
    # Usage - Assuming a category map table ( foo_id, cat_id ): 
    #
    #  use_category_map(Custom_Map, :foo_id => :cat_id)
    #
    def use_category_map(klass, mapping)
      @category_map               = klass
      @category_map_key_attrib    = mapping.keys.first.to_sym
      @category_map_cat_id_attrib = mapping.values.first.to_sym
    end

    def category_mapping
      { 
        :map                => @category_map, 
        :key_attrib_name    => @category_map_key_attrib, 
        :cat_id_attrib_name => @category_map_cat_id_attrib, 
        :key_attrib         => __send__(@category_map_key_attrib), 
        :cat_id_attrib      => __send__(@category_map_cat_id_attrib)
      }
    end

    def accessible
      @category_map               ||= Content_Category
      @category_map_key_attrib    ||= :content_id
      @category_map_cat_id_attrib ||= :category_id
      user_cat_ids = Aurita.user.readable_category_ids 
      permission_constraints = (__send__(@category_map_key_attrib).in( 
        @category_map.select(@category_map_key_attrib) { |cid| 
          cid.where(@category_map.__send__(@category_map_cat_id_attrib).in(user_cat_ids) )
        }
      ))
      if respond_to?(:deleted) then
        permission_constraints = (:deleted.is('f') & permission_constraints)
      end
      return permission_constraints
    end

    def in_category(cat_id)
      @category_map               ||= Content_Category
      @category_map_key_attrib    ||= :content_id
      @category_map_cat_id_attrib ||= :category_id
      __send__(@category_map_key_attrib).in(@category_map.select(@category_map_key_attrib) { |cid|
        cid.where(@category_map.__send__(@category_map_cat_id_attrib) == cat_id)
      })
    end

    def self.extended(extended_klass)
      extended_klass.include(Categorized_Instance_Behaviour)
    end

  end

end

