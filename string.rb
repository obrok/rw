require 'clp'

class String
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
end
