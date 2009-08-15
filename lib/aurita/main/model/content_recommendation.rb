
require('aurita/model')

module Aurita
module Main

  class Content_Recommendation < Aurita::Model

    table :content_recommendation, :public
    primary_key :content_recommendation_id, :content_recommendation_id_seq

    has_a User_Group, :user_group_id

  end

end
end
