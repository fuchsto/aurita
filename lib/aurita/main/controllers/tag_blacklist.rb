
require('aurita/controller')

module Aurita
module Main

  class Tag_Blacklist_Controller < App_Controller

    def edit
      Page.new(:header => tl(:ignored_tags)) { 
        view_string(:tag_blacklist, :tags => Tag_Blacklist.all.order_by(:tag, :asc).entities)
      }
    end

    def perform_add
      Tag_Relevance.delete { |t| t.where(Tag_Relevance.tag == param(:tag)) }
      Tag_Index.delete { |t| t.where(Tag_Index.tag == param(:tag)) }
      Tag_Blacklist.create(:tag => param(:tag))
      redirect_to(:controller => 'Tag_Blacklist', :action => :edit)
    end

    def add
      form = add_form(Tag_Blacklist)
      form.add(Input_Field.new(:name => :tag, :label => tl(:tag), :required => true))
      render_form(form)
    end

  end

end
end
