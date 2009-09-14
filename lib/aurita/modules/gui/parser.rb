

module Aurita
module GUI

  class Default_Post_Parser # :nodoc:

    def self.youtube_player(backref)
      url = 'http://www.youtube.com/v/' << backref
      '<object width="380" height="320"><param name="movie" value="' << url + '"></param><param wmode=""></param><embed src="' << url + '" type="application/x-shockwave-flash" wmode="" width="380" height="320"></embed></object>'
    end

    def self.parse(post_string)
      post_string = post_string.to_s
      post_string.gsub!('<br />',"\n")
      post_string.gsub!('<br>',"\n")
      post_string.gsub!('<','&lt;')
      post_string.gsub!('>','&gt;')
      post_string.gsub!(/\[img\]([^\]]+?)\[\/img\]/, '<div align="left"><img style="margin-top: 12px; margin-bottom: 12px;" src="\1" border="0" /></div>')
      post_string.gsub!(/\[img size=([^\]]+)\]([^\]]+?)\[\/img\]/, '<div align="left"><img style="margin-top: 12px; margin-bottom: 12px;" src="\2" border="0" /></div>')
      post_string.gsub!(/([^="]+)http:\/\/www\.youtube\.com\/watch\?v=([^\s]+)/, '\1' << youtube_player('\2'))
      post_string.gsub!(/([^="]+)http:\/\/([^\s]+)/, '\1<a href="http://\2" target="blank"> -link- </a> ')
      post_string.gsub!(/^http:\/\/www\.youtube\.com\/watch\?v=([^\s]+)/, youtube_player('\1'))
      post_string.gsub!(/^http:\/\/([^\s]+)/, '<a href="http://\1" target="blank"> -link- </a> ')
      post_string.gsub!('[quote]', '<p class="forum_post_quote">')
      post_string.gsub!('[/quote]','</p>')
      post_string.gsub!(/\[color=([^\]]+)\]/, '<font style="color: \1">')
      post_string.gsub!('[/color]', '</font>')
      post_string.gsub!(/\[size=([^\]]+)\]/, '<font size="\1">')
      post_string.gsub!('[/size]', '</font>')
      post_string.gsub!(/\[url=([^\]]+)\]/, ' <a href="\1" target="_blank" >- ')
      post_string.gsub!(/\[appurl=([^\]]+)\]/, ' <a href="#\1" onclick="Aurita.set_hashcode(\'\1\'); " >')
      post_string.gsub!('[/appurl]', ' </a>')
      post_string.gsub!('[/url]', ' -&gt;</a>')
      post_string.gsub!('[/url]', ' -&gt;</a>')
      post_string.gsub!("\n",'<br />')
      post_string.gsub!('[i]','<i>')
      post_string.gsub!('[/i]','</i>')
      post_string.gsub!('[b]','<b>')
      post_string.gsub!('[/b]','</b>')
      post_string
    end

    def self.parse_urls(string)
      string.gsub!(/\[url=\/([^\]]+)\]/, ' <a href="\1" target="_self" >- ')
      string.gsub!(/\[url=([^\]]+)\]/, ' <a href="\1" target="_blank" >- ')
      string.gsub!('[/url]', ' -&gt;</a>')
      string.gsub!('[/url]', ' -&gt;</a>')
      string.gsub!(/([^="]+)http:\/\/([^\s]+)/, '\1<a href="http://\2" target="blank"> -link- </a> ')
      string.gsub!(/^http:\/\/([^\s]+)/, '<a href="http://\1" target="blank"> -link- </a> ')
      string
    end
  end

  class Flatstring_Post_Parser # :nodoc:
    def self.parse(post_string)
      post_string = post_string.to_s
      post_string.gsub!(/\[color=([^\]]+)\]/, '')
      post_string.gsub!('[/color]', '')
      post_string.gsub!('[quote]', '[')
      post_string.gsub!('[/quote]',']')
      post_string.gsub!('<br>',' ')
      post_string.gsub!('<br />',' ')
      post_string.gsub!("'\n",' ')
      post_string.gsub!('[i]','')
      post_string.gsub!('[/i]','')
      post_string.gsub!('[b]','')
      post_string.gsub!('[/b]','')
      post_string
    end
  end

  class Smiley_Parser # :nodoc:
    @@smileys = { 
      'B)' => :cool, 
      ':)' => :smile, 
      ';)' => :wink, 
      ':wink:' => :wink, 
      ':P' => :tounge, 
      ':laugh:' => :laughing, 
      ':ohmy:' => :shocked, 
      ':sick:' => :sick, 
      ':angry:' => :angry, 
      ':blink:' => :blink, 
      'O_o' => :blink, 
      'o_O' => :blink, 
      ':(' => :sad, 
      ':unsure:' => :unsure, 
      ':kiss:' => :kissing, 
      ':-*' => :kissing, 
      ':woohoo:' => :w00t, 
      ':lol:' => :grin, 
      ':silly:' => :silly, 
      ':pinch:' => :pinch, 
      '>_<' => :pinch, 
      ':side:' => :sideways, 
      ':whistle:' => :whistling, 
      ':evil:' => :devil, 
      ':S' => :dizzy, 
      ':blush:' => :blush, 
      ':cheer:' => :cheerful, 
      ':huh:' => :wassat, 
      ':dry:' => :ermm, 
      ':D' => :laughing, 
    }
    def self.parse(post_string)
      @@smileys.each_pair { |smiley, image|
        post_string.gsub!(smiley, '<img src="/aurita/images/emoticons/' << image.to_s + '.png" border="0" />')
      }
      post_string
    end
  end

end # module
end # module

