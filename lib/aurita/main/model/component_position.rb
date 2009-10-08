
require('aurita/model')

module Aurita
module Main

  class Component_Position < Aurita::Model
    table :component_position, :public
    primary_key :component_position_id, :component_position_id_seq
  end

end
end

