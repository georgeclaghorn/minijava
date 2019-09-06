require "minijava"

class MiniJava::AMD64::GeneratorTest < MiniTest::Test
  include MiniJava::Protocode::InstructionsHelper, MiniJava::Protocode::OperandsHelper

  def test_hello
    actual = generate \
      protocode: [
        label("HelloWorld.main"),
        copy(5, temporary(0)),
        copy(4, temporary(1)),
        add(temporary(0), temporary(1), temporary(2)),
        parameter(temporary(2)),
        call("__println", 1, nil),
        void_return
      ],
      entrypoint: "HelloWorld.main"

    assert_equal fixture_file("amd64/hello.s").read, actual
  end

  def test_function
    actual = generate \
      protocode: [
        label("HelloWorld.main"),
        new_object("Foo", temporary(0)),
        parameter(temporary(0)),
        call("Foo.bar", 2, temporary(1)),
        parameter(temporary(1)),
        call("__println", 1, nil),
        void_return,

        label("Foo.bar"),
        copy(9, temporary(2)),
        return_with(temporary(2))
      ],
      entrypoint: "HelloWorld.main"

    assert_equal fixture_file("amd64/function.s").read, actual
  end

  private
    def generate(protocode:, entrypoint:)
      StringIO.new
        .tap { |destination| MiniJava::AMD64::Generator.new(destination).generate(protocode, entrypoint) }
        .then do |destination|
          destination.rewind
          destination.read
        end
    end
end
