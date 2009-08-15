
require('aurita/model')
Aurita::Main.import_model :tag_blacklist

module Aurita
module Main

  # Records relevance of tags measured by hits. 
  # Assuming an article with tags 'foo' and 'bar' is viewed
  # in the application, both tags' hit count (and thus, relevance) 
  # would be incremented. 
  class Tag_Relevance < Aurita::Model
  
    table :tag_relevance, :public
    primary_key :tag
    
    def self.add_hits_for(content_inst)
      tags = content_inst.tags
      if(tags.include?('{')) then
        tags = tags[1..-2].gsub(',',' ').gsub('  ',' ')
      end
      tags.split(' ').each { |tag|
        entry = find(1).with(Tag_Relevance.tag == tag).entity
        if entry then 
          entry[:hits] = entry.hits.to_i + 1
          entry.commit
        else
          create( :tag => tag, :hits => 1)
        end
      }
    end

  end 

end # module
end # module
