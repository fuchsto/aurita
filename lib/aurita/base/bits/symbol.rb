
class Symbol

  def intern
    self
  end
  def to_proc
    Proc.new { |*args| args.shift.__send__(self, *args) }
  end
end

