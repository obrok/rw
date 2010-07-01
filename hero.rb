# -*- coding: utf-8 -*-
class Hero
  attr_accessor :name, :importance, :goodness, :keywords

  def initialize(name, importance = 0, goodness = 0, keywords = [])
    self.name = name
    self.importance = importance
    self.goodness = goodness
    self.keywords = keywords
  end

  def to_s
    result = name + "\n"
    result += "\tWażność: #{importance}\n"
    result += "\tPozytywność: #{goodness}\n"
    result += "\tSłowa kluczowe: #{keywords.join(", ")}\n"
  end
end
