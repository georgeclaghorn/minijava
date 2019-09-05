require "minijava"

class MiniJava::AMD64::GeneratorTest < MiniTest::Test
  include MiniJava::Protocode::InstructionsHelper, MiniJava::Protocode::OperandsHelper

  def test_hello
    actual = generate \
      protocode: [
        label("HelloWorld.main"),
        copy(5, register(0)),
        copy(4, register(1)),
        add(register(0), register(1), register(2)),
        parameter(register(2)),
        call("__println", 1, nil),
        void_return
      ],
      entrypoint: "HelloWorld.main"

    assert_equal fixture_file("hello.s").read, actual
  end

  def test_function
    actual = generate \
      protocode: [
        label("HelloWorld.main"),
        new_object("Foo", register(0)),
        parameter(register(0)),
        call("Foo.bar", 2, register(1)),
        parameter(register(1)),
        call("__println", 1, nil),
        void_return,

        label("Foo.bar"),
        copy(9, register(2)),
        return_with(register(2))
      ],
      entrypoint: "HelloWorld.main"

    assert_equal fixture_file("function.s").read, actual
  end

  private
    def generate(protocode:, entrypoint:)
      StringIO.new.tap do |destination|
        MiniJava::AMD64::Generator.new(destination).generate(protocode, entrypoint)
        destination.rewind
      end.read
    end

    def fixture_file(path)
      Pathname.new File.expand_path("../../../fixtures/#{path}", __dir__)
    end
end
