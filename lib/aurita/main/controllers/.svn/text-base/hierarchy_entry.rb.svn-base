
require('aurita/controller')
Aurita::Main.import_controller :context_menu
Aurita.import_plugin_model :wiki, :article

module Aurita
module Main

  class Hierarchy_Entry_Controller < App_Controller

    def add
      form = model_form(:model => Hierarchy_Entry, :action => :perform_add)
      form.fields = [
         Hierarchy_Entry.entry_type, 
         Hierarchy_Entry.label, 
         Content.tags, 
         Hierarchy_Entry.hierarchy_id, 
         Hierarchy_Entry.hierarchy_entry_id_parent 
      ]
      form.add(Hidden_Field.new(:name => Hierarchy_Entry.hierarchy_id, 
                                :value => param(:hierarchy_id)))
      form.add(Hidden_Field.new(:name => Hierarchy_Entry.hierarchy_entry_id_parent, 
                                :value => param(:hierarchy_entry_id_parent)))
      form[Hierarchy_Entry.hierarchy_entry_id_parent].hide! 

      options = { 'ARTICLE'    => tl(:article_entry), 
                  'FILTER'     => tl(:filter_entry), 
                  'BLANK_NODE' => tl(:blank_node_entry) }
      type_select = Select_Field.new(:name => Hierarchy_Entry.entry_type, 
                                     :label => tl(:context_entry_type), 
                                     :options => options, 
                                     :value => 'ARTICLE')
      form.add(type_select)

      tags = Input_Field.new(:type => :text, :label => tl(:tags), :name => Content.tags, :required => true)
      form.add(tags)

      render_form(form)
    end

    def update
      entry = load_instance()
      form = update_form()
      form.fields = [
        :controller, 
        :action, 
        Hierarchy_Entry.hierarchy_entry_id, 
        Hierarchy_Entry.label
      ]
      if entry.entry_type == 'FILTER'
        form.fields << Hierarchy_Entry.interface 
        form[Hierarchy_Entry.interface].value = entry.interface.sub('App_Main/find/key=', '')
        form.fields << Hierarchy_Entry.entry_type
        form[Hierarchy_Entry.entry_type].value = 'FILTER'
      end

      render_form(form)
    end

    def delete
      form = model_form(:model => Hierarchy_Entry, :action => :perform_delete, :instance => load_instance())
      form.readonly! 
      form.fields = [
         Hierarchy_Entry.label
      ]
      render_form(form)
    end

    def perform_add
      hierarchy = Hierarchy.load(:hierarchy_id => param(:hierarchy_id))
      if(param(:entry_type) == 'ARTICLE') then
        tags = param(:tags).to_s + ' ' + hierarchy.header
        article = Wiki::Article.create(:title => param(:label), 
                                       :tags => tags)
        content_category = Content_Category.create(:content_id => article.content_id, 
                                                   :category_id => Aurita.user.own_category.category_id)
        @params[:interface] = 'Wiki::Article/show/article_id=' << article.article_id
        @params[:content_id] = article.content_id
      else 
        @params[:interface] = ('App_Main/find/key=' << param(:tags).to_s)
      end
      instance = super()
      hid = instance.hierarchy_id
      exec_js("Cuba.load({ element: 'hierarchy_#{hid}_body', action: 'Hierarchy/body/hierarchy_id=#{hid}' });")
    end

    def perform_update
      hid = load_instance().hierarchy_id
      exec_js("Cuba.load({ element: 'hierarchy_#{hid}_body', action: 'Hierarchy/body/hierarchy_id=#{hid}' });")
      if param(:entry_type) == :filter then 
        @params[:interface] = 'App_Main/find/key=' << param(:interface).to_s
      end
      super()
    end

    def perform_delete
      entry = Hierarchy_Entry.load(:hierarchy_entry_id => param(:hierarchy_entry_id))
      # Re-hook children of this entry: 
      Hierarchy_Entry.update { |e|
        e.where(Hierarchy_Entry.hierarchy_entry_id_parent == entry.hierarchy_entry_id) 
        e.set(:hierarchy_entry_id_parent => entry.hierarchy_entry_id_parent)
      }
      hid = entry.hierarchy_id
      super()
      exec_js("Cuba.load({ element: 'hierarchy_#{hid}_body', action: 'Hierarchy/body/hierarchy_id=#{hid}' });")
    end

  end # class
  
end # module
end # module

