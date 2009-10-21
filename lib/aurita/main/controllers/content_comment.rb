
require('aurita/controller')

module Aurita
module Main

  class Content_Comment_Controller < App_Controller

    def toolbar_buttons
      new_comments = HTML.a(:class => :icon, 
                            :onclick => "Aurita.load({ action: 'Content_Comment/list_recentyl_commented' });") { 
        HTML.img(:src => '/aurita/images/icons/comment.gif') + 
        tl(:new_asset_comments) 
      }
      return new_comments
    end

    def list_string(content_id)

      content = Content.find(1).with(:content_id.is(content_id)).entity

      entries = Content_Comment.select { |p|
        p.join(User_Profile).on(Content_Comment.user_group_id == User_Profile.user_group_id) { |pu|
          pu.where((Content_Comment.content_id == content_id))
          pu.order_by(:time, :asc)
        }
      }

      view_string(:content_comment_list, 
                  :entries => entries, 
                  :content => content)
    end

    def box
      box = Box.new(:id => :content_comment_box, :class => :topic_inline)

      box.header = tl(:comments)
      box.body = list_string(param(:content_id))

      box
    end

    def list
      content_id   = param(:content_id)
      content_id ||= param('?content_id')
      puts list_string(content_id)
    end

    def recent_comments_box(params={})
      amount   = params[:amount]
      amount ||= 3

      box = Box.new(:type => :none, :class => :topic_inline, :id => :content_comment_box)
      box.header = tl(:recent_comments)
      body = ''
      comments = Content_Comment.find(amount).with((Content_Comment.is_accessible) & (Content_Comment.time > (Time.now - 7.days))).sort_by(:time, :desc).entities
      return unless comments.length > 0
      comments.each { |c|
        begin
          concrete_content = Content.find(1).with(Content.content_id == c.content_id).entity.concrete_instance
          comment_user     = User_Group.load(:user_group_id => c.user_group_id)
          body << HTML.div(:class => [:index_entry, :comment_list_entry]) { 
            HTML.div.image { 
              link_to(comment_user) { comment_user.label } + 
              " #{tl(:user_comment_to)} " +
              link_to(concrete_content) { concrete_content.title }
            } + 
            HTML.div.text { 
              if c.message.to_s.length > 196 then
                c.message.to_s.strip[0..200] + ' ...'
              else
                c.message.to_s
              end
            }
          }
        rescue ::Exception => content_deleted
        end
      }
      box.body = body
      box
    end

    def perform_add
      instance = super()
      plugin_call(Hook.main.content_comment.created, :content_comment => instance)
      redirect_to(:controller => 'Content_Comment', :action => :list, :content_id => instance.content_id, :target => :content_comment_box_body)
    end

    def perform_delete
      instance = Content_Comment.load(:content_comment_id => param(:content_comment_id))
      return unless ((instance.user_group_id == Aurita.user.user_group_id) || (Aurita.user.is_admin?))
      super()
    end
    
  end # class
  
end # module
end # module

