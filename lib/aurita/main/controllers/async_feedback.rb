
module Aurita
module Main

  class Async_Feedback_Controller < App_Controller

    @@users_online = []
    @@last_mod = Time.now

    def get

      json = {}

      if @@users_online.length == 0 or (Time.now > @@last_mod+(60*5)) then
        @@users_online = User_Online.current_users.map { |u| u = u.user_group_id }
      end

      json[:unread_mail] = User_Message.value_of.count(:user_message_id).with(
                          (User_Message.user_group_id == Aurita.user.user_group_id) & (User_Message.read == 'f')
                        ).to_i

      recently_viewed = []
      recently_viewed = Article.access_of_user(Aurita.user.user_group_id, 5).map { |a| a = a.article_id } if Aurita.user.is_registered?
      json[:users_online] = '[' << @@users_online.join(',') + ']'

      puts '{'
      puts json.collect { |k,v| "#{k}: #{v}" }.join(",\n")
      puts '}'
    end

  end

end
end
