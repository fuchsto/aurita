
class Hash

  def to_get_params
    string = ''
    self.each_pair { |k,v|
      string << k.to_s << '=' << v.to_s << '&'
    }
    string[0..-2]
  end

  def dup
    d = {}
    each_pair { |k,e| d[k] = e }
    d
  end

end
