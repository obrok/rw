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
  def self.classify(name, text)
    fragments = text.split(/(\n[^\n]+(?=\n))/)
    rankings = Hash.new{|hsh, key| hsh[key] = Hash.new(0)}
    
    for fragment in fragments.select{|x| x.include?(name)}
      text = fragment.strip.split.map{|x| x.gsub(/[.?!,]/, "")}
      name_locs = []
      text.each_with_index{|x,i| name_locs << i if x =~ /#{name}/}
      text.each_with_index do |word, index|
        dist = name_locs.map{|x| (x - index).abs}.min
        if dist != 0
          rankings[word.part_of_speech][word.base_form] += 1.0/dist**2
        end
      end
    end

    result = 0.0
    words = {}
    for part_of_speech in [:adjective, :noun]
      temp = rankings[part_of_speech]
      keys = temp.keys
      emotional_values = keys.map{|x| x.emotional_value}
      values = keys.map{|x| temp[x]}
      values.normalize!
      result = values.zip(emotional_values).map{|x| x[0]*x[1]}.sum
      words[part_of_speech] = keys.select{|x| x.emotional_value != 0}.sort{|x,y| temp[y] - temp[x]}[0..2]
    end
    return result, words
  end

  def self.classify_relation(name, other_name, text)
    fragments = text.split(/(\n[^\n]+(?=\n))/)
    rankings = Hash.new{|hsh, key| hsh[key] = Hash.new(0)}
    
    for fragment in fragments.select{|x| x.include?(name) && x.include?(other_name)}
      text = fragment.strip.split.map{|x| x.gsub(/[.?!,]/, "")}
      name_locs = []
      other_name_locs = []
      text.each_with_index{|x,i| name_locs << i if x =~ /#{name}/}
      text.each_with_index{|x,i| other_name_locs << i if x =~ /#{other_name_locs}/}
      text.each_with_index do |word, index|
        dist = name_locs.map{|x| (x - index).abs}.min + other_name_locs.map{|x| (x - index).abs}.min
        if dist != 0
          rankings[word.part_of_speech][word.base_form] += 1.0/dist**2
        end
      end
    end

    result = 0.0
    words = {}
    for part_of_speech in [:verb, :adverb]
      temp = rankings[part_of_speech]
      keys = temp.keys
      emotional_values = keys.map{|x| x.emotional_value}
      values = keys.map{|x| temp[x]}
      values.normalize!
      result = values.zip(emotional_values).map{|x| x[0]*x[1]}.sum
      words[part_of_speech] = keys.select{|x| x.emotional_value != 0}.sort{|x,y| temp[y] - temp[x]}[0..2]
    end
    return result, words
  end
end
