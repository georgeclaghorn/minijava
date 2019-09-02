require "test_helper"

class MiniJava::IntermediateRepresentationVisitorTest < MiniTest::Test
  include MiniJava::InstructionsHelper, MiniJava::TypesHelper

  def test_representing_variable_assignment
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
      label("HelloWorld.main"),
      new_object("Foo", "%r0"),
      parameter("%r0"),
      call("Foo.bar", 1, "%r1"),
      parameter("%r1"),
      call("__println", 1, nil),

      label("Foo.bar"),
      copy(42, "%r2"),
      copy("%r2", "number"),
      return_with("number")
    ], instructions
  end

  def test_representing_array_element_assignment
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
      label("HelloWorld.main"),
      new_object("Foo", "%r0"),
      parameter("%r0"),
      call("Foo.bar", 1, "%r1"),
      parameter("%r1"),
      call("__println", 1, nil),

      label("Foo.bar"),
      new_array(integer, 3, "%r2"),
      copy("%r2", "numbers"),
      copy(42, "%r3"),
      copy_into("%r3", "numbers", 1),
      index_into("numbers", 1, "%r4"),
      return_with("%r4")
    ], instructions
  end

  def test_representing_if_statement
    instructions = represent(<<~JAVA)
      class HelloWorld {
        public static void main() {
          System.out.println(new Foo().bar());
        }
      }

      class Foo {
        public int bar() {
          int number;

          if (true) {
            number = 1;
          } else {
            number = 2;
          }

          return number;
        }
      }
    JAVA

    assert_equal [
      label("HelloWorld.main"),
      new_object("Foo", "%r0"),
      parameter("%r0"),
      call("Foo.bar", 1, "%r1"),
      parameter("%r1"),
      call("__println", 1, nil),

      label("Foo.bar"),
      copy(true, "%r2"),
      jump_unless("%r2", ".if.0.else"),
      copy(1, "%r3"),
      copy("%r3", "number"),
      jump(".if.0.end"),
      label(".if.0.else"),
      copy(2, "%r4"),
      copy("%r4", "number"),
      label(".if.0.end"),
      return_with("number")
    ], instructions
  end

  def test_representing_nested_if_statements
    instructions = represent(<<~JAVA)
      class HelloWorld {
        public static void main() {
          System.out.println(new Foo().bar());
        }
      }

      class Foo {
        public int bar() {
          int number;

          if (true) {
            if (true) {
              number = 1;
            } else {
              number = 2;
            }
          } else {
            number = 3;
          }

          return number;
        }
      }
    JAVA

    assert_equal [
      label("HelloWorld.main"),
      new_object("Foo", "%r0"),
      parameter("%r0"),
      call("Foo.bar", 1, "%r1"),
      parameter("%r1"),
      call("__println", 1, nil),

      label("Foo.bar"),
      copy(true, "%r2"),
      jump_unless("%r2", ".if.0.else"),
      copy(true, "%r3"),
      jump_unless("%r3", ".if.1.else"),
      copy(1, "%r4"),
      copy("%r4", "number"),
      jump(".if.1.end"),
      label(".if.1.else"),
      copy(2, "%r5"),
      copy("%r5", "number"),
      label(".if.1.end"),
      jump(".if.0.end"),
      label(".if.0.else"),
      copy(3, "%r6"),
      copy("%r6", "number"),
      label(".if.0.end"),
      return_with("number")
    ], instructions
  end

  def test_representing_while_statement
    instructions = represent(<<~JAVA)
      class HelloWorld {
        public static void main() {
          System.out.println(new Foo().bar());
        }
      }

      class Foo {
        public int bar() {
          int number;

          while (true) {
            number = 1;
          }

          return number;
        }
      }
    JAVA

    assert_equal [
      label("HelloWorld.main"),
      new_object("Foo", "%r0"),
      parameter("%r0"),
      call("Foo.bar", 1, "%r1"),
      parameter("%r1"),
      call("__println", 1, nil),

      label("Foo.bar"),
      label(".while.0.begin"),
      copy(true, "%r2"),
      jump_unless("%r2", ".while.0.end"),
      copy(1, "%r3"),
      copy("%r3", "number"),
      jump(".while.0.begin"),
      label(".while.0.end"),
      return_with("number")
    ], instructions
  end

  def test_representing_nested_while_statements
    instructions = represent(<<~JAVA)
      class HelloWorld {
        public static void main() {
          System.out.println(new Foo().bar());
        }
      }

      class Foo {
        public int bar() {
          int number;

          while (true) {
            while (true) {
              number = 2;
            }
          }

          return number;
        }
      }
    JAVA

    assert_equal [
      label("HelloWorld.main"),
      new_object("Foo", "%r0"),
      parameter("%r0"),
      call("Foo.bar", 1, "%r1"),
      parameter("%r1"),
      call("__println", 1, nil),

      label("Foo.bar"),
      label(".while.0.begin"),
      copy(true, "%r2"),
      jump_unless("%r2", ".while.0.end"),
      label(".while.1.begin"),
      copy(true, "%r3"),
      jump_unless("%r3", ".while.1.end"),
      copy(2, "%r4"),
      copy("%r4", "number"),
      jump(".while.1.begin"),
      label(".while.1.end"),
      jump(".while.0.begin"),
      label(".while.0.end"),
      return_with("number")
    ], instructions
  end

  def test_representing_array_length
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
          return numbers.length;
        }
      }
    JAVA

    assert_equal [
      label("HelloWorld.main"),
      new_object("Foo", "%r0"),
      parameter("%r0"),
      call("Foo.bar", 1, "%r1"),
      parameter("%r1"),
      call("__println", 1, nil),

      label("Foo.bar"),
      new_array(integer, 3, "%r2"),
      copy("%r2", "numbers"),
      length_of("numbers", "%r3"),
      return_with("%r3")
    ], instructions
  end

  private
    def represent(source)
      program = MiniJava::Parser.program_from(source)
      scope = MiniJava::ScopeVisitor.scope_for(program)

      MiniJava::IntermediateRepresentationVisitor.represent(program, scope)
    end
end
