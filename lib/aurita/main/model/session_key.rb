
require('aurita/model')

module Aurita
 
  # :nodoc: 
  class Session_Key < Aurita::Model
    table :user_online, :public
    primary_key :session_id

    expects :time_mod
  end

end
