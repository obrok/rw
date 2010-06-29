# -*- coding: iso-8859-2 -*-

require 'polish'
require 'array'
require 'observations'
require 'utils'
require 'hmm'
require 'clp'
require 'descriptors'

text = ""

for file in Dir.glob("teksty/*")
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

for name in names.keys.select{|x| names[x] > 0}.sort{|x,y| names[y] - names[x]}
  for other_name in names.keys.select{|x| names[x] > 0}.sort{|x,y| names[y] - names[x]}
    puts name, other_name
    p EmotionalClassifier.classify_relation(name, other_name, text)
    readline
  end
end
