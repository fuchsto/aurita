
require('aurita')
require('digest/md5')

begin
  Aurita::Main.import_model :user_login_data
rescue ::Exception => ignore
  # No project loaded? 
end

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
  # ... and read via: 
  #
  #   session_param = Aurita.session['your_param']
  #
  class Session

    @@logger = Aurita::Log::Class_Logger.new('Aurita::Session')
    begin
      @@guest_user = Aurita::Main::User_Group.load({ :user_group_id => 0 }) 
    rescue ::Exception => ignore
    end

    attr_reader :session_id

    # Constructor expects CGI object of current request. 
    def initialize(rack_request)
      @user          = false
      @env           = rack_request.env
      raise ::Exception.new("Cowardly refusing to open a session without a request environment") unless @env

      @session_opts = @env['rack.session.options']
      @session_id   = @session_opts[:id] if @session_opts
    end

    # Open session for a user. 
    # This is to be called e.g. after validating the user's 
    # credentials after logon. 
    # Returns session id created for this user. 
    def open(user)
      @session                ||= @env['rack.session']
      @session['user_group_id'] = user.user_group_id
      @session['user']          = Marshal.dump(user)
      @session_id
    end

    def param(key)
      @session ||= @env['rack.session']
      @session[key.to_s]
    end
    alias [] param

    def set_param(key, value)
      @session         ||= @env['rack.session']
      @session[key.to_s] = value
    end
    alias []= set_param

    # Returns user of current session as User_Login_Data instance. 
    # In case user is not logged in, returns guest user (user_group_id 0) 
    # as User_Login_Data instance. 
    def user
      return @user if @user
      marshal = param('user')
      if marshal then
        @user = Marshal.load(marshal)
        return @user if @user
      end

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
    #  @session = false
    #  @user    = @@guest_user
      if @env['rack.session'] then
        @env['rack.session'][:close] = true
        @env['rack.session'][:drop]  = true
      end
      if @env['rack.session.options'] then
        @env['rack.session.options'][:close] = true
        @env['rack.session.options'][:drop]  = true
      end
    end # def }}}
    
    # Returns active interface language for this session
    def language
      param('lang') || (user && user.language)? user.language : Aurita.project.default_language
    end
    alias lang language

  end # class

  # Fake session for tests, batch / console mode, or whenever 
  # no real session is available. 
  class Mock_Session < Session

    begin
      @@guest_user = Aurita::Main::User_Login_Data.create_shallow({ :user_group_id   => 0, 
                                                                    :user_group_name => 'guest', 
                                                                    :login           => 'mock', 
                                                                    :pass            => 'mock' }) 
    rescue ::Exception => ignore
    end

    def initialize(request=nil)
      @params = {}
      @user   = false
    end

    def param(key)
      @params[key]
    end
    alias [] param

    def set_param(key, value)
      @params[key] = value
    end
    alias []= set_param
    
    def user()
      @user || @@guest_user
    end

    def user=(user)
      @user = user
    end

    def open(user)
      raise ::Exception.new("Cannot open a Mock_Session")
    end

    def close()
      raise ::Exception.new("Cannot close a Mock_Session")
    end

  end
  
end # module
