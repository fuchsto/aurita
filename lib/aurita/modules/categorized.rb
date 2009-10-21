
require('aurita/model')



module Aurita

  # Forward-declaration
  module Main 
    class Content_Category < Aurita::Model # :nodoc:
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
  module Categorized_Behaviour
    @category_map = Content_Category
    @category_map_key_attrib = :content_id
    @category_map_cat_id_attrib = :category_id

    # Tell Categorized_Behaviour to use a mapping model 
    # other than Content_Category. 
    # 
    # Usage - Assuming a category map table ( foo_id, cat_id ): 
    #
    #  use_category_map(Custom_Map, :foo_id => :cat_id)
    #
    def use_category_map(klass, mapping)
      @category_map = klass
      @category_map_key_attrib    = mapping.keys.first.to_sym
      @category_map_cat_id_attrib = mapping.values.first.to_sym
    end

    def accessible

#     return Lore::Clause.new(true) if Aurita.user.is_super_admin?
      @category_map               ||= Content_Category
      @category_map_key_attrib    ||= :content_id
      @category_map_cat_id_attrib ||= :category_id
      user_cat_ids = Aurita.user.readable_category_ids 
      permission_constraints = (__send__(@category_map_key_attrib).in( 
        @category_map.select(@category_map_key_attrib) { |cid| 
          cid.where(@category_map.__send__(@category_map_cat_id_attrib).in(user_cat_ids) )
        }
      ))
      return permission_constraints
    end
    alias is_accessible accessible
    alias is_accessible? accessible

    def in_category(cat_id)
      @category_map               ||= Content_Category
      @category_map_key_attrib    ||= :content_id
      @category_map_cat_id_attrib ||= :category_id
      __send__(@category_map_key_attrib).in(@category_map.select(@category_map_key_attrib) { |cid|
        cid.where(@category_map.__send__(@category_map_cat_id_attrib) == cat_id)
      })
    end
  end

end
