
class Integer

  def filesize
    size = self.to_i
    size_suffix = ' Byte'
    if (size > 1024) then 
      size = size / 1024
      size_suffix = ' Kb'
    else
      return size.to_s << size_suffix
    end
    if (size > 1024) then
      size = size / 1024
      size_suffix = ' Mb'
    end
    if (size > 1024) then
      size = size / 1024
      size_suffix = ' Gb'
    end
    size = ((size * 100).round.to_f / 100).to_s << size_suffix
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

