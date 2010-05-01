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

observations = Observations.new(text)

initial = ["Geralt", "Yennefer", "Ciri", "Jaskier"]

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
p transitions, initial_probabilities, emissions

model = Model.new(initial_probabilities, transitions, emissions)
names = Hash.new(0)
for fragment in text.split(/(\n[^\n]+(?=\n))/).select{|x| x != ""}
  model.names(fragment, observations).each {|x| names[x] += 1}
end
puts names.keys.sort{|x,y| names[x] - names[y]}
puts ClpWrapper.index("była")
puts "Była"
