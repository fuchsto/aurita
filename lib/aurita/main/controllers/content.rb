
require('aurita/controller')


class Aurita::Main::Content_Controller < App_Controller

  # Disallow direct operations on abstract Content entities
  guard(:CRUD) { false } 

  def add_tag
    content = Content.get(param(:content_id))
    content.add_tags!(param(:tag))
    render_view(:editable_tag_list, :content => content)
  end

  def show
    content = load_instance()
    if !content then
      return render_controller(Error_Controller, :error_404)
    end

    content = content.concrete_instance()
    render_controller(content.controller, :show, :id => content.pkey)
  end

  def by_tag
    
    key = param(:key)
    entities = Content.find(:all).with(Content.has_tag(key) & Content.is_accessible?).to_a
    
    
    
  end

end # class
