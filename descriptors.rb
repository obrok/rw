# -*- coding: iso-8859-2 -*-

require 'polish'
require 'array'
require 'observations'
require 'utils'
require 'hmm'
require 'clp'
require 'string'

text = ""

for file in Dir.glob("teksty/*")
  File.open(file) { |f| text += f.read }
end

fragments = text.split(/(\n[^\n]+(?=\n))/)
rankings = Hash.new{|hsh, key| hsh[key] = Hash.new(0)}
name = "Geralt"
other_name = "Yen"

for fragment in fragments.select{|x| x.include?(name) && x.include?(other_name)}
  text = fragment.strip.split.map{|x| x.gsub(/[.?!,]/, "")}
  name_locs = []
  other_name_locs = []
  text.each_with_index{|x,i| name_locs << i if x =~ /#{name}/}
  text.each_with_index{|x,i| other_name_locs << i if x =~ /#{name}/}
  text.each_with_index do |word, index|
    dist = name_locs.map{|x| (x - index).abs}.min + other_name_locs.map{|x| (x-index).abs}.min
    if dist != 0
      rankings[word.part_of_speech][word.base_form] += 1.0/dist**2
    end
  end
end

temp = rankings[:adjective]
puts temp.keys.sort{|x,y| temp[x] - temp[y]}.map{|x| "#{x}: #{temp[x]}"}
