
require('aurita/controller')
Aurita::Main.import_model :content_recommendation

Aurita.import_plugin_model :wiki, :article
Aurita.import_plugin_model :messaging, :user_message

module Aurita
module Main 

  class Content_Recommendation_Controller < App_Controller

    def perform_add
      user_from = User_Profile.load(:user_group_id => Aurita.user.user_group_id)
      username = "#{user_from.user_group_name}  (#{user_from.forename} #{user_from.surname})"
      case param(:type) 
        when 'ARTICLE' then
          article = Wiki::Article.find(1).with(Wiki::Article.content_id == param(:content_id)).entity
          content_name = article.title
          content_link = "Wiki::Article/show/article_id=#{article.article_id}"
          message = tl(:article_recommendation_message)
          subject = tl(:article_recommendation_subject)
        when 'ASSET' then
          media_asset = Wiki::Media_Asset.find(1).with(Wiki::Media_Asset.content_id == param(:content_id)).entity
          content_name = media_asset.title.to_s
          content_link = "Wiki::Media_Asset/show/media_asset_id=#{media_asset.media_asset_id}"
          message = tl(:asset_recommendation_message)
          subject = tl(:asset_recommendation_subject)
      end
      param(:user_group_ids, []).each { |uid| 
        Content_Recommendation.create(:content_id => param(:content_id), 
                                      :user_group_id => uid, 
                                      :type => param(:type), 
                                      :message => param(:message), 
                                      :user_group_id_from => Aurita.user.user_group_id)
        message_body = message.gsub('{1}', username).gsub('{2}', content_name).gsub('{3}', content_link)
        message_body << '<br /><br />'
        message_body += param(:message).gsub("\n", '<br />')
        Messaging::User_Message.create(:user_group_id => uid, 
                                       :user_group_id_from => Aurita.user.user_group_id, 
                                       :system_message => 't', 
                                       :title => subject.gsub('{1}', content_name), 
                                       :message => message_body)
      } 
    end

    def editor
      content = Content.load(:content_id => param(:content_id))

      user_select = User_Selection_List_Field.new(:name => :user_group_ids)

      render_view(:content_recommendation_editor, 
                  :content => content, 
                  :content_type => param(:type), 
                  :username_autocompleter => user_select)

      exec_js("Aurita.Main.init_autocomplete_single_username();")
    end

  end

end
end
