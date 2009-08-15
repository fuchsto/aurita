
require('aurita/model')

module Aurita
module Main

  class Hierarchy_Category < Aurita::Model
      
    table :hierarchy_category, :public
    primary_key :hierarchy_id
    primary_key :category_id

    def self.create_for(hierarchy, category_ids)
      category_ids.each { |cid| 
        create(:hierarchy_id => hierarchy.hierarchy_id, 
               :category_id => cid)
      }
    end

    def self.update_for(hierarchy, category_ids)
      delete { |cc|
        cc.where(Hierarchy_Category.hierarchy_id == hierarchy.hierarchy_id)
      }
      create_for(hierarchy, category_ids)
    end
  end

  class Hierarchy
  extend Aurita::Categorized_Behaviour

    def category_ids
      if !@category_ids then
        @category_ids = Hierarchy_Category.select_values(:category_id) { |cid|
          cid.where(:hierarchy_id.eq(hierarchy_id))
        }
      end
      return @category_ids
    end

    use_category_map(Hierarchy_Category, :hierarchy_id => :category_id)
    
  end 

end
end
