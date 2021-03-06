# -*- coding: iso-8859-2 -*-

require 'polish'
require 'array'
require 'observations'
require 'utils'
require 'hmm'
require 'clp'
require 'descriptors'
require 'hero'

def prepare_examples(text, initial, initial_negative)
  fragments = text.split(/(\n[^\n]+(?=\n))/)
  examples = {}

  for fragment in fragments.select{|x| x.include?(initial) || x.include?(initial_negative)}
    temp = fragment.strip.split
    occurences = []
    temp.each_with_index{|x,i| occurences << i if x =~ /#{initial}/}
    examples[fragment] = {:hero => occurences}
  end
  examples
end

def analyze(text, examples)
  fragments = text.split(/(\n[^\n]+(?=\n))/)
  states = [:hero]
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
  heroes
end
