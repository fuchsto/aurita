
class CGI
  
  attr_reader :get_params
  def get_params
    if !@get_params then
      @get_params = {}
      env_table['REQUEST_URI'].split('?')[-1].split('&').each { |key_value|
        key_value_pair = key_value.split('=')
        @get_params[key_value_pair[0]] = key_value_pair[1]
      }
    end
    @get_params
  end
  
end

