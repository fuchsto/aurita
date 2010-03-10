
require('aurita')
Aurita::Main.import_model :content_permissions
Aurita::Main.import_model :strategies, :abstract_accessor_strategy
Aurita::Main.import_model :behaviours, :categorized

module Aurita
module Main

  class Category_Based_Accessor < Abstract_Accessor_Strategy

    # Usage: 
    #
    #   Model_Klass.use_accessor_strategy(Concrete_Accessor, 
    #                                     :managed_by => Content_Category, 
    #                                     :mapping    => { :content_id => :category_id })
    #
    # 
    def self.on_use(klass, params=false)
      klass.extend(Categorized_Accessor_Class_Behaviour)
      if params then
        klass.use_category_map(params[:managed_by], params[:mapping])
      end
    end

  end

end
end

