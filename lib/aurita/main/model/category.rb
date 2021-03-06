
require('aurita/model')
Aurita::Main.import_model :content

module Aurita
module Main

  # Maps instances of Category to users. 
  # Assocating users and categories is the core principle of Aurita's 
  # permission management: Users only may access Content entities if 
  # there is at least one category both are mapped to. 
  # See documentation for Category for details. 
  #
  # Readonly permissions to contents in a category can be defined 
  # by setting attribute User_Category#readonly. 
  #
  # Every User_Group instance (including virtual users and non-atomic 
  # user groups) has one private Category assigned. 
  # Private categories must not have more than one User_Group assigned. 
  #
  # For details on mapping users to categories, see documentation on 
  # model User_Category. 
  #
  # There is a virtual Category instance for Content entities that have 
  # no category assigned to them (e.g. in case a category has been deleted). 
  # This category always has id '1' and is only accessible by admin users. 
  #
  class Category < Aurita::Model

    table :category, :public
    primary_key :category_id, :category_id_seq
    
    use_label :category_name
    expects :category_name

    explicit :is_private

    translate_field :category_name

    # Create category with id '1' ("no category") when creating a new 
    # project. 
    def bootstrap
      create(:category_name => tl(:unassigned_category), 
             :category_id   => 1)
    end

    # Mark category with given id as touched (e.g. for cache invalidation). 
    # Categories are touched whenever Content instances are added to or 
    # removed from them. 
    def self.touch(cat_id)
      @@logger.log("Touching category #{cat_id} (deleting cache) ...")
      cache_name = Aurita.project_path + "cache/category_#{cat_id}.html"
      if File.exists?(cache_name) then
        File.delete(cache_name)
      end
      cache_name = Aurita.project_path + "cache/category_changes_#{cat_id}.html"
      if File.exists?(cache_name) then
        File.delete(cache_name)
      end
    end
    
    # Mark this category as touched (e.g. for cache invalidation). 
    # Categories are touched whenever Content instances are added to or 
    # removed from them. 
    def touch(attrib=nil)
      super(attrib) if attrib
      Category.touch(category_id)
    end

    def parent_id
      category_id_parent || 0
    end

    # Return (virtual) category "no category", which is Category with 
    # category_id '1'. 
    def self.unassigned_category
      # Reserved id 1 -> generic category id
      @unassigned_category = Category.load(:category_id => 1) unless @unassigned_category
      return @unassigned_category
    end

    def parent_category
      return false if category_id_parent == 0
      return Category.find(1).with(Category.category_id == category_id_parent).entity
    end
    alias parent parent_category
    def parent_categories
      parents = [ ]
      immediate_parent = parent_category()
      if immediate_parent then
        parents << immediate_parent
        parents += parents.first.parent_categories
      end
      parents
    end

    def immediate_child_categories
      Category.all_with(Category.category_id_parent == category_id).entities
    end
    def child_categories
    end
    alias categories child_categories

    def child_category_ids(parent_category_id=false)
      parent_category_id ||= category_id
      cat_ids = Category.select_values(:category_id) { |cid| 
        cid.where(Category.category_id_parent == parent_category_id)
      }.to_a.flatten.map { |cid| cid.to_i }
      sub_cat_ids = []
      cat_ids.each { |cid|
        sub_cat_ids += child_category_ids(cid)
      }
      cat_ids + sub_cat_ids
    end

  end 

end # module
end # module


