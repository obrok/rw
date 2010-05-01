require 'polish'

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
      token = word.to_token
      @mapping[token] ||= next_number
      @reverse_mapping[@mapping[token]] = token
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
    fragment.zip(fragment.map{|x| as_i(x.to_token)})
  end


  private
  def next_number
    @number ||= 0
    @number += 1
  end
end
