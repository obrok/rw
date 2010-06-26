# -*- coding: iso-8859-2 -*-

require 'polish'
require 'array'
require 'observations'
require 'utils'
require 'hmm'
require 'clp'

text = ""

for file in Dir.glob("teksty/*")
  File.open(file) { |f| text += f.read }
end

initial = "Geralt"
states = [:hero]
fragments = text.split(/(\n[^\n]+(?=\n))/)
examples = {}

for fragment in fragments.select{|x| x.include?(initial)}
  text = fragment.strip.split
  occurences = []
  text.each_with_index{|x,i| occurences << i if x =~ /#{initial}/}
  examples[fragment] = {:hero => occurences}
end

model = Model.make_hmm(states, examples)
for fragment in fragments
  names, prob = model.extract(:hero, fragment)
  p names, prob; readline if prob != 0 && names != []
end
