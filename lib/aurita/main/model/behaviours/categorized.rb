
require('aurita')
require('module-import')
Aurita::Main.import_model :behaviours, :abstract_access_filter

module Aurita

  module Main
    class Content_Category < Aurita::Model # :nodoc:
    end
  end

  module Categorized_Behaviour 
  # {{{ 

    def category_ids
      if !@category_ids then
        mapping      = self.class.category_mapping()
        map          = mapping[:map]
        cat_id_field = mapping[:cat_id_attrib]
        key_value    = __send__(mapping[:key_attrib_name])
        key_field    = mapping[:key_attrib]

        @category_ids = map.select_values(cat_id_field) { |cat_ids| 
          cat_ids.where(key_field == key_value)
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
          cat.where(key_field == key_value)
        }.to_a
      end
      @categories
    end

    def add_category(cat_id)
      mapping      = self.class.category_mapping()
      map          = mapping[:map]
      key_field    = mapping[:key_attrib_name]
      key_value    = __send__(key_field)
      cat_field    = mapping[:cat_id_attrib_name]
      
      if cat_id.kind_of?(Aurita::Model) then
        cat_id = cat_id.__send__(cat_field)
      end

      map.create({ cat_field => cat_id, 
                   key_field => key_value })
      
      if @category_ids then
        @category_ids << cat_id
        @category_ids.uniq!
      end
    end

    def set_categories(*category_ids)
      mapping      = self.class.category_mapping()
      map          = mapping[:map]
      key_field    = mapping[:key_attrib_name]
      key_value    = __send__(key_field)
      cat_field    = mapping[:cat_id_attrib_name]
      
      map.delete { |e|
        e.where(key_field == key_value)
      }
      category_ids.flatten.each { |cat_id|
        if cat_id.kind_of?(Aurita::Model) then
          cat_id = cat_id.__send__(cat_field)
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
      
      if cat_id.kind_of?(Aurita::Model) then
        cat_id = cat_id.__send__(cat_field)
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

  end # }}}

  # Usage: Extend Aurita::Model (esp. Aurita::Main::Content) with 
  # this helper module. 
  # Usage: 
  #
  #   Some_Content.find(10).with(Some_Content.accessible).entities
  #
  # Matches user categories against content categories, filtering 
  # those accessible for this user (Aurita.user instance). 
  #
  module Categorized_Class_Behaviour 
  # {{{
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
      if !@category_map && superclass.respond_to?(:category_mapping) then
        return superclass.category_mapping
      end
      @category_mapping ||= { 
        :map                => @category_map, 
        :key_attrib_name    => @category_map_key_attrib, 
        :cat_id_attrib_name => @category_map_cat_id_attrib, 
        :key_attrib         => @category_map.__send__(@category_map_key_attrib), 
        :cat_id_attrib      => @category_map.__send__(@category_map_cat_id_attrib)
      }
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
      extended_klass.import(Categorized_Behaviour) unless extended_klass.is_a?(Module)
    end
  end # }}}

# Access behaviours: 

  module Categorized_Access_Behaviour
    include Categorized_Behaviour
    include Abstract_Access_Filter_Behaviour
    # {{{

    # Returns true if model instance is accessible for the 
    # given accessor, otherwise returns false. 
    #
    def accessible_for(accessor)
      mapping          = self.class.category_mapping()
      map              = mapping[:map]
      cat_id           = mapping[:cat_id_attrib]
      key              = mapping[:key_attrib]
      accessor_cat_ids = accessor.readable_category_ids 

      map.find(1).with(cat_id.in(accessor_cat_ids)).entity != false
    end
    
    # Returns true if model instance is accessible for the 
    # current session's user (stored in Aurita.user), otherwise 
    # false. 
    # Same as #accessible_for(Aurita.user)
    #
    def accessible
      accessible_for(Aurita.user)
    end

  end # module Categorized_Access_Behaviour }}}

  module Categorized_Access_Class_Behaviour
    include Categorized_Class_Behaviour 
    include Abstract_Access_Filter_Class_Behaviour
    # {{{
    
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

    def self.extended(extended_klass)
      extended_klass.import(Categorized_Access_Behaviour) 
    end

  end # module Categorized_Access_Class_Behaviour }}}

# Accessor behaviours: 

  module Categorized_Accessor_Behaviour
    include Categorized_Behaviour
  # {{{

    def add_category(category, params={})
      cat_id = category
      cat_id = category.category_id if category.is_a?(Aurita::Model) 
      params.update(:user_group_id => user_group_id, 
                    :category_id   => cat_id)
      # Invalidate cache
      @category_ids           = false
      @readable_category_ids  = false
      @writeable_category_ids = false
      User_Category.create(params)
    end

    # Returns private Category of this user. 
    def category
    # {{{
      if !@category then
        @category = Category.find(1).with(:is_private.is('t') & 
                                          :category_id.in(User_Category.select(User_Category.category_id) { |cid| 
                                            cid.where(User_Category.user_group_id == user_group_id)
                                          })).entity
        @category = Category.unassigned_category unless @category
      end
      @category
    end # }}}
    alias own_category category

    # Returns all Category instances mapped to this users as Array. 
    def categories
    # {{{
      if !@categories then
        @categories = User_Category.all_with(User_Category.user_group_id == user_group_id).sort_by(:category_name, :asc).entities
      end
      @categories
    end # }}}
    alias own_categories categories

    # Returns id private Category of this user. Uses User_Group#category(). 
    def category_id
      if category then category.category_id end
    end

    def member_of_category?(cat)
      if cat.is_a?(Category) then
        cat = cat.category_id
      end
      category_ids.include?(cat)
    end

    # Returns ids of Category instances this user is mapped to, as unordered 
    # Array. 
    def category_ids
    # {{{
      if !@category_ids then
        @category_ids = User_Category.select_values(User_Category.category_id) { |cid|
          cid.where(User_Category.user_group_id == (user_group_id))
        }.to_a.flatten.map { |c| c.to_i }
      end
      return @category_ids
    end # }}}

    # Returns all Category instances this user has write permissions 
    # for as Array, ordered alphabetically. 
    def readable_categories
    # {{{
      if !@readable_categories then
        if is_registered? then
          @readable_categories = Category.select { |c| 
            c.where((Category.public_readable == 't') | 
                    (Category.registered_readable == 't') | 
                    (Category.category_id.in(User_Category.select(User_Category.category_id) { |ucid|
                        ucid.where((User_Category.user_group_id == user_group_id) &
                                   (User_Category.read_permission == 't'))
                      })
                    ))
            c.order_by(:category_name, :asc)
          }.to_a
        else
          @readable_categories = Category.select { |c| 
            c.where((Category.public_readable == 't') |
                    (Category.category_id.in(User_Category.select(User_Category.category_id) { |ucid|
                        ucid.where((User_Category.user_group_id == user_group_id) &
                                   (User_Category.read_permission == 't'))
                      })
                    ))
            c.order_by(:category_name, :asc)
          }.to_a
        end
      end
      @readable_categories
    end # }}}

    # Returns all Category instances this user has write permissions 
    # for as Array, ordered alphabetically. 
    def writeable_categories
    # {{{
      if !@writeable_categories then
        if is_admin? then
          @writeable_categories = Category.select { |c|
            c.order_by(:is_private)
            c.order_by(:category_name, :asc)
          }
        else
          if is_registered? then
            @writeable_categories = Category.select { |c| 
              c.where((Category.public_writeable == 't') | 
                      (Category.registered_writeable == 't') | 
                      (Category.category_id.in(User_Category.select(User_Category.category_id) { |ucid|
                          ucid.where((User_Category.user_group_id == user_group_id) &
                                     (User_Category.write_permission == 't'))
                        })
                      ))
              c.order_by(:category_name, :asc)
            }.to_a
          else
            @writeable_categories = Category.select { |c| 
              c.where((Category.public_writeable == 't') |
                      (Category.category_id.in(User_Category.select(User_Category.category_id) { |ucid|
                          ucid.where((User_Category.user_group_id == user_group_id) &
                                     (User_Category.write_permission == 't'))
                        })
                      ))
              c.order_by(:category_name, :asc)
            }.to_a
          end
        end
      end
      @writeable_categories
    end # }}}

    # Returns ids of Category instances this user has read permissions 
    # as unordered Array. 
    def readable_category_ids
    # {{{
      if !@readable_category_ids then
        if is_registered? then
          @readable_category_ids = Category.select_values(Category.category_id) { |c| 
            c.where((Category.public_readable == 't') |
                    (Category.registered_readable == 't') |
                    (Category.category_id.in(User_Category.select(User_Category.category_id) { |ucid|
                        ucid.where((User_Category.user_group_id == user_group_id) &
                                   (User_Category.read_permission == 't'))
                      })
                    ))
          }.to_a.flatten.map { |cid| cid.to_i }
        else
          @readable_category_ids = Category.select_values(Category.category_id) { |c| 
            c.where((Category.public_readable == 't') |
                    (Category.category_id.in(User_Category.select(User_Category.category_id) { |ucid|
                        ucid.where((User_Category.user_group_id == user_group_id) &
                                   (User_Category.read_permission == 't'))
                      })
                    ))
          }.to_a.flatten.map { |cid| cid.to_i }
        end
      end
      @readable_category_ids
    end # }}}

    # Returns ids of Category instances this user has write permissions 
    # as unordered Array. 
    def writeable_category_ids
    # {{{
      if !@writeable_category_ids then
        if is_admin? then
          @writeable_category_ids = Category.select_values(:category_id) { |cat_id|
            cat_id.order_by(:is_private, :desc)
            cat_id.order_by(:category_name, :asc)
          }.to_a.flatten.map { |c| c.to_i }
        else
          if is_registered? then
            @writeable_category_ids = Category.select { |c| 
              c.where((Category.public_writeable == 't') | 
                      (Category.registered_writeable == 't') |
                      (Category.category_id.in(User_Category.select(User_Category.category_id) { |ucid|
                          ucid.where((User_Category.user_group_id == user_group_id) &
                                     (User_Category.write_permission == 't'))
                        })
                      ))
            }.to_a.flatten.map { |c| c.category_id }
          else
            @writeable_category_ids = Category.select { |c| 
              c.where((Category.public_writeable == 't') |
                      (Category.category_id.in(User_Category.select(User_Category.category_id) { |ucid|
                          ucid.where((User_Category.user_group_id == user_group_id) &
                                     (User_Category.write_permission == 't'))
                        })
                      ))
            }.to_a.flatten.map { |c| c.category_id }
          end
        end
      end
      @writeable_category_ids
    end # }}}

    def may_view_category?(cat_or_cat_id)
    # {{{
      cat = false
      if cat_or_cat_id.is_a?(Aurita::Model) then
        cat = cat_or_cat_id
      else
        cat = Category.get(cat_or_cat_id)
      end
      return true if cat.public_readable
      return true if (cat.registered_readable && is_registered?)
      return !User_Category.find(1).with((User_Category.category_id == cat.category_id) & 
                                         (User_Category.user_group_id == user_group_id) & 
                                         (User_Category.read_permission == 't')).entity.nil?
    end # }}}
    alias may_view_category may_view_category?
    alias may_read_from_category may_view_category?
    alias may_read_from_category? may_view_category?

    def may_write_to_category?(cat_or_cat_id)
    # {{{
      cat = false
      if cat_or_cat_id.is_a?(Aurita::Model) then
        cat = cat_or_cat_id
      else
        cat = Category.get(cat_or_cat_id)
      end
      return true if cat.public_writeable
      return true if (cat.registered_writeable && is_registered?)
      return !User_Category.find(1).with((User_Category.category_id == cat.category_id) & 
                                         (User_Category.user_group_id == user_group_id) & 
                                         (User_Category.write_permission == 't')).entity.nil?
    end # }}}
    alias may_write_to_category may_write_to_category?

  end # }}}

  module Categorized_Accessor_Class_Behaviour
    include Categorized_Class_Behaviour 
    # {{{

    def self.extended(extended_klass)
      extended_klass.import(Categorized_Accessor_Behaviour) 
    end
  end # }}}


end # module Aurita

