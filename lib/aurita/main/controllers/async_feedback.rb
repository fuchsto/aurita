
module Aurita
module Main

  class Async_Feedback_Controller < App_Controller

    @@users_online = []
    @@last_mod = Time.now

    def get
      json = {}

      plugin_get(Hook.main.poll_feedback).each { |json_response| json.update(json_response) }

      puts '{'
      puts json.collect { |k,v| "#{k}: #{v}" }.join(",\n")
      puts '}'
    end

  end

end
end
