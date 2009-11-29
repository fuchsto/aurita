
require('aurita/model')
Aurita::Main.import_model :content

module Aurita
module Main

  class Content < Aurita::Model
    table :content, :public
  end

  class Tag_Index < Aurita::Model

    table :tag_index, :public
    primary_key :tag
    primary_key :content_id
    
    has_a Content, :content_id

    validates :type, :mandatory => true, :maxlength => 50

    def self.update_index_for(content)
      
      resource_type = 'CONTENT'

      old_tags = Tag_Index.select { |ti|
        ti.where(Tag_Index.content_id == content.content_id)
      }.to_a.map { |t| t.tag }
      
      new_tags = content.tags.to_s.gsub('{','').gsub('}','').gsub(',',' ').split(' ')
      new_tags.each { |tag|
        begin
          if !old_tags.include?(tag) then
            Tag_Index.create( :content_id => content.content_id, 
                              :tag => tag, 
                              :user_group_id => Aurita.user.user_group_id, 
                              :tag_type => type, 
                              :res_type => resource_type)
          end
        rescue ::Exception => excep
        end
      }
    end

    def self.create_index_for(content)
      
      resource_type = content.class.to_s.split('::')[-1].upcase

      new_tags = content.tags.split(' ')
      new_tags.each { |tag|
        tag_parts = tag.split(':')
        if tag_parts.length == 1 then
          type = 'IMMEDIATE'
        else
          case tag_parts[0]
            when 'usr' then type = 'CREATOR' 
            when 'con' then type = 'CONTENT' 
            when 'cat' then type = 'CATEGORY'
            when 'inh' then type = 'INHERITED'
            when 'med' then type = 'MEDIA'
          end
        end

        begin
        Tag_Index.create( :content_id => content.content_id, 
                          :tag => tag, 
                          :tag_type => type, 
                          :res_type => resource_type)
        rescue ::Exception => excep
        end
      }
    end
    
    def self.resolve_tags_from_string(string)
      words = string.to_s.split(' ')
      # Don't index lowercase words: 
      words.delete_if { |word|
        !(/A-Z/.match(word[0].to_s))
      }
      log('WORDS: ' << words.inspect)
      # Add words to tag list if they are a tag already: 
      tag_string = ''
      words.each { |word|
        word.downcase!
        tag_for_word = Tag_Index.find(1).with(Tag_Index.tag == word).entity
        if tag_for_word then
          tag_string << 'con:' << word
          tag_string << ' '
        end
      }
      return tag_string
    end

  end 

end # module
end # module
