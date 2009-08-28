
class Integer

  def filesize
    size = self.to_f
    size_suffix = ' Byte'
    if (size > 1024) then 
      size = size / 1024.0
      size_suffix = ' Kib'
    else
      return size.to_s << size_suffix
    end
    if (size > 1024) then
      size = size / 1024.0
      size_suffix = ' Mib'
    end
    if (size > 1024) then
      size = size / 1024.0
      size_suffix = ' Gib'
    end
    size = (size.round(2)).to_s << size_suffix
    size
  end

  def hours
    self * 60 * 60 * 60
  end

  def minutes
    self * 60 * 60
  end

  def seconds
    self * 60 
  end

end

