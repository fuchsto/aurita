
require('aurita')
require('digest/md5')

Aurita::Main.import_model :user_login_data

module Aurita

  # Proxy class for real Rack::Session. 
  # Within your application, this class is used indirectly 
  # via Aurita.session or Aurita.user ( = Aurita.session.user). 
  #
  # Aurita.user returns the User_Group instance of the current user: 
  #
  #    puts 'Your user name is ' << Aurita.user.user_group_name
  #    puts 'Your user id is ' << Aurita.user.user_group_id
  #
  # In case the user is not logged in, the guest user instance 
  # (user with user_group_id = 0) will be returned. 
  # Note that the guest user is a singleton, so changes on this 
  # instance will affect all users that aren't logged in. 
  #
  # Session variables can be set via: 
  #
  #   Aurita.session['your_param'] = 'value'
  #
  # .. and read via: 
  #
  #   session_param = Aurita.session['your_param']
  #
  class Session

    @@logger     = Aurita::Log::Class_Logger.new('Aurita::Session')
    @@guest_user = Aurita::Main::User_Login_Data.load({ :user_group_id => 0 }) 

    attr_reader :session_id

    # Constructor expects CGI object of current request. 
    def initialize(rack_request)
      @user         = false
      @env          = rack_request.env
      @session_opts = @env['rack.session.options']
      @session_id   = @session_opts[:id] if @session_opts
    end

    def param(key)
      @session ||= @env['rack.session']
      @session[key.to_s]
    end
    alias [] param

    def set_param(key, value)
      @session ||= @env['rack.session']
      @session[key.to_s] = value
    end
    alias []= set_param

    # Returns user of current session as User_Login_Data instance. 
    # In case user is not logged in, returns guest user (user_group_id 0) 
    # as User_Login_Data instance. 
    def user
      return @user if @user
      user_id = param('user_group_id')
      @user   = Aurita::Main::User_Group.load(:user_group_id => user_id)
      return (@user || @@guest_user)
    end

    # Overwrites (or sets) this session's user. 
    # Expects instance of User_Login_Data or User_Group. 
    def user=(user)
      @user = user
    end
     
    # Delete this session's authentication cookie by setting its 
    # expiration time to a date in the past, then close this session. 
    def close() 
    # {{{
      @@logger.log("delete user login cookie")
      @env['rack.session'][:drop] = true
      @env['rack.session'][:close] = true
      @env['rack.session.options'][:drop] = true
      @env['rack.session.options'][:close] = true
    end # def }}}
    
    # Returns active interface language for this session
    def language
      param('lang') || :de
    end

  end # class
  
end # module
