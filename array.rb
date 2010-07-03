class Array
  def sum
    self.inject{|x,y| x+y}
  end

  def avg
    self.sum / self.size
  end

  def min2indices
    min = min2 = nil
    for i in 0..(size - 1)
      if !min || self[i] < self[min]
        min2 = min
        min = i
      elsif !min2 || self[i] < self[min2]
        min2 = i
      end
    end
    [min, min2]
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

