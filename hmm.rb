require 'java'
require 'jahmm-0.6.1.jar'
require 'utils'

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

  def initialize(initial, transitions, emissions)
    @hmm = HmmWrapper.new(initial.size)
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

  def names(fragment, observations)
    fragment = observations.convert_to_observations(fragment)
    observation_list = ArrayList.new
    fragment.each {|x| observation_list.add(ObservationInteger.new(x[1]))}
    return [] if observation_list.size == 0
    fragment.zip(@hmm.most_likely_state_sequence(observation_list)).select{|x| x[1] == 1}.map{|x| x[0][0]}
  end
end
