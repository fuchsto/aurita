
class Nil

  # To prevent
  #  
  #   param(:set_of_values).each { ... } 
  #
  # from bailing out. 
  # This can also be prevented by setting an empty 
  # Array instance as default value: 
  #
  #   param(:set_of_values, []).each { ... }
  #
  def each(&block)
  end

end
