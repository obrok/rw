class Array
  def sum
    self.inject{|x,y| x+y}
  end

  def normalize!
    sum = self.sum
    self.map!{|x| x.to_f/sum}
  end
end

