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

initial = ["Geralt"]

def learn(text, initial)
  observations = Observations.new(text)

  transitions = [[0,0],[0,0]] # Just two states, second signifies writing the hero name
  initial_probabilities = [0,0]
  emissions = [0] * observations.observables.size
  emissions = [emissions, emissions.dup]

  for name in initial
    for fragment in Utils.fragments_containing(text, name)
      fragment = observations.convert_to_observations(fragment)
      last = nil
      for element in fragment
        state = element[0] =~ /#{name}/ ? 1 : 0
        if not last
          initial_probabilities[state] += 1
        else
          transitions[state][last] += 1
        end
        emissions[state][element[1]] += 1
        last = state
      end
    end
  end

  transitions.each{|x| x.normalize!}
  initial_probabilities.normalize!
  emissions.each{|x| x.normalize!}

  model = Model.new(initial_probabilities, transitions, emissions)
  names = Hash.new(0)

  for fragment in text.split(/(\n[^\n]+(?=\n))/).select{|x| x != ""}
    model.names(fragment, observations).each {|x| names[ClpWrapper.preprocess(x)] += 1}
  end
  names
end

def cleanup(names)
  result = {}
  keys = names.keys
  while !keys.empty?
    temp, keys = keys.partition do |x|
      size = [x.size, keys.first.size].min - 3
      x[0..size] == keys.first[0..size]
    end
    result[temp[0]] = temp.inject(0){|sum, x| sum + names[x]}
  end  
  result
end

names = cleanup(learn(text, initial))
puts names.keys.sort{|x,y| names[x] - names[y]}.map{|x| [x, names[x]].inspect}
