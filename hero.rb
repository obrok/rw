# -*- coding: utf-8 -*-
class Hero
  attr_accessor :name, :importance, :goodness, :keywords, :relations

  def initialize(name, importance = 0, goodness = 0, keywords = [])
    self.name = name
    self.importance = importance
    self.goodness = goodness
    self.keywords = keywords
  end

  def goodness_with_relations
    [relations.keys.map{|hero| hero.goodness * relations[hero]}.avg, goodness].avg
  end

  def to_s
    result = name + "\n"
    result += "\tWażność: #{importance}\n"
    result += "\tPozytywność: #{goodness_with_relations} (#{goodness})\n"
    result += "\tSłowa kluczowe: #{keywords.join(", ")}\n"
    result += "\tRelacje:\n"
    for hero in relations.keys
      result += "\t\t#{hero.name}: #{relations[hero]}\n" if (relations[hero]*hero.goodness - goodness).abs > 0.01
    end
    result
  end
end
