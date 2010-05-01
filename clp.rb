require 'polish'
require 'java'
require 'jna.jar'
require 'clp/clp.jar'

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

  def self.version
    CLPInstance.clp_ver
  end

  def self.index(word)
    word = preprocess(word)
    outputs = IntBuffer.allocate(10)
    output_no = IntBuffer.allocate(1)
    CLPInstance.clp_rec(word.to_bytes, outputs, output_no)
    if output_no.get == 0
      return nil
    else
      return outputs.get
    end
  end

  def self.flex_label(word)
    word = preprocess(word)
    index = ClpWrapper.index(word)
    return nil unless index
    outputs = ByteBuffer.allocate(10)
    CLPInstance.clp_label(index, outputs)
    JString.new(outputs.array).to_s[/[A-Z]+/]
  end

  def self.flex_position(word)
    word = preprocess(word)
    outputs = IntBuffer.allocate(10)
    output_no = IntBuffer.allocate(1)
    index = ClpWrapper.index(word)
    return nil unless index
    CLPInstance.clp_vec(index, word.to_bytes, outputs, output_no)
    if output_no.get == 0
      return nil
    else
      return outputs.get
    end
  end

  def self.preprocess(word)
    word.gsub(/[., :;-?!]/, "")
  end
end

