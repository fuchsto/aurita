
require('aurita/model')
Aurita::Main.import_model :content

module Aurita
module Main

  class Content_Hierarchy < Aurita::Model
    table :content_hierarchy, :public
    primary_key :content_id_parent
    primary_key :content_id_child
  end

  class Content < Aurita::Model
    
    def add_child(content)
      Content_Hierarchy.create(:content_id_parent => content_id, 
                               :content_id_child  => content.content_id)
      @content_id_stack = false # invalidate
    end

    def add_parent(content)
      Content_Hierarchy.create(:content_id_parent => content.content_id, 
                               :content_id_child  => content_id)
      @content_id_stack = false # invalidate
    end

    def remove_child(content)
      @content_id_stack = false # invalidate
    end

    def remove_parent(content)
      @content_id_stack = false # invalidate
    end

    def content_id_stack
      @content_id_stack ||= [ content_id ] + content_id_stack_rec(content_id)
      @content_id_stack
    end

  private

    def content_id_stack_rec(content_id_child)
      parent_cids = Content_Hierarchy.select_values(:content_id_parent) { |puid|
        puid.where(:content_id_child => content_id_child)
      }.to_a.flatten.map { |pcid| pcid.to_i }
      next_parent_cids = []
      parent_cids.each { |pcid|
        next_parent_cids += content_id_stack_rec(pcid)
      }

      return (parent_cids + next_parent_cids).uniq
    end

  end
  
end
end

