
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
  class Session

    @@logger     = Aurita::Log::Class_Logger.new('Aurita::Session')
    @@guest_user = Aurita::Main::User_Login_Data.load({ :user_group_id => 0 }) 

    attr_reader :cgi

    # Constructor expects CGI object of current request. 
    def initialize(cgi)
      @cgi  = cgi
      @user = false
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
      
      @user = false; 
      if !login.nil? && !pass.nil? then
        @@logger.log("set user login cookie")
        
        begin
          old_session = CGI::Session.new(@cgi, 
                                         'session_key' => 'cb_login', 
                                         'no_cookies'  => false, 
                                         'new_session' => false)
          old_session.delete
        rescue ::Exception => excep
          @@logger.log("Exception in delete old session: #{excep.message} | #{excep.backtrace.join("\n")}")
        end

        sticky = 'f'
        sticky = 't' if sticky

        session = CGI::Session.new(@cgi, 
                                   'session_key'     => 'cb_login', 
                                   'database_manager' => Aurita::Lore_Session_Manager, 
                                   'no_cookies'      => false, 
                                   'path'            => '/', 
                                   'new_session'     => true, 
                                   'user_group_id'   => user_group_id, 
                                #  'sticky'          => sticky, 
                                   'sticky'          => 'f', 
                                   'login'           => login, 
                                   'pass'            => pass, 
                                   'session_expires' => Time.now + 60 * 60 * 24 * 360 , # one year
                                #  'prefix'          => 'pstore_sid_', 
                                   'session_path'    => '/')
        session['login'] = login
        session['pass'] = pass
        session['time_from'] = (Time.now).strftime("%Y%m%d%H%M%S")
        session['user_group_id'] = user_group_id
        
        session.update()
        
        return session

      end
      
    end # def }}}

    # Delete this session's authentication cookie by setting its 
    # expiration time to a date in the past, then close this session. 
    def delete_user_login_cookie() 
    # {{{
      begin
        @@logger.log("delete user login cookie")
        @user = false
        session = CGI::Session.new(@cgi, 
                                   'session_key'    => 'cb_login', 
                                   'database_manager' => Aurita::Lore_Session_Manager, 
                                   'session_path'   => '/',
                                   'path'           => '/', 
                                #  'prefix'         => 'pstore_sid_', 
                                   'session_expires' => Time.now()-60*60*10,
                                   'new_session'    => false)
        
        session['user_group_id'] = 0
        session.update()
        session.delete()
        session.close()
      rescue ::Exception => excep
        @@logger.log("Exception in delete user login cookie: #{excep.message} | #{excep.backtrace.join("\n")}")
      end
    end # def }}}
    
    # Get cookie contents that authenticate this session's user as 
    # Array:
    #
    #   [ <user_group_id, <login as md5>, <pass as md5>, <session timestamp> ]
    #
    #   
    def get_user_login_cookie 
    # {{{
      begin
        @@logger.log("get user login cookie")
        benchmark_time = Time.now
        session = CGI::Session.new(@cgi, 
                                   'session_key'  => 'cb_login', 
                                   'database_manager' => Aurita::Lore_Session_Manager, 
                                   'new_session'  => false, 
                                #  'session_expires' => Time.now + 60 * 60 * 24 * 360 , # one year
                                #  'prefix'       => 'pstore_sid_', 
                                   'path'         => '/', 
                                   'session_path' => '/')
        @@logger.log("Session setup duration: #{Time.now-benchmark_time}s")
      rescue ::Exception => excep
        @@logger.log("Exception in get user login cookie: #{excep.message} | #{excep.backtrace.join("\n")}")
        raise excep unless excep.message.include?('session_key ')
      end
      
      if session then
        @@logger.log('restored session values: ' << [ session['user_group_id'], session['login'], session['pass'], session['time_from'] ].inspect)
        return [ session['user_group_id'], session['login'], session['pass'], session['time_from'] ]
      else 
        @@logger.log('NO SESSION TO RESTORE')
        @user = false
        return []
      end
      
    end # def }}}
    
    # Returns user of current session as User_Login_Data instance. 
    # In case user is not logged in, returns guest user (user_group_id 0) 
    # as User_Login_Data instance. 
    def user 
    # {{{
      if !@user then
        @@logger.log('Loading user from session')
        cookie_array = get_user_login_cookie
        if cookie_array.nil? then return nil end
        @user = User_Login_Data.load({ :user_group_id => cookie_array[0] }) 
        @user = @@guest_user unless @user
      end
      return @user
    end # }}}

    # Overwrites (or sets) this session's user. 
    # Expects instance of User_Login_Data or User_Group. 
    def user=(user)
      @user = user
    end
     
    # Returns active interface language for this session
    def language
      :de
    end

  end # class

  # Mock session for batch mode. 
  # The following methods are overloaded to do nothing: 
  #  
  #  - get_user_login_cookie
  #  - set_user_login_cookie
  #  - delete_user_login_cookie
  #
  # Note that in batch mode, the session's user has to be 
  # set manually, as operations on cookies are ignored: 
  #
  #   Aurita.session.user = User_Group.load(:user_group_id => 1000)
  #
  class Batch_Session < Session
    def initialize(req=nil)
    end
    def get_user_login_cookie
    end
    def set_user_login_cookie
    end
    def delete_user_login_cookie
    end
  end
  
end # module
