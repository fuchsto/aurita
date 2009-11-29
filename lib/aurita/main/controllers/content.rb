
require('aurita/controller')


class Aurita::Main::Content_Controller < App_Controller

# guard(:add_tag) { 
#   Aurita.user.may_edit_content?(param(:content_id)) 
# }

  # Disallow direct operations on abstract Content entities
  guard(:CRUD) { false } 

  def add_tag
    content = Content.get(param(:content_id))
    content.add_tags!(param(:tag))
    render_view(:editable_tag_list, :content => content)
  end

end # class
