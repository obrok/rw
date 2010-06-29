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

class Hash
  # Replacing the to_yaml function so it'll serialize hashes sorted (by their keys)
  #
  # Original function is in /usr/lib/ruby/1.8/yaml/rubytypes.rb
  def to_yaml( opts = {} )
    YAML::quick_emit( object_id, opts ) do |out|
      out.map( taguri, to_yaml_style ) do |map|
        sort.each do |k, v|   # <-- here's my addition (the 'sort')
          map.add( k, v )
        end
      end
    end
  end
end

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
  puts Iconv.conv("utf-8", "iso-8859-2", word), word.part_of_speech, "#{counts[word]} wystapien"
  answer = readline.to_i
  if answer != 0
    done[word] = (answer-3)/2.0
  else
    break
  end
end rescue nil

File.open("tagged_words.yml", "w+") {|file| file << done.to_yaml}
