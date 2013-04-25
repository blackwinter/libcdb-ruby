$:.unshift('lib') unless $:.first == 'lib'

require 'libcdb'
require 'tempfile'

RSpec.configure { |config|
  config.include(Module.new {
    TEST_DATA = {}

    1.upto(10) { |i|
      v = TEST_DATA["k#{i}"] = []
      1.upto(i) { |j| v << "v#{i}.#{j}" }
    }

    TEST_DATA['a' * 1024] = Array('b' * 1024 ** 2)

    def tempfile
      Tempfile.open("libcdb_spec_#{object_id}_temp")
    end
  })
}
