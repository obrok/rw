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
    model = Model.make_hmm([:verb, :subject, :object, :compliments], @@tagged)
    sentences(text).select{|x| x.include?("Ciri")}.each do |sentence|
      p sentence
      p model.decode(sentence)
      readline
    end
  end
end

text = ""

for file in Dir.glob("teksty/*")
  File.open(file) { |f| text += f.read }
end

Sentences.analyze(text)
