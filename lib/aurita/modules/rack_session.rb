
require('aurita')
require('digest/md5')
require('cgi')
require('cgi/session')
# require('cgi/session/pstore')

Aurita.import_module :lore_manager
Aurita::Main.import_model :user_login_data

module Aurita


  # Proxy class for real CGI session. 
  # Will be refactored to proxy class for Rack session, but 
  # usage won't be affected. 
  #
  # 
  #
  class Rack_Session

    @@logger     = Aurita::Log::Class_Logger.new('Aurita::Session')
    @@guest_user = Aurita::Main::User_Login_Data.load({ :user_group_id => 0 }) 

    attr_reader :session_id

    # Constructor expects CGI object of current request. 
    def initialize(rack_request)
      @user         = false
      @env          = rack_request.env
      @session_opts = @env['rack.session.options']
      @sid          = @session_opts[:id] if @session_opts
      STDERR.puts 'SESSION ID: ' << @sid.inspect
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
     
    # Set a new authentication cookie for this session containing 
    # the given parameters: 
    #
    # - login: Login of user as MD5
    # - pass:  Password of user as MD5
    # - user_group_id: ID of user
    #
    def set_user_login_cookie(login, pass, user_group_id, sticky='f')
    # {{{
      set_param('user_group_id', user_group_id)
    end # def }}}

    # Delete this session's authentication cookie by setting its 
    # expiration time to a date in the past, then close this session. 
    def delete_user_login_cookie() 
      @@logger.log("delete user login cookie")
    # {{{
    end # def }}}
    
    # Get cookie contents that authenticate this session's user as 
    # Array:
    #
    #   [ <user_group_id, <login as md5>, <pass as md5>, <session timestamp> ]
    #
    #   
    def get_user_login_cookie 
    # {{{
      @@logger.log("get user login cookie")
    end # def }}}

    # Returns active interface language for this session
    def language
      :de
    end

  end # class
  
end # module
