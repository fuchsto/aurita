
require('aurita/model')
Aurita::Main.import_model :content

module Aurita
module Main

  class Content_Comment < Aurita::Model
    include Aurita::Access_Strategy

    table :content_comment, :public
    primary_key :content_comment_id, :content_comment_id_seq

    use_access_strategy(Category_Based_Access, 
                        :managed_by => Content_Category, 
                        :mapping    => { :content_id => :category_id } )
    
    add_input_filter(:message) { |m|
      m.gsub("'",'&apos;')
    }

    def self.after_create(instance)
      Content.load(:content_id => instance.content_id).touch()
    end
    def self.after_update(instance)
      Content.load(:content_id => instance.content_id).touch()
    end
    def self.before_instance_delete(instance)
      Content.load(:content_id => instance.content_id).touch()
    end

  end

end
end

