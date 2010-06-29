# -*- coding: iso-8859-2 -*-

require 'polish'
require 'array'
require 'observations'
require 'utils'
require 'hmm'
require 'clp'
require 'yaml'
require 'string'
require 'iconv'

text = ""

for file in Dir.glob("teksty/*")
  File.open(file) { |f| text += f.read }
end

done = {}

File.open("tagged_words.yml", "r") do |file|
  done = YAML.load(file)
end rescue nil

words = text.split.map{|x| x.base_form}.select{|x| !done[x] && x.part_of_speech}
counts = Hash.new(0)
for word in words
  counts[word] += 1
end
words = counts.keys.sort{|x,y| counts[y] - counts[x]}

words.each_with_index do |word, i|
  prompt = "#{words.size - i} słów do przetworzenia; odpowiedz 1-5 albo k - koniec"
  puts Iconv.conv("utf-8", "iso-8859-2", prompt)
  puts Iconv.conv("utf-8", "iso-8859-2", word), word.part_of_speech
  answer = readline.to_i
  if answer != 0
    done[word] = (answer-3)/2.0
  else
    break
  end
end rescue nil

File.open("tagged_words.yml", "w+") {|file| file << done.to_yaml}
