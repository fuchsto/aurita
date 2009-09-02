
require('lore/clause')

module Aurita
module Main

  class Tagging

    # Scans text for words known as tags and decorates them with a link 
    # that launches a search for this tag. 
    # Example ('documentation' being a known tag): 
    #
    #   text = 'This is a documentation example'
    #   text = Tagging.link_text_tags(text)
    #   p text
    #
    # --> 
    #
    #   'This is a <a href="#find--documentation" .. >documentation</a> example'
    #
    def self.link_text_tags(text)
      tags = Tag_Index.select_values('distinct(tag)') { |t|
        t.where(true) 
      }.collect { |tag| tag.to_s }
      marked_tags = Tag_Blacklist.all.entities.collect { |e| e.tag }
      text = ' ' << text.to_s.gsub("\n",' ') + ' '
      text.gsub('-', ' ').gsub(/<[^a][^>]+>/,' ').split(' ').each { |word|
        if word.length > 2 && !marked_tags.include?(word.downcase) && tags.include?(word.downcase) then
          dword = word.downcase
          marked_tags << dword
          begin
            text.gsub!(/([>|\s]+)(#{word})([<|\s]+)/i, '\1<a class="tag_link" href="#find--' << dword + '" onclick="Cuba.set_hashcode(\'find--' << dword + '\'); ">\2</a>\3')
          rescue ::Exception => ignore
          end
        end
      }
      text.gsub!("'","&apos;")
      text
    end

  end

end
end

module Lore
	class Refined_Select < Lore::Refined_Query
    # Helper method for taggable models. 
    # Extends Lore::Clause by select helper #by_tag. 
    # Usage: 
    #
    #    Article.find(10).by_tag('foo', 'bar').with(your_constraints).entities
    #
		def by_tag(*tags)
      tags = tags.first if tags.first.is_a?(Array)
			constraints = Lore::Clause.new('')
			tags.each { |k|
				constraints = constraints & (@accessor.tags.has_element_ilike("#{k}%"))
			}
			key = tags.join(' ')
			if !Aurita.user.is_admin? then
				user_cat_ids = Aurita.user.category_ids
				permission_constraints = (Content.content_id.in( 
					Content_Category.select(:content_id) { |cid| 
						cid.where(Content_Category.category_id.in(user_cat_ids) )
					}
				))
				constraints = (permission_constraints) & constraints
			end
			with(constraints)
		end
		alias with_tag by_tag

    def filter_perms
    end
	end
end

module Aurita

  # Usage: Extend Aurita::Model (esp. Aurita::Main::Content) with 
  # this helper module. 
  # Usage: 
  #
  #   Some_Content.find(10).with(Some_Content.has_tag('foo%')),entities
  # Or
  #   Some_Content.find(10).with(Some_Content.has_tags('foo%', '%bar', 'batz')),entities
  #
  # This helper also considers tag synonyms (see Tag_Synonym). 
  #
  module Taggable_Behaviour
    def has_tag(*tags)
      tags = tags.first if tags.first.is_a?(Array)
			constraints = Lore::Clause.new('')
      syn = Hash.new
      Tag_Synonym.all_with(Tag_Synonym.synonym.in(tags.map { |t| "'#{t}'" }.join(','))).entities.each { |s| 
        syn[s.tag]     = [] unless syn[s.tag]
        syn[s.tag]     << s.synonym
        syn[s.synonym] = [] unless syn[s.synonym]
        syn[s.synonym] << s.tag
      }
      syn_constraints = Lore::Clause.new('')
			tags.each { |k|
        constraints = constraints & (self.tags.has_element_ilike("%#{k}%"))
        if syn[k] then
          syn[k].each { |s|
            constraints = constraints |
                          (self.tags.has_element_ilike("%#{s}%"))
          }
        end
			}
      constraints
    end
    alias has_tags has_tag

    # Shortcut for
    #
    #   find(:all).by_tag(*tags)
    #
    # See Lore::Refined_Select.by_tag
    def all_by_tag(*tags)
      find(:all).by_tag(*tags)
    end

  end

end

