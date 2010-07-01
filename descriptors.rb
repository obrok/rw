# -*- coding: iso-8859-2 -*-

require 'polish'
require 'array'
require 'observations'
require 'utils'
require 'hmm'
require 'clp'
require 'string'
require 'array'

text = ""

for file in Dir.glob("teksty/*")
  File.open(file) { |f| text += f.read }
end

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
      dists.each_with_index do |dist1, i|
        next if dist1 > radius
        dists.each_with_index do |dist2, j|
          next if dist2 > radius
          if dist1 && dist2 && (dist1 + dist2) != 0
            relations[i][j] += value*1.0/(dist1+dist2)
            word_nos[i][j] += 1
          end
        end
      end
    end

    heroes.each_with_index do |hero, i| 
      hero.goodness = relations[i][i]/word_nos[i][i]
      #hero.relations = relations[i]
      #hero.relations[i] = 0
    end

    max = heroes.map{|x| x.goodness}.max
    min = heroes.map{|x| x.goodness}.min
    heroes.each {|x| x.goodness = 2*(x.goodness - min)/(max-min) - 1.0}
  end
end
