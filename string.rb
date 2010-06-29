require 'clp'
require 'yaml'

class String
  @@emotional_values = File.open("tagged_words.yml", "r") do |file|
    YAML.load(file)
  end

  def part_of_speech
    label = ClpWrapper.flex_label(self)
    return nil unless label
    case label[0..0]
      when "A" then :noun
      when "B" then :verb
      when "C" then :adjective
      when "F" then :adverb
    end
  end

  def base_form
    index = ClpWrapper.index(self)
    return self unless index
    return ClpWrapper.base_form(self)
  end

  def emotional_value
    @@emotional_values[base_form] || 0.0
  end
end
