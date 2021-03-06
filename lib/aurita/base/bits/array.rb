
class Array

  def randomize
    arr=self.dup
    return [] unless arr.length > 0
    arr.collect { arr.slice!(rand(arr.length)) }
  end

  def sum
    s = 0
    self.each { |x| s += x }
    s
  end

  def randomize!
   arr=self.dup
   result = []
   if arr.length > 0 then
     result = arr.collect { arr.slice!(rand(arr.length)) }
   end
   self.replace result
  end

  def pick_random
    self[rand(self.length)]
  end
  
  def to_ids
    flatten.map { |i| i.to_i }.uniq
  end

  def to_ids!
    flatten! 
    replace(map { |i| i.to_i }.uniq)
  end

end
