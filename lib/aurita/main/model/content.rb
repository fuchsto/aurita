
require('aurita/model')
Aurita.import_module :tagging
Aurita.import_module :access_strategy
Aurita::Main.import_model :user_group
Aurita::Main.import_model :tag_index
Aurita::Main.import_model :category
Aurita::Main.import_model :tag_relevance
Aurita::Main.import_model :behaviours, :categorized

module Aurita
module Main

  class Category < Aurita::Model
    # forward declaration
  end

  class Content_History < Aurita::Model
    # forward declaration
  end

  # Content an abstract, polymorphic base model for every business object 
  # acting as an information container of any kind, such as wiki articles, 
  # files, todo lists and so on. 
  # 
  # All classes derived from Content inherit the following behaviours: 
  #
  # - Taggable_Behaviour: Tags can be assigned to an instance of a model. 
  #   Necessary for e.g. search and index operations. 
  # - Categorized_Behaviour: Categories can be assigned to an instance of a model. 
  #   Implicitly offers permission management on this instance. 
  #
  # Every Content instance has an assigned User_Group (author and implicit 
  # possessor of this instance) and timestamps 'created' and 'changed'. 
  #
  class Content < Aurita::Model
  # {{{
    extend Aurita::Taggable_Behaviour
    extend Aurita::Categorized_Class_Behaviour
    include Aurita::Access_Strategy

    @@logger = Aurita::Log::Class_Logger.new(self.to_s)

    table :content, :public
    primary_key :content_id, :content_id_seq

    is_polymorphic :concrete_model
    
    has_a User_Group, :user_group_id

    explicit :created, :changed
    
    expects :tags

    hide_attribute :user_group_id

    use_category_map Content_Category, { :content_id => :category_id }

    def user_group
      u =   User_Group.load(:user_group_id => user_group_id)
      u ||= User_Group.load(:user_group_id => 5)
    end
    def user_profile
      u =   User_Profile.load(:user_group_id => user_group_id)
      u ||= User_Profile.load(:user_group_id => 5)
    end
    
    # CMS Worldwide Hype, Ajax => {cms,worldwide,hype,ajax}
    add_input_filter(:tags) { |tags| 
      if !tags.is_a?(Array) then
        tags = tags.to_s
        tags = tags.squeeze(' ')
        tags.strip!
        tags = tags.split(' ')
      end
      tags.map! { |t| 
        t = t.to_s.downcase
        t.gsub!("'","\'")
        t.gsub!('{','')
        t.gsub!('}','')
        t.gsub(',','') 
      }
      tags = tags.reject { |t| t.to_s.length < 3 }
      tags.uniq!
      tags = tags.join(',')
      tags = '{' << tags + '}'
      tags
    }
    # {cms,worldwide,hype,ajax} => cms worldwide hype ajax
    add_output_filter(:tags) { |tags| 
      tags = tags.to_s
      tags.gsub!("'",'&apos;')
      tags.gsub!("\"",'')
      tags.sub!('{','')
      tags.sub!('}','')
      tags.gsub!(',',' ')
      tags = tags.squeeze(' ')
      tags = tags.split(' ')
      tags.map! { |t| t.downcase!; t }
      tags.uniq!
      tags = tags.join(' ')
      tags
    }

    # Called on every commit on an instance of Content. 
    # Expexts optional argument hash of attribute values to be committed, or an
    # instance of Content to be committed. 
    # Returns true if this commit should be saved as a new content version, 
    # otherwise false. 
    #
    def self.touch_on_update(args=nil)
      true
    end
    
    # Operations to perform befoe writing an instance to DB, such as: 
    # - Setting user_group_id (owner of this instance) according to Aurita.user
    # - Setting timestamps (created, changed)
    # etc. 
    def self.before_create(args)
      args[:user_group_id] = Aurita.user.user_group_id if Aurita.user
      args[:changed] = Aurita::Datetime.now(:sql)
      args[:created] = Aurita::Datetime.now(:sql)
      return args
    end

    # Updates timestamp 'changed' of this instance when changing one of its 
    # attributes. 
    # Prohibits changed on timestamp 'created'. 
    def self.before_update(args)
      if touch_on_update?(args)
        args[:changed] = Aurita::Datetime.now(:sql) 
      else
        args.delete(:changed)
      end

      args.delete(:created)
      return args
    end

    # Operations to perform after having written an instance to DB 
    # (creating tag index etc.)
    def self.after_create(instance)
      Tag_Index.create_index_for(instance)
      Tag_Relevance.add_hits_for(instance)
    end
    
    # Operations to perform after writing an instance to DB 
    # (updating tag index). 
    def self.after_commit(instance)
      Tag_Index.update_index_for(instance)
      instance.categories.each { |c| c.touch }
    end

    def self.after_delete(args)
      if args[:content_id] then
        Content_Category.delete { |cc|
          cc.where(Content_Category.content_id == args[:content_id]) 
        }
      end
    end

    # Increments hit count for this instance. To be triggered whenever 
    # this instance is viewed within the application. 
    def increment_hits
      if Aurita.user.user_group_id != user_group_id then
        set_attribute_value('hits', hits.to_i + 1)
        commit
        Tag_Relevance.add_hits_for(instance)
      end
    end

    # Add tags to this Content instance and update Tag_Index for it. 
    # Example: 
    #   
    #   content = Article.load(:article_id => 42)
    #   content.add_tags(:foo, :bar, 'batz')
    # or
    #   content.add_tags('foo bar batz')
    #
    #   content.commit # Instance has to be commited to be written to DB
    #
    # Also see Content#add_tags!
    #
    def add_tags(*tags_string_or_list)
      new_tags = tags.split(' ')
      if tags_string_or_list.length == 1 then
        tags_string_or_list = tags_string_or_list.first.to_s.split(' ')
      end
      new_tags += tags_string_or_list
      new_tags.map! { |t| t.to_s.downcase.to_sym }
      new_tags.uniq!

      set_attribute_value(:tags => new_tags.join(' '))
    end
    alias add_tag add_tags

    # Like Content#add_tags, but also commits changes to DB 
    # immediately. 
    def add_tags!(tags_string_or_array)
      add_tags(tags_string_or_array)
      commit
    end
    alias add_tag! add_tags!
    
    # Mark changes on this instance. 
    # Content.touch is to be called whenever non-meta attributes
    # of an instance have changed, such as text in an article. 
    # A record of Content_History is created when calling this method. 
    #
    # This might trigger cache invalidation for an instance and its 
    # categories. 
    #
    def self.touch(content_id, action='CHANGED')
      now = Aurita::Datetime.new.string(:sql)
      
      #  Content.set(:changed => now).where(
      #    Content.content_id == content_id
      #  ).perform
      Content.update { |c|
        c.set(:changed => now) 
        c.where(Content.content_id == content_id)
      } 
      Content_History.create(:time          => now, 
                             :user_group_id => Aurita.user.user_group_id, 
                             :content_id    => content_id, 
                             :type          => action)
      Aurita.log { "Touching categories of content #{content_id}..." }
      Content_Category.all_with(:content_id.is(content_id)).each { |cat|
        Aurita.log { "Touching category #{cat.category_id} ..." }
        Category.touch(cat.category_id)
      }
    end

    # See Content.touch
    def commit()
      res   = super() 
      klass = false
      if self.class == Content then
        klass = concrete_instance().class
      else
        klass = self.class
      end
      if res && klass.touch_on_update?(self) then
        Content.touch(content_id)
      end
    end
    
    # Returns number of comments on this Content instance as Integer. 
    def num_comments
      Content_Comment.value_of.count(:content_id).where(Content_Comment.content_id == content_id).to_i
    end

    
  end # class }}}

  class User_Group < Aurita::Model

    # Whether user has read permissions on given Content instance. 
    # Behaviour depends on the content's access strategy. 
    def may_view_content?(content)
      content.access_strategy.permits_read_access_for(self)
    end 
    
    # Whether user has permissions to perform changes on given Content instance. 
    # Behaviour depends on the content's access strategy. 
    def may_edit_content?(content)
      content.access_strategy.permits_write_access_for(self)
    end 

  end

end # module
end # module
