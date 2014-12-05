# encoding: utf-8

$:.unshift('lib') unless $:.first == 'lib'

require 'libcdb'
require 'tempfile'

RSpec.configure { |config|
  config.expect_with(:rspec) { |c| c.syntax = [:should, :expect] }

  config.include(Module.new {
    TEST_DATA = {}

    1.upto(10) { |i|
      v = TEST_DATA["k#{i}"] = []
      1.upto(i) { |j| v << "v#{i}.#{j}" }
    }

    TEST_DATA['€ürö'] = ['½a×¾b']

    TEST_DATA['a' * 1024] = ['b' * 1024 ** 2]

    def tempfile
      Tempfile.open("libcdb_spec_#{object_id}_temp")
    end

    def data(file)
      File.join(File.dirname(__FILE__), 'data', file)
    end

    def reader(cdb = :test)
      cdb = "#{cdb}.cdb" if cdb.is_a?(Symbol)
      LibCDB::CDB::Reader.new(File.open(data(cdb)))
    end
  })
}

class String
  alias_method :_original_inspect, :inspect
  def inspect; size > 100 ? "#{self.class}(#{size})" : _original_inspect; end
end
