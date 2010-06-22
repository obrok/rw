require 'java'
require 'jahmm-0.6.1.jar'
require 'utils'
require 'observations'

java_import "be.ac.ulg.montefiore.run.jahmm.ObservationInteger"
java_import "be.ac.ulg.montefiore.run.jahmm.OpdfInteger"
java_import "be.ac.ulg.montefiore.run.jahmm.Hmm"
java_import "java.util.ArrayList"

# A wrapper for the Jahmm's Hmm
class Model
  class HmmWrapper < Hmm
    def initialize(nbstates)
      super(nbstates)
    end
  end

  def initialize(initial, transitions, emissions, state_nos = nil, observations = nil)
    @hmm = HmmWrapper.new(initial.size)
    @state_nos = state_nos
    @state_names = {}
    @state_nos.each do |name, number|
      @state_names[number] = name
    end
    @observations = observations

    initial.each_with_index {|el, i| @hmm.set_pi(i, el)}
    transitions.each_with_index do |row, i|
      row.each_with_index do |el, j|
        @hmm.set_aij(i, j, el)
      end
    end
    emissions.each_with_index do |emission, i|
      @hmm.set_opdf(i, OpdfInteger.new(emission.to_java(:double)))
    end
  end

  def decode(text)
    obs_sequence = @observations.convert_to_observations(text)
    observation_list = ArrayList.new
    obs_sequence.each {|x| observation_list.add(ObservationInteger.new(x[1]))}
    return [] if observation_list.size == 0
    return @hmm.most_likely_state_sequence(observation_list).map{|x| @state_names[x]}
  end

  def names(fragment, observations)
    fragment = observations.convert_to_observations(fragment)
    observation_list = ArrayList.new
    fragment.each {|x| observation_list.add(ObservationInteger.new(x[1]))}
    return [] if observation_list.size == 0
    fragment.zip(@hmm.most_likely_state_sequence(observation_list)).select{|x| x[1] == 1}.map{|x| x[0][0]}
  end

  def self.make_hmm(states, tagged_texts)
    states << :default
    state_nos = {}
    states.each_with_index {|x,i| state_nos[x] = i}
    initial = states.map{|x| 0}
    transitions = states.map{|x| [0]*states.size}

    observations = Observations.new(tagged_texts.keys.join(" "))
    emissions = states.map{|x| [0]*observations.size}

    for text in tagged_texts.keys
      obs_sequence = observations.convert_to_observations(text).map{|x| x[1]}      

      state_sequence = obs_sequence.map{|x| :default}
      for state, indices in tagged_texts[text]
        indices.each do |i|
          state_sequence[i] = state unless i >= state_sequence.size || i < 0
        end
      end

      state_sequence.map!{|x| state_nos[x]}
      initial[state_sequence.first] += 1
      state_sequence.each_cons(2) {|from, to| transitions[from][to] += 1}
      state_sequence.zip(obs_sequence) {|state, obs| emissions[state][obs] += 1}
    end

    initial.normalize!
    transitions.each{|x| x.normalize!}
    emissions.each {|x| x.normalize!}

    return Model.new(initial, transitions, emissions, state_nos, observations)
  end
end
