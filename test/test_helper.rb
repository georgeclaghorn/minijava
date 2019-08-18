require "bundler/setup"
require "minitest/autorun"
require "byebug"

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "minijava"

class MiniTest::Test
  private
    def capture(stream)
      destination = Tempfile.new
      origin = stream.dup

      stream.reopen(destination)
      yield
      stream.rewind
      destination.read
    ensure
      destination.close!
      stream.reopen(origin)
    end
end
