
require('aurita/model')

module Aurita
module Main

  # Instances of Role do not offer any functionality themselves, 
  # apart from attributes #role_id and #role_name. 
  #
  # Mapping users to roles is implemented in model User_Role, 
  # validating a user's permission set is defined in model 
  # Role_Permission. 
  #
  class Role < Aurita::Model

    table :role, :internal
    primary_key :role_id, :role_id_seq
    
    use_label :role_name
    expects :role_name

    translate_field :role_name
    
  end # class

end # module
end # module
