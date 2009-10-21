
require('aurita/model')

module Aurita
module Main

  class Component_Position < Aurita::Model
    table :component_position, :public
    primary_key :component_position_id, :component_position_id_seq

    expects :gui_context
    expects :user_group_id
    expects :position
    expects :component_dom_id
  end

end
end

