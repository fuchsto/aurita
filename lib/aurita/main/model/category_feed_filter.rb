
require('aurita/model')

module Aurita
module Main

  class Category_Feed_Filter < Aurita::Model
    table :category_feed_filter, :public
    primary_key :user_group_id

    add_output_filter(:category_ids) { |v|
      v[1..-2].split(',').map { |x| x.to_i }
    }

    def self.toggle(params={})
      user   = params[:user]
      user ||= Aurita.user
      cat_id = params[:category_id].to_i

      filter = find(1).with(:user_group_id => user.user_group_id).entity
      if filter then
        filtered   = filter.category_ids 
        filtered ||= []
        if filtered.include?(cat_id) then
          filtered.delete(cat_id)
        else 
          filtered << cat_id
        end
        filter.category_ids = filtered
        filter.commit
      else
        create(:user_group_id => user.user_group_id, :category_ids => [ cat_id ])
      end
    end

    def self.for(user)
      filter = find(1).with(:user_group_id => user.user_group_id).entity
      return filter.category_ids if filter
      return []
    end

  end

end
end

