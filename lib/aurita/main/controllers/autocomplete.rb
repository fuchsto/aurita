
require('aurita')
require('aurita/controller')
Aurita.import_module :gui, :autocomplete_result
Aurita.import_plugin_model :wiki, :article
Aurita.import_plugin_model :wiki, :media_asset
Aurita.import_plugin_model :bookmarking, :bookmark


module Aurita
module Main

  class Autocomplete_Controller < App_Controller

    def find_users(params={})
      return unless params[:keys]
      return unless Aurita.user.is_registered? 

      user_constraints = (User_Login_Data.locked == 'f')
      params[:keys].each { |k|
        k << '%'
        user_constraints = user_constraints & 
                           ((User_Group.user_group_name.ilike('%' << k)) | 
                            (User_Profile.tags.has_element_ilike(k)))
      }
      user_result = Autocomplete_Result.new()
      User_Profile.all_with(user_constraints).sort_by(User_Profile.user_group_name, :asc).each { |u|
        user_result.entries << { :id => "User_Group__#{u.user_group_id}", 
                                 :title => u.user_group_name, 
                                 :header => tl(:users), 
                                 :class => :autocomplete_user, 
                                 :informal => tl(:user) + ": #{u.tags}" }
      }
      return user_result
    end

    def all
    # {{{
      key = param(:key).to_s.downcase
      return if key == ''

      keys = key.to_s.split(' ')

      items = ''
      plugin_get(Hook.main.autocomplete_search.all, :keys => keys).each { |result|
        result.element.each { |entry|
          items << entry.string
        }
      }

      puts '<ul class="autocomplete" style="width: 419px; " >'
      puts '<li class="autocomplete autocomplete_first_entry autocomplete_space_bottom" 
                style="border-bottom: 1px solid #454545; width: 420px; height: 35px; " 
                id="find_all__'<< param(:key) << '">
              <nobr>
                <b>' << tl(:show_all) + '</b>
              </nobr>
              <br />
              <br />
            </li>'

      puts items

      puts '<li class="autocomplete autocomplete_first_entry autocomplete_space_bottom" 
                style="width: 420px; height: 35px; " 
                id="find_full__'<< param(:key) + '">
              <nobr>
                <b>' << tl(:fulltext_search) + '</b>
              </nobr>
              <br />
              <br />
           </li>'
      puts '</ul>'

    end # }}}

    def articles
    # {{{
      use_decorator(:none)
     
      puts '<ul class="autocomplete">'
      articles = Wiki::Article.find(10).with(
                 (Wiki::Article.title.ilike('%' << param(:key) + '%')) |
                 (Wiki::Article.tags.has_element_ilike(param(:key).to_s+'%'))).entities

      count = 1
      style = ' autocomplete_first_entry'
      articles.each { |a|
        puts "<li class=\"autocomplete autocomplete_default #{style}\" id=\"article__#{a.article_id}\"><nobr>#{a.title}</nobr></li>"
        style = ''
        count += 1
      }

      puts '</ul>'
    
    end # }}}

    def usernames
    # {{{
      
      key = param(:usernames).to_s.downcase

      not_hidden = (User_Group.hidden == 'f') & (User_Login_Data.locked == 'f')
      user_constraints = (not_hidden & (User_Group.user_group_name.ilike('%' << key + '%')) | not_hidden & (User_Profile.tags.has_element(key)))

      puts '<ul class="autocomplete">'
      users = User_Profile.find(10).with(user_constraints).entities
      count = 1
      users.each { |a|
        puts '<li class="autocomplete autocomplete_default" name="' << a.user_group_name + '" id="user__'<< a.user_group_id << '"><nobr><b>' << a.user_group_name << '</b></nobr><span class="informal"><br />Benutzer</span></li>'
        style = ''
        count += 1
      }
      puts '</ul>'

    end # }}}

    def tags
      use_decorator(:none)

      keys = param(:tags)
      return unless keys

      keys.strip!
      key = keys.split(' ')[-1].downcase
      puts '<ul class="autocomplete">'
      Tag_Relevance.all_with(Tag_Relevance.tag.ilike(key.to_s + '%') | Tag_Relevance.tag.in(
        Tag_Synonym.select(:synonym) { |s|
          s.where(s.tag.ilike("#{key.to_s}%"))
        }
      )).sort_by(:hits, :desc).limit(7).each { |ti|
        info = "#{tl(:tag_relevance)}: #{ti.hits.to_s}"
        entry = ti.tag.downcase.gsub(key,"<b>#{key}</b>")
        if !ti.tag.include?(key.to_s) then
          info = "Synonym: #{ti.hits.to_s}"
        end
        puts HTML.li(:class => [ :autocomplete, :autocomplete_default ], 
                     :name => ti.tag, 
                     :id => "tag_#{ti.tag}") { 
                HTML.div(:style => 'width: 190px; float: left; ') { entry }  + 
                HTML.div.informal(:style => 'float: left;') { info } + 
                HTML.div(:style => 'clear: both;')
             }.to_s
      }
      puts '</ul>'
    end



  end # class
  
end # module
end # module
