# -*- coding: iso-8859-2 -*-

require 'polish'
require 'array'
require 'observations'
require 'utils'
require 'hmm'
require 'clp'

text = ""

for file in Dir.glob("teksty/*")
  File.open(file) { |f| text += f.read }
end
