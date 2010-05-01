module Utils
  def self.fragments_containing(text, thing)
    text.scan(/\n.*#{thing}.*(?=\n)/)
  end
end
