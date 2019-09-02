require "test_helper"

class MiniJava::ProtocodeVisitorTest < MiniTest::Test
  include MiniJava::Protocode::InstructionsHelper, MiniJava::Protocode::OperandsHelper
  include MiniJava::Syntax::TypesHelper

  def test_variable_assignment
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
      new_object("Foo", register(0)),
      parameter(register(0)),
      call("Foo.bar", 1, register(1)),
      parameter(register(1)),
      call("__println", 1, nil),

      label("Foo.bar"),
      copy(42, register(2)),
      copy(register(2), variable("number")),
      return_with(variable("number")),
    ], instructions
  end

  def test_array_element_assignment
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
      new_object("Foo", register(0)),
      parameter(register(0)),
      call("Foo.bar", 1, register(1)),
      parameter(register(1)),
      call("__println", 1, nil),

      label("Foo.bar"),
      new_array(integer, 3, register(2)),
      copy(register(2), variable("numbers")),
      copy(42, register(3)),
      copy_into(register(3), variable("numbers"), 1),
      index_into(variable("numbers"), 1, register(4)),
      return_with(register(4))
    ], instructions
  end

  def test_if_statement
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
      new_object("Foo", register(0)),
      parameter(register(0)),
      call("Foo.bar", 1, register(1)),
      parameter(register(1)),
      call("__println", 1, nil),

      label("Foo.bar"),
      copy(true, register(2)),
      jump_unless(register(2), ".if.0.else"),
      copy(1, register(3)),
      copy(register(3), variable("number")),
      jump(".if.0.end"),
      label(".if.0.else"),
      copy(2, register(4)),
      copy(register(4), variable("number")),
      label(".if.0.end"),
      return_with(variable("number"))
    ], instructions
  end

  def test_nested_if_statements
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
      new_object("Foo", register(0)),
      parameter(register(0)),
      call("Foo.bar", 1, register(1)),
      parameter(register(1)),
      call("__println", 1, nil),

      label("Foo.bar"),
      copy(true, register(2)),
      jump_unless(register(2), ".if.0.else"),
      copy(true, register(3)),
      jump_unless(register(3), ".if.1.else"),
      copy(1, register(4)),
      copy(register(4), variable("number")),
      jump(".if.1.end"),
      label(".if.1.else"),
      copy(2, register(5)),
      copy(register(5), variable("number")),
      label(".if.1.end"),
      jump(".if.0.end"),
      label(".if.0.else"),
      copy(3, register(6)),
      copy(register(6), variable("number")),
      label(".if.0.end"),
      return_with(variable("number"))
    ], instructions
  end

  def test_while_statement
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
      new_object("Foo", register(0)),
      parameter(register(0)),
      call("Foo.bar", 1, register(1)),
      parameter(register(1)),
      call("__println", 1, nil),

      label("Foo.bar"),
      label(".while.0.begin"),
      copy(true, register(2)),
      jump_unless(register(2), ".while.0.end"),
      copy(1, register(3)),
      copy(register(3), variable("number")),
      jump(".while.0.begin"),
      label(".while.0.end"),
      return_with(variable("number"))
    ], instructions
  end

  def test_nested_while_statements
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
      new_object("Foo", register(0)),
      parameter(register(0)),
      call("Foo.bar", 1, register(1)),
      parameter(register(1)),
      call("__println", 1, nil),

      label("Foo.bar"),
      label(".while.0.begin"),
      copy(true, register(2)),
      jump_unless(register(2), ".while.0.end"),
      label(".while.1.begin"),
      copy(true, register(3)),
      jump_unless(register(3), ".while.1.end"),
      copy(2, register(4)),
      copy(register(4), variable("number")),
      jump(".while.1.begin"),
      label(".while.1.end"),
      jump(".while.0.begin"),
      label(".while.0.end"),
      return_with(variable("number"))
    ], instructions
  end

  def test_logical_operators
    instructions = represent(<<~JAVA)
      class HelloWorld {
        public static void main() {
          System.out.println(new Foo().bar(42));
        }
      }

      class Foo {
        public int bar(int baz) {
          int result;

          if (this.glorp(baz)) {
            result = baz;
          } else {
            result = 0;
          }

          return result;
        }

        public int glorp(int baz) {
          return !(baz < 1) && baz < 100;
        }
      }
    JAVA

    assert_equal [
      label("HelloWorld.main"),
      new_object("Foo", register(0)),
      copy(42, register(1)),
      parameter(register(1)),
      parameter(register(0)),
      call("Foo.bar", 2, register(2)),
      parameter(register(2)),
      call("__println", 1, nil),

      label("Foo.bar"),
      parameter(variable("baz")),
      parameter(this),
      call("Foo.glorp", 2, register(3)),
      jump_unless(register(3), ".if.0.else"),
      copy(variable("baz"), variable("result")),
      jump(".if.0.end"),
      label(".if.0.else"),
      copy(0, register(4)),
      copy(register(4), variable("result")),
      label(".if.0.end"),
      return_with(variable("result")),

      label("Foo.glorp"),
      copy(1, register(5)),
      less_than(variable("baz"), register(5), register(6)),
      not_of(register(6), register(7)),
      copy(100, register(8)),
      less_than(variable("baz"), register(8), register(9)),
      and_of(register(7), register(9), register(10)),
      return_with(register(10))
    ], instructions
  end

  def test_arithmetic_operators
    instructions = represent(<<~JAVA)
      class HelloWorld {
        public static void main() {
          System.out.println(new Foo().bar(42));
        }
      }

      class Foo {
        public int bar(int baz) {
          int glorp;
          glorp = 4;
          return (baz * 7) + (baz - glorp);
        }
      }
    JAVA

    assert_equal [
      label("HelloWorld.main"),
      new_object("Foo", register(0)),
      copy(42, register(1)),
      parameter(register(1)),
      parameter(register(0)),
      call("Foo.bar", 2, register(2)),
      parameter(register(2)),
      call("__println", 1, nil),

      label("Foo.bar"),
      copy(4, register(3)),
      copy(register(3), variable("glorp")),
      copy(7, register(4)),
      multiply(variable("baz"), register(4), register(5)),
      subtract(variable("baz"), variable("glorp"), register(6)),
      add(register(5), register(6), register(7)),
      return_with(register(7)),
    ], instructions
  end

  def test_array_length
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
      new_object("Foo", register(0)),
      parameter(register(0)),
      call("Foo.bar", 1, register(1)),
      parameter(register(1)),
      call("__println", 1, nil),

      label("Foo.bar"),
      new_array(integer, 3, register(2)),
      copy(register(2), variable("numbers")),
      length_of(variable("numbers"), register(3)),
      return_with(register(3))
    ], instructions
  end

  def test_this
    instructions = represent(<<~JAVA)
      class HelloWorld {
        public static void main() {
          System.out.println(new Foo().bar());
        }
      }

      class Foo {
        public int bar() {
          return this.baz();
        }

        public int baz() {
          return 42;
        }
      }
    JAVA

    assert_equal [
      label("HelloWorld.main"),
      new_object("Foo", register(0)),
      parameter(register(0)),
      call("Foo.bar", 1, register(1)),
      parameter(register(1)),
      call("__println", 1, nil),

      label("Foo.bar"),
      parameter(this),
      call("Foo.baz", 1, register(2)),
      return_with(register(2)),

      label("Foo.baz"),
      copy(42, register(3)),
      return_with(register(3))
    ], instructions
  end

  private
    def represent(source)
      program = MiniJava::Parser.program_from(source)
      scope = MiniJava::ScopeVisitor.scope_for(program)

      MiniJava::ProtocodeVisitor.protocode_for(program, scope)
    end
end
