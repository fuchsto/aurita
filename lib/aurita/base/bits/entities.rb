
require('htmlentities')

module Aurita

  def self.entities( str )
    converted = []
    str.to_s.split(//).collect { |c| converted << ( c[0] > 127 ? "&##{c[0]};" : c ) }
  # str.unpack("U*").collect {|s| (s > 127 ? "&##{s};" : s.chr) }.join("")
    converted.join('').gsub("'",'&apos;').gsub("\n","<br />\n")
  end

  def self.remove_entities(str)
    return str.gsub(/.$/u, '')

    str = entities(str)
    str.gsub(/&\#[^;]+;/,'')
  end


end
