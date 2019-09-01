require "test_helper"

class MiniJava::IntermediateRepresentationVisitorTest < MiniTest::Test
  include MiniJava::InstructionsHelper, MiniJava::TypesHelper

  def test_representing_a_valid_program_with_variable_assignment
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

  def test_representing_a_valid_program_with_array_element_assignment
    instructions = represent(<<~JAVA)
      class HelloWorld {
        public static void main() {
          System.out.println(new Foo().bar());
        }
      }

      class Foo {
        public int bar() {
          int[] numbers;
          numbers = new int[3];
          numbers[1] = 42;
          return numbers[1];
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
      new_array(integer, 3, "%r2"),
      copy("numbers", "%r2"),
      copy(42, "%r3"),
      copy_into("%r3", "numbers", 1),
      index_into("numbers", 1, "%r4"),
      return_with("%r4")
    ], instructions
  end

  private
    def represent(source)
      program = MiniJava::Parser.program_from(source)
      scope = MiniJava::ScopeVisitor.scope_for(program)

      MiniJava::IntermediateRepresentationVisitor.represent(program, scope)
    end
end
