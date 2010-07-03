class Array
  def sum
    self.inject{|x,y| x+y}
  end

  def avg
    self.sum / self.size
  end

  def normalize!
    sum = self.sum
    if sum == 0
      self.map!{|x| 0.0}
    else
      self.map!{|x| x.to_f/sum}
    end
  end
end

