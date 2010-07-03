# -*- coding: iso-8859-2 -*-

require 'polish'
require 'array'
require 'observations'
require 'utils'
require 'hmm'
require 'clp'
require 'descriptors'
require 'hero'

text = ""

for file in Dir.glob("teksty/*.iso")
  File.open(file) { |f| text += f.read }
end

initial = "Geralt"
initial_negative = "Brokilon"
states = [:hero]
fragments = text.split(/(\n[^\n]+(?=\n))/)
examples = {}

for fragment in fragments.select{|x| x.include?(initial) || x.include?(initial_negative)}
  temp = fragment.strip.split
  occurences = []
  temp.each_with_index{|x,i| occurences << i if x =~ /#{initial}/}
  examples[fragment] = {:hero => occurences}
end

model = Model.make_hmm(states, examples)
names = Hash.new(0)
for fragment in fragments
  extracted, prob = model.extract(:hero, fragment)
  for name in extracted
    names[name.gsub(/\.|,|!|\?/, "")] += prob
  end
end

keys = names.keys.select{|x| names[x] > 1}
importance = keys.map{|x| names[x]}
importance.normalize!
heroes = keys.zip(importance).map{|x| Hero.new(x[0], x[1])}

EmotionalClassifier.classify(heroes, text)

puts heroes.sort{|x,y| y.importance - x.importance}
