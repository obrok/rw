require 'ner.rb'
require 'yaml'

if ARGV.size != 2
  puts "analyze.rb [plik_tekstowy] [plik_z_przykladami]"
else
  text = File.open(ARGV[0]) do |f|
    f.read
  end
  examples = File.open(ARGV[1]) do |f|
    YAML.load(f)
  end
  puts analyze(text, examples).sort{|x,y| y.importance - x.importance}
end
