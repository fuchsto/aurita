
require('aurita')

Aurita.import 'handler/aurita_application'

module Aurita
module Console

  # Console module that simulates complete dispatch 
  # run on a CGI request and prints output. 
  #
  # Usage: 
  #
  #    aurita <project name> dispatch [ <Controller> <method> [ param=value param2=value ] ]
  #
  # Default is 
  #
  #    controller: App_Main
  #    method: start
  #
  # Example: 
  #
  #   dispatch Wiki::Article show article_id=123 user_group_id=1
  #
  class Dispatch

    def initialize(argv)
      # Fake a request
      
      params = {}
      params[:mode]       = 'default'
      params[:controller] = 'App_Main'
      params[:action]     = 'start'
      params[:controller] = argv[0].to_s if argv[0]
      params[:action]     = argv[1].to_s if argv[1]
      params[:args]       = argv[2] if argv[2]

      @params     = params

      puts '============================================================='
      puts 'Dispatching with request parameters: '
      pp @params
      puts '============================================================='

      user_group_id   = params['user_group_id'].first if params['user_group_id']

      @old_session_user   = Aurita.session.user
      Aurita.session.user = User_Profile.load(:user_group_id => user_group_id) if user_group_id

    end

    def run
      app = Aurita::Handler::Aurita_Dispatch_Application.new
      controller = @params[:controller]
      action     = @params[:action]

      args = []
      @params[:args].each_pair { |k,v|
        args << "#{k}=#{v}"
      }
      uri = "/aurita/#{controller}/#{action}/#{args.join('&')}"
      env = Rack::MockRequest.env_for(uri)

      puts "Request: #{uri}"
      puts "Mock ENV: "
      pp env

      response = app.call(env)
      Aurita.session.user = @old_session_user

      return response
    end

    def usage
      "Usage: 
      
          aurita.dispatch [ <Controller> <method> [ param=value param2=value ] ]
      
       Default is 
      
          controller: App_Main
          method: start
      
       Example: 
      
         dispatch Wiki::Article show article_id=123 user_group_id=1
      "
    end

  end

end
end

