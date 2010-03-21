
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

end
end
