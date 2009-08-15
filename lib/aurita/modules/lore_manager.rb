
require('aurita')
require('cgi')

Aurita::Main.import_model :session_key


module Aurita

  Session_Key.prepare(:get, Lore::Type.text) { |sk|
    sk.where((Session_Key.session_id == Lore::Clause.new('$1')) & 
             (Session_Key.time_to.is_null))
    sk.limit(1)
  }


  class Lore_Session_Manager

    @@buffer = Hash.new
    
  private

    def parse_hash(hash)
      phash = {}
      if hash then
        hash.each_pair { |k,v|
          phash[k.to_s] = v.to_s
        }
      end
      phash
    end

  public

    @@logger = Aurita::Log::Class_Logger.new('Session::Lore_Manager')
    
    def initialize(session, args={})
      @session_id = session.session_id.gsub(/\s/,'')
      @session_entity = false

      @@logger.log('init')

      args['user_group_id'] = '0' unless args['user_group_id']

      @session_entity = @@buffer[@session_id]
      if !@session_entity then
        @@logger.log('No session entity')
        @session_entity = Session_Key.get("'#{@session_id}'").first
        if @session_entity then
          @@logger.log('Got session entity from DB')
          @session_entity[:time_mod] = Aurita::Datetime.now(:sql)
          @session_entity.commit
        else
          @@logger.log('No session entity in DB')
          # Close all prior sessions of this user: 
          Session_Key.update { |s|
            s.where(s.user_group_id == args['user_group_id']) 
            s.set(:time_to => Aurita::Datetime.now(:sql))
          }
          @@logger.log('Creating new session entity')
          # Create new session for user: 
          @session_entity = Session_Key.create(:session_id => @session_id, 
                                               :user_group_id => args['user_group_id'], 
                                            #  :sticky => args['sticky'], 
                                               :sticky => 'f', 
                                               :time_mod => Aurita::Datetime.now(:sql), 
                                               :time_from => Aurita::Datetime.now(:sql)
                                              ) 
        end
        # NOT FOR MULTIPLE THREADS!!
        # @@buffer[@session_id] = @session_entity
      else 
        @@logger.log('Found session entity. Doing nothing. ')
      end
    end

    def restore
      @@logger.log('RESTORE session')
      @session_entity = @@buffer[@session_id]
      unless @session_entity
          @@logger.log('Load session_entity from DB')
          @session_entity = Session_Key.get("'#{@session_id}'").first unless @session_entity
          @@buffer[@session_id] = @session_entity
      end
      hash = @session_entity.attr if @session_entity
      parse_hash(hash)
    end

    def update
      @@logger.log('UPDATE session')
      parse_hash(@session_entity.attr).each_pair { |k,v|
        @session_entity[k.to_s.intern] = CGI::escape(v)
      }
      parse_hash(@hash)
    end

    def delete
      @@logger.log('DELETE session')
      @@buffer[@session_id] = false
      @hash = false
      Session_Key.delete { |s|
        s.where(s.user_group_id == @session_entity.user_group_id)
      }
    #  @session_entity[:time_to] = Time.now.to_s
    #  @session_entity.commit
    end

    def close
      @@logger.log('CLOSE session')
      # nothing to do here as Lore's DB connections are pooled
    end

  end

end
