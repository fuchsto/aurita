
class Array

  def randomize
    arr=self.dup
    return [] unless arr.length > 0
    arr.collect { arr.slice!(rand(arr.length)) }
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

end
