require('aurita')
Aurita.import('base/bits/entities')

class String

  def to_utf8_s
    self.to_s.split(//u).join('')
  end

  def to_html_entities
    Aurita.entities(self)
  end
  alias to_html to_html_entities

  def to_html_entities!
    self.replace to_html_entities
  end
  alias to_html! to_html_entities!

  def strip_html_entities
    Aurita.remove_entities(self)
  end
  
  def strip_html_entities!
    self.replace strip_html_entities
  end

  def param_encode
    CGI.escape(self).gsub('%2F','/').gsub('%3D','=')
  end
    
  def camelize
    return self.capitalize unless (self.include?(' ') || self.include?('_'))
    self.gsub(' ','_').split('_').map { |w| w.capitalize }.join('_')
  end
  alias camelcase camelize

  def nonempty?
    self.to_s.gsub(/\s/,'') != ''
  end

  def html!
  #  converted = []
  #  self.split(//).collect { |c| converted << ( c[0] > 127 ? "&##{c[0]};" : c ) }
    replace self.unpack("U*").collect {|s| (s > 127 ? "&##{s};" : s.chr) }.join("")
    return self
  end
  def html
  #  converted = []
  #  self.split(//).collect { |c| converted << ( c[0] > 127 ? "&##{c[0]};" : c ) }
  #  return converted.join('')
    return self.unpack("U*").collect {|s| (s > 127 ? "&##{s};" : s.chr) }.join("")
  end

  def to_plaintext
    self.gsub(/<[^>]+>/,'')
  end

  def to_plaintext! 
    self.gsub!(/<[^>]+>/,'')
  end

  def pack!
    self.gsub!('"','\"')
    self.gsub!(/\s+/m,' ') 
  end
  def unpack!
    self.gsub!('\"','"')
  end

end # class

class NilClass
  def nonempty? 
    false
  end

  def empty?
    true
  end
end
