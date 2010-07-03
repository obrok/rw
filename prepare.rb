require 'ner.rb'

if ARGV.size != 3
  puts "prepare.rb [plik_tekstowy] [bohater] [nie bohater]"
else
  text = File.open(ARGV[0]) do |f|
    f.read
  end
  puts prepare_examples(text, ARGV[1], ARGV[2]).to_yaml
end
