require('aurita')
Aurita.import('base/bits/entities')

class String

  def first
    '' << self[0]
  end
  def last
    '' << self[-1]
  end

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

  def to_named_html_entities
    HTMLEntities.new.encode(self, :named)
  end
  def to_named_html_entities!
    replace(HTMLEntities.new.encode(self, :named))
  end
    
  def camelize
    return self.capitalize unless (self.include?(' ') || self.include?('_'))
    self.gsub(' ','_').split('_').map { |w| w.capitalize }.join('_')
  end
  alias camelcase camelize

  def nonempty?
    self.to_s.gsub(/\s/,'') != ''
  end

  def to_date
    Date.parse(self)
  end
  def to_datetime
    Date.parse(self)
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

  def pg_encode
    rep = split(//).map { |char|
      case char[0]
      when (0..31),39,92,(127..255)
        "\\#{sprintf("%03o", char[0])}"
      else
        char
      end
    }.join
    self.replace(rep)
  end

  def begins_with(other)
    (self[0...(other.length)] == other)
  end

  def contexts_of(keys=[], params={}, &block)
    len   = params[:length] || 200
    contexts = []
    keys.each { |k|
      parts = partition(/#{k}/i) 
      parts[1] = yield parts[1]
      pre = 0
      pre = parts[0].length-len if parts[0].length > len
      parts[0] = parts[0][pre,len].to_s
      parts[2] = parts[2][0,len]
      contexts << parts.join('')
    }
    contexts
  end

end # class
