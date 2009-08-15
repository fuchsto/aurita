
require('aurita')
require('aurita/model')
Aurita.import_module :gui, :helpers
Aurita.import_module :gui, :datetime_helpers
Aurita.import_module :gui, :context_menu_helpers
Aurita.import_module :gui, :link_helpers

module Aurita
module GUI

  class ERB_Helpers
  include Aurita::GUI
  extend Aurita::GUI::Datetime_Helpers
  extend Aurita::GUI::Context_Menu_Helpers
  extend Aurita::GUI::Link_Helpers
  extend Aurita::GUI::Helpers


    @sizes = {
      :tiny   => '70', 
      :small  => '95',
      :thumb  => '120',
      :medium => '320',
      :large  => '800', 
    }

    def self.tl_main(symbol)
      Lang[:main][symbol.to_s]
    end

    def self.button(args, &block)
      icon = ''
      icon = '<img src="/aurita/images/icons/button_' << args[:icon].to_s + '.gif" alt="" />' if args[:icon]
      if args[:action] then
        onclick = "Cuba.load({ element: 'app_main_content', action: '#{args[:action]}' }); "
      elsif args[:onclick] then
        onclick = args[:onclick]
      elsif args[:hashcode] then
        onclick = "Cuba.set_hashcode('#{args[:hashcode]}'); "
      else 
        onclick = ''
        args.each_pair { |k,v|
          onclick <<  "Cuba.load({ element: '#{k}', action: '#{v}' }); " unless [:icon, :class, :type].include?(k)
        }
      end
      label = yield()
      label = tl_main(label) if label.kind_of?(Symbol)
      args[:type] = 'button' unless args[:type]
      args[:onclick] = onclick unless onclick == '' 
      args[:class] = 'lore_button_varwidth' unless args[:class]
      args.delete(:action)
      args.delete(:icon)
      HTML.button(args) { icon + label }
    end


    def self.media_asset_thumb(params)
      media_asset_id = params[:id].to_s
      media_asset_id = params[:asset].media_asset_id if params[:asset]
      if params[:asset] and !params[:asset].has_preview? then
        params[:size] = :small unless params[:size]
      end
      params[:class] = 'thumbnail' unless params[:class]
      extension = media_asset_id
      if params[:asset] and !params[:asset].has_preview? then
        extension = params[:asset].mime_extension
      end
      extension = extension.to_s
      
      no_cache = ''
      no_cache = '?no_cache=' << (rand()*10000).to_i.to_s if params[:nocache]

      if(params[:x] or params[:y]) then
        x = params[:x].to_s
        y = params[:y].to_s
        
        HTML.img(:src => '/aurita/Wiki::Media_Asset/image/id=' << extension << '&version=' << params[:version].to_s + '&x=' << x << '&y=' << y << '&mode=none', 
                 :alt => extension.upcase, 
                 :style => params[:style].to_s)

      elsif(params[:size]) then
        size = @sizes[params[:size]]
        params[:width] = size unless params[:width]
        params[:height] = size unless params[:height]
        version_extension = '.' << params[:version].to_s if params[:version] && (!params[:asset] || params[:asset].has_preview?)
        style = params[:style].to_s + 'width: ' << params[:width].to_s + 'px; height=' << params[:height].to_s + 'px; '
        HTML.div(:style => style, :class => params[:class] ) { 
          HTML.img(:alt => extension.upcase, :src => '/aurita/assets/' << params[:size].to_s << '/asset_' << extension + version_extension.to_s + '.jpg' << no_cache)
        }
      else
        version_extension = '.' << params[:version].to_s if params[:version]
        HTML.img(:src => '/aurita/assets/asset_' << extension << '.jpg' << no_cache, 
                 :alt => extension.upcase, 
                 :style => params[:style].to_s)
      end

    end
    def self.media_asset_url(params)
      media_asset_id = params[:id].to_s
      media_asset_id = params[:asset].media_asset_id if params[:asset]
      
      if params[:asset] and params[:asset].mime_extension != 'jpg' then
        extension = params[:asset].mime_extension
      else 
        extension = media_asset_id
      end

      no_cache = ''
      no_cache = '?no_cache=' << (rand()*10000).to_i.to_s if params[:nocache]

      if(params[:x] or params[:y]) then
         x = params[:x].to_s
         y = params[:y].to_s
        
        '/aurita/Wiki::Media_Asset/image/id=' << media_asset_id << '&x=' << x << '&y=' << y << '&mode=none'

      elsif(params[:size]) then
        size = @sizes[params[:size]].to_s
        style = params[:style].to_s + 'width: ' << size + 'px; height=' << size + 'px; '
        
        return '/aurita/assets/' << params[:size].to_s << '/asset_' << extension.to_s << '.jpg' << no_cache
      else
        no_cache = '?no_cache=' << (rand()*10000).to_i.to_s
        return '/aurita/assets/asset_' << extension << '.jpg' << no_cache
      end

    end

    def self.link_to_media_asset(params)
      if params[:asset] then
        id = params[:asset].media_asset_id
      else
        id = params[:id]
      end
      return '' unless id
      hashcode = 'media--' + id.to_s 
      HTML.a(:onclick => "Cuba.set_hashcode('#{hashcode}');", :class => 'link', :href => "##{hashcode}") { media_asset_thumb(params) }
    end

    def self.hidden_field(params)
      fields = ''
      params.each_pair { |name, value|
        fields << '<input type="hidden" name="' << name.to_s + '" value="' << value.to_s + '" />'
      }
      fields
    end
    def self.hidden_fields(params)
      hidden_field(params)
    end 

    def self.begin_form_for(interface, args={})
      interface = interface.split('.')
      model  = interface.at(0)
      action = interface.at(1)
      args[:name] = interface.at(1) + '_form' if args[:name].nil?

      args[:id] = args[:name] unless args[:id]
      form_params = '' 
      args.each_pair { |param,value| 
        form_params << param.to_s + '="' << value.to_s + '" '
      }

      '<form method="POST" action="/aurita/dispatch" enctype="multipart/form-data" ' << form_params << ' />
       <input type="hidden" name="controller" value="' << model << '" />
       <input type="hidden" name="action" value="' << action << '" />
       <input type="hidden" name="mode" value="none" />'
    end

    def self.end_form
      '</form>'
    end

  end

end
end
