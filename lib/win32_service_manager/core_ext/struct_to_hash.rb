class Struct
  module ToHash
    module Ruby187
      def to_hash
        hashable!
        Hash[each_pair.to_a]
      end
    end

    module RubyOld
      def to_hash
        hashable!
        vals = []
        each_pair{|k,v| vals << k; vals << v}
        Hash[*vals]
      end
    end

    if RUBY_VERSION >= '1.8.7'
      include Ruby187
    else
      include RubyOld
    end

    def hashable?
      self.class.members.uniq == self.class.members
    end

    def hashable!
      raise ArgumentError, "#{self.inspect} has duplicate keys" unless hashable?
    end
  end

  include ToHash
end

if __FILE__ == $0

  require "benchmark"

  TESTS = 10_000
  Benchmark.bmbm do |results|
    ABC = Struct.new(:a,:b,:c)
    if RUBY_VERSION >= '1.8.7'
      a = ABC.new(1,2,3)
      a.extend Struct::ToHash::Ruby187
      results.report("new:") { TESTS.times { a.to_hash } }
    end
    b = ABC.new(1,2,3)
    b.extend Struct::ToHash::RubyOld
    results.report("old:") { TESTS.times { b.to_hash } }
  end

  puts

  begin; require 'rubygems'; rescue LoadError; end
  require 'bacon'
  Bacon.summary_on_exit


  describe "Struct#to_hash" do
    should 'not raise an error when calling to_hash on a new struct' do
      should.not.raise do
        Struct.new(:a).new(1).to_hash
      end
    end
  end

  describe "Struct#hashable?" do
    should 'return true if #to_hash will not raise' do
      Struct.new(:a).new(1).should.be.hashable
    end
    should 'return false if there are duplicate keys' do
      Struct.new(:a, :a).new(1, 2).should.not.be.hashable
    end
  end

  describe "Struct#hashable!" do
    should 'raise an ArgumentError when there are duplicate keys' do
      should.raise(ArgumentError) do
        Struct.new(:a, :a).new(1, 2).hashable!
      end
    end
  end

  supported_versions = [Struct::ToHash::RubyOld]
  supported_versions << Struct::ToHash::Ruby187 if RUBY_VERSION >= '1.8.7'
  supported_versions.each do |mod|
    describe mod do
      should 'raise an argument error when the struct has duplicate keys' do
        should.raise(ArgumentError) do
          s = Struct.new(:a, :a).new(1,2)
          s.extend mod
          s.to_hash
        end
      end
      should 'return a hash with keys associated with their values' do
        keys = %w(a b c d e).map { |k| k.to_sym }
        values = [1,2,3,4,5]
        result = Hash[*keys.zip(values).flatten]
        s = Struct.new(*keys).new(*values)
        s.extend mod
        s.to_hash.should.== result
      end
    end
  end

end