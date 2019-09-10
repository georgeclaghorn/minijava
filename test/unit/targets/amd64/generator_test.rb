require "minijava"

class MiniJava::AMD64::GeneratorTest < MiniTest::Test
  include MiniJava::Protocode::InstructionsHelper, MiniJava::Protocode::OperandsHelper

  def test_hello
    actual = generate \
      protocode: [
        function(
          name: "HelloWorld.main",
          parameter_count: 0,
          instructions: [
            copy(5, temporary(0)),
            copy(4, temporary(1)),
            add(temporary(0), temporary(1), temporary(2)),
            parameter(temporary(2)),
            call("System.out.println", 1, nil)
          ]
        )
      ],
      entrypoint: "HelloWorld.main"

    assert_equal fixture_file("amd64/hello.S").read, actual
  end

  def test_function
    actual = generate \
      protocode: [
        function(
          name: "HelloWorld.main",
          parameter_count: 0,
          instructions: [
            new_object("Foo", temporary(0)),
            copy(5, temporary(1)),
            copy(4, temporary(2)),
            parameter(temporary(0)),
            parameter(temporary(1)),
            parameter(temporary(2)),
            call("Foo.bar", 3, temporary(3)),
            parameter(temporary(3)),
            call("System.out.println", 1, nil)
          ]
        ),

        function(
          name: "Foo.bar",
          parameter_count: 3,
          instructions: [
            add(temporary(1), temporary(2), temporary(3)),
            return_with(temporary(3))
          ]
        )
      ],
      entrypoint: "HelloWorld.main"

    assert_equal fixture_file("amd64/function.S").read, actual
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
