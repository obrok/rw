# -*- coding: iso-8859-2 -*-

require 'polish'
require 'array'
require 'observations'
require 'utils'
require 'hmm'
require 'clp'
require 'yaml'

class Sentences
  @@tagged = File.open("tagged_sentences.yml", "r") do |file|
    YAML.load(file)
  end rescue {}

  def self.sentences(text)
    text.scan(/(?:#{LETTER}| |-)+[,.!]/)
  end

  def self.analyze(text)
    Model.make_hmm([:verb, :subject, :object, :compliments], @@tagged).decode(@@tagged.keys.first)
  end
end
