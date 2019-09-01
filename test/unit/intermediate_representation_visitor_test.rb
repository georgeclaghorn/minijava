require "test_helper"

class MiniJava::TypeCheckVisitorTest < MiniTest::Test
  include MiniJava::InstructionsHelper

  def test_generating_an_intermediate_representation_for_a_valid_program
    instructions = represent(<<~JAVA)
      class HelloWorld {
        public static void main() {
          System.out.println(new Foo().bar());
        }
      }

      class Foo {
        public int bar() {
          int number;
          number = 42;
          return number;
        }
      }
    JAVA

    assert_equal [
      label("HelloWorld$main"),
      new_object("Foo", "%r0"),
      parameter("%r0"),
      call("Foo$bar", 1, "%r1"),
      parameter("%r1"),
      call("__println", 1, nil),

      label("Foo$bar"),
      copy(42, "%r2"),
      copy("number", "%r2"),
      return_with("number")
    ], instructions
  end

  private
    def represent(source)
      program = MiniJava::Parser.program_from(source)
      scope = MiniJava::ScopeVisitor.scope_for(program)

      MiniJava::IntermediateRepresentationVisitor.represent(program, scope)
    end
end
