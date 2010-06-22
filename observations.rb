require 'polish'
require 'clp'

class String
  def to_token
    self.gsub(/#{CAPITAL_LETTER}+/, "X").
      gsub(/#{SMALL_LETTER}+/, "x").
      gsub(/[^xX]/, ".")
  end
end

class Observations
  def initialize(text)
    @mapping = {}
    @reverse_mapping = {}
    for word in text.split(" ")
      observable = to_observable(word)
      @mapping[observable] ||= next_number
      @reverse_mapping[@mapping[observable]] = observable
    end
  end

  def as_i(observation)
    @mapping[observation] || 0
  end

  def as_obs(number)
    @reverse_mapping[number] || ""
  end

  def observables
    [""] + @mapping.keys
  end

  def convert_to_observations(fragment)
    fragment = fragment.split(" ")
    fragment.zip(fragment.map{|x| as_i(to_observable(x))})
  end

  def size
    observables.size
  end

  private
  def next_number
    @number ||= 0
    @number += 1
  end

  def to_observable(word)
    result = word.to_token
    if !ClpWrapper.index(word)
      result += ":F"
    else
      result += ":T:#{ClpWrapper.flex_label(word)[0..0]}"
    end
  end
end
