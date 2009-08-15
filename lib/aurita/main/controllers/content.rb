
require('aurita/controller')


class Aurita::Main::Content_Controller < App_Controller

  def list
  end

  def add_tag
    content = Content.load(:content_id => param(:content_id))
    content['tags'] = content.tags + ' ' << param(:tag).to_s.downcase
    content.commit
    plugin_call(Hook.main.content.touched, :content => content)
    render_view(:editable_tag_list, :content => content)
  end

end # class
