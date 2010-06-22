# -*- coding: iso-8859-2 -*-

require 'polish'
require 'array'
require 'observations'
require 'utils'
require 'hmm'
require 'clp'
require 'yaml'
require 'sentences'

text = ""

for file in Dir.glob("teksty/*")
  File.open(file) { |f| text += f.read }
end

done = {}

File.open("tagged_sentences.yml", "r") do |file|
  done = YAML.load(file)
end rescue nil

Sentences.sentences(text).each do |sentence|
  unless done[sentence.strip]
    temp = {}
    puts sentence.strip
    words = sentence.split(" ")
    puts words.zip((0..words.size).to_a).map{|x,y| "#{y+1}: #{x}"}
    puts "Wskaż podmiot. 0 - brak."
    temp[:subject] = [readline.to_i - 1]
    puts "Wskaż orzeczenie. 0 - brak."
    temp[:verb] = [readline.to_i - 1]
    puts "Wskaż dopełnienie. 0 - brak."
    temp[:object] = [readline.to_i - 1]
    puts "Wskaż przydawki, 0 - koniec."
    temp[:compliments] = []
    while (temp2 = readline.to_i) != 0
      temp[:compliments] << temp2
    end
    done[sentence.strip] = temp
  end
end rescue nil

File.open("tagged_sentences.yml", "w+") {|file| file << done.to_yaml}
