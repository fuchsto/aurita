
module Aurita

  User_Group.use_accessor_strategy(Category_Based_Accessor, 
                                   :managed_by => User_Category, 
                                   :mapping    => { :user_group_id => :category_id})

  Content.use_access_strategy(Category_Based_Access, 
                              :managed_by => Content_Category, 
                              :mapping    => { :content_id => :category_id } )
  Hierarchy.use_access_strategy(Category_Based_Access, 
                                :managed_by => Hierarchy_Category, 
                                :mapping    => { :hierarchy_id => :category_id } )
  Content_Comment.use_access_strategy(Category_Based_Access, 
                                      :managed_by => Content_Category, 
                                      :mapping    => { :content_id => :category_id } )

end

