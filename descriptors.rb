# -*- coding: iso-8859-2 -*-

require 'polish'
require 'array'
require 'observations'
require 'utils'
require 'hmm'
require 'clp'
require 'string'
require 'array'

class EmotionalClassifier
  def self.classify(heroes, text, radius = 50)
    names = heroes.map{|x| x.name}
    relations = names.map{|x| [0]*names.size}
    word_nos = names.map{|x| [0]*names.size}
    personal = Hash.new{|hsh, key| hsh[key] = Hash.new(0)}
    text = text.strip.split.map{|x| x.gsub(/[.?!,()]/, "")}

    name_locs = []
    0.upto(names.size - 1) do |index|
      name_locs[index] = []
      text.each_with_index {|x,i| name_locs[index] << i if x =~ /#{names[index]}/}
    end

    time = Time.now
    name_idxs = [0]*name_locs.size    
    text.each_with_index do |word, index|
      0.upto(name_idxs.size - 1) {|i| name_idxs[i] += 1 while name_idxs[i] < name_locs[i].size && name_locs[i][name_idxs[i]] < index}
      if index % 1000 == 0
        puts Time.now - time
        time = Time.now
        puts index
      end
      dists = []
      for i in 0..(name_locs.size - 1)
        j = name_idxs[i]
        dists[i] = [name_locs[i][j], name_locs[i][j-1]].select{|x| x}.map{|x| (x - index).abs}.min
      end

      value = word.emotional_value
      indices = dists.min2indices

      for i in indices
        dist1 = dists[i]
        next if dist1 > radius
        for j in indices
          dist2 = dists[j]
          next if dist2 > radius
          if dist1 && dist2 && (dist1 + dist2) != 0
            relations[i][j] += value*1.0/(dist1+dist2)
            word_nos[i][j] += 1
            personal[names[i]][word.base_form] += 1.0/dist1 if i == j
          end
        end
      end
    end

    heroes.each_with_index do |hero, i| 
      hero.goodness = relations[i][i]/word_nos[i][i]
      hero.relations = relations[i].zip(word_nos[i]).map{|x| x[0]*x[1] != 0 ? x[0]/x[1] : 0}
      hero.relations[i] = 0
      max = hero.relations.max
      min = hero.relations.min
      hero.relations.map! do |x|
        if x > 0
          x/max
        elsif x < 0
          -x/min
        else
          0
        end
      end
    end

    max = heroes.map{|x| x.goodness}.max
    min = heroes.map{|x| x.goodness}.min
    heroes.each do |x| 
      x.goodness = 
        if x.goodness > 0
          x.goodness/max
        elsif x.goodness < 0
          -x.goodness/min
        else 
          0
        end
    end
    
    heroes.each do |hero|
      old = hero.relations
      hero.relations = {}
      heroes.each_with_index {|other, i| hero.relations[other] = old[i] if other != hero && old[i] != 0}
      hero.keywords = personal[hero.name].sort{|x, y| y[1] - x[1]}.map{|x| x[0]}.select{|x| x.emotional_value != 0 && x.part_of_speech != :verb}[0..9]
    end
  end
end
