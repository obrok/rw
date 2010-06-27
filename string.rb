require 'clp'

class String
  def part_of_speech
    case ClpWrapper.flex_label(self)[0..0]
      when "A" then :noun
      when "B" then :verb
      when "C" then :adjective
      when "F" then :adverb
    end
  end
end
