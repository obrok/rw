require 'polish'
require 'java'
require 'jna.jar'
require 'clp/clp.jar'
require 'iconv'

java_import "com.sun.jna.Native"
java_import "CLP"
java_import "java.nio.IntBuffer"
java_import "java.nio.ByteBuffer"
java_import "java.lang.String" do
  "JString"
end

class String
  def to_bytes
    (self.split(//).map{|x| x[0]} + [0]).to_java(:byte)
  end
end

module ClpWrapper
  CLPInstance = Native.load_library("/usr/local/clp/lib/libclp_2.2.so", CLP.java_class)
  CLPInstance.clp_init
  CLPHits = {}
  CLPMisses = {}
  LabelHits = {}
  PositionHits = {}

  def self.version
    CLPInstance.clp_ver
  end

  def self.index(word)
    word = preprocess(word)
    if CLPHits[word]
      return CLPHits[word]
    elsif CLPMisses[word]
      return nil
    else
      outputs = IntBuffer.allocate(10)
      output_no = IntBuffer.allocate(1)
      CLPInstance.clp_rec(word.to_bytes, outputs, output_no)
      if output_no.get == 0
        CLPMisses[word] = true
        return nil
      else
        return CLPHits[word] = outputs.get
      end
    end
  end

  def self.flex_label(word)
    word = preprocess(word)
    return LabelHits[word] if LabelHits[word]
    index = ClpWrapper.index(word)
    return nil unless index
    outputs = ByteBuffer.allocate(10)
    CLPInstance.clp_label(index, outputs)
    result = JString.new(outputs.array).to_s[/[A-Z]+/]
    LabelHits[word] = result
  end

  def self.flex_position(word)
    word = preprocess(word)
    return PositionHits[word] if PositionHits[word]
    outputs = IntBuffer.allocate(10)
    output_no = IntBuffer.allocate(1)
    index = ClpWrapper.index(word)
    return nil unless index
    CLPInstance.clp_vec(index, word.to_bytes, outputs, output_no)
    if output_no.get == 0
      return nil
    else
      return PostionHits[word] = outputs.get
    end
  end

  def self.base_form(word)
    word = preprocess(word)
    outputs = ByteBuffer.allocate(50)
    index = ClpWrapper.index(word)
    return nil unless index
    CLPInstance.clp_bform(index, outputs)
    Iconv.conv("iso-8859-2", "utf-8", JString.new(outputs.array, "iso-8859-2").to_s.gsub("\000", ""))
  end

  def self.preprocess(word)
    word.gsub(/[., :;-?!]/, "")
  end
end

