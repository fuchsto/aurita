
module Aurita

  module Context_Menu_Helpers

    def icon_for(label)
      icon = '/aurita/images/icons/blank.gif?' << label.to_s
      icon_path = 'context_' << label.to_s + '.gif'
      if File.exists? Aurita.base_path + 'main/public/shared/icons/' << icon_path then
        icon = '/aurita/images/icons/' << icon_path
      end
      icon
    end

    def entry(label, interface, targets={})
      onload = ''
      onload = ', onload: ' << targets[:onload] if targets[:onload]
      targets.delete(:onload)
      target_string = '{'
      targets.each_pair { |target_id, target_interface|
        target_string << target_id.to_s << ': \'' << target_interface << '\'; '
      }
      target_string << '}'
      target_string.gsub!('; }','}')

      icon = icon_for(label)

      entry_id = 'context_menu_entry_' + rand(1000).to_s; 

      result = '<div id="' << entry_id + '" class="context_menu_entry" onMouseOut="unhover_element(\'' << entry_id + '\');" onMouseOver="hover_element(\'' << entry_id + '\'); " '
      if interface.include?('http://') then
        result << 'onClick="window.open(\'' << interface + '\');" '
      else
        result << 'onClick="context_menu_click({url: \''
        result << interface << '\', targets: ' << target_string << ', autoclose: false ' << onload + '  }); " '
      end
      result << 'class="context_menu"><nobr>&nbsp; '
      result << '<img src="' << icon + '" alt="" /> '
      result << '<font class="context_menu_entry_label">' + tl(label) << '&nbsp;</font></nobr></div>'
      puts result
    end

    def switch_to_entry(label, interface, js_init_fun=nil)
      icon = icon_for(label)
      entry_id = 'context_menu_entry_' + rand(1000).to_s; 
      result = '<div id="' << entry_id + '" class="context_menu_entry" onMouseOut="unhover_element(\'' << entry_id + '\');" onMouseOver="hover_element(\'' << entry_id + '\'); " '
      result << "onClick=\"Cuba.load({ element: 'app_main_content', action: '#{interface}'"
      result << ", onload: '#{js_init_fun.to_s}'" if js_init_fun
      result << '} ); context_menu_close(); " class="context_menu"><nobr>&nbsp; '
      result << '<img src="' << icon + '" border="0" /> '
      result << '<font class="context_menu_entry_label">' + tl(label) << '&nbsp;</font></nobr></div>'
      puts result
    end

    def load_entry(label, targets, js_init_fun=nil)
      icon = icon_for(label)
      onload = ', onload: ' << js_init_fun.to_s if js_init_fun
      result = ''
      targets.each_pair { |target, interface|
        interface.gsub!('/aurita/','')
        entry_id = 'context_menu_entry_' + rand(1000).to_s; 
        result << '<div id="' << entry_id + '" class="context_menu_entry" onMouseOut="unhover_element(\'' << entry_id + '\');" onMouseOver="hover_element(\'' << entry_id + '\'); " ' 
        result << 'onClick="Cuba.load({ element: \'' << target + '\', action: \'' << interface << '\'' << onload.to_s << ' }); context_menu_close(); " class="context_menu"><nobr>&nbsp; '
        result << '<img src="' << icon + '" border="0" /> '
        result << '<font class="context_menu_entry_label">' + tl(label) << '&nbsp;</font></nobr></div>'
      }
      puts result
    end

    def icon(icon_name, interface, targets={})
      target_string = '{'
      targets.each_pair { |target_id, target_interface|
        target_string << target_id.to_s << ': \'' << target_interface << '\'; '
      }
      target_string << '}'
      target_string.gsub!('; }','}')

      result = '<img src="/aurita/images/icons/' << icon_name.to_s + '.gif" onClick="context_menu_click({url: \''
      result << interface << '\', targets: ' << target_string << ', autoclose: false}); " />'
      puts result
    end

    def header(label)
      puts '<div class="context_menu_header"><nobr>&nbsp;' << label + '&nbsp;</nobr></div>'
    end

  end

end
