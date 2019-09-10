require "test_helper"

class MiniJava::ProtocodeVisitorTest < MiniTest::Test
  include MiniJava::Protocode::InstructionsHelper, MiniJava::Protocode::OperandsHelper
  include MiniJava::Syntax::TypesHelper

  def test_variable_assignment
    protocode = represent(<<~JAVA)
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
      function(
        name: "HelloWorld.main",
        parameter_count: 0,
        instructions: [
          new_object("Foo", temporary(0)),
          parameter(temporary(0)),
          call("Foo.bar", 1, temporary(1)),
          parameter(temporary(1)),
          call("System.out.println", 1, nil)
        ]
      ),

      function(
        name: "Foo.bar",
        parameter_count: 1,
        instructions: [
          copy(42, temporary(1)),
          copy(temporary(1), variable("number")),
          return_with(variable("number"))
        ]
      )
    ], protocode
  end

  def test_array_element_assignment
    protocode = represent(<<~JAVA)
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
      function(
        name: "HelloWorld.main",
        parameter_count: 0,
        instructions: [
          new_object("Foo", temporary(0)),
          parameter(temporary(0)),
          call("Foo.bar", 1, temporary(1)),
          parameter(temporary(1)),
          call("System.out.println", 1, nil)
        ]
      ),

      function(
        name: "Foo.bar",
        parameter_count: 1,
        instructions: [
          new_array(integer, 3, temporary(1)),
          copy(temporary(1), variable("numbers")),
          copy(42, temporary(2)),
          copy_into(temporary(2), variable("numbers"), 1),
          index_into(variable("numbers"), 1, temporary(3)),
          return_with(temporary(3))
        ]
      )
    ], protocode
  end

  def test_if_statement
    protocode = represent(<<~JAVA)
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
      function(
        name: "HelloWorld.main",
        parameter_count: 0,
        instructions: [
          new_object("Foo", temporary(0)),
          parameter(temporary(0)),
          call("Foo.bar", 1, temporary(1)),
          parameter(temporary(1)),
          call("System.out.println", 1, nil)
        ]
      ),

      function(
        name: "Foo.bar",
        parameter_count: 1,
        instructions: [
          copy(true, temporary(1)),
          jump_unless(temporary(1), ".if.0.else"),
          copy(1, temporary(2)),
          copy(temporary(2), variable("number")),
          jump(".if.0.end"),
          label(".if.0.else"),
          copy(2, temporary(3)),
          copy(temporary(3), variable("number")),
          label(".if.0.end"),
          return_with(variable("number"))
        ]
      )
    ], protocode
  end

  def test_nested_if_statements
    protocode = represent(<<~JAVA)
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
      function(
        name: "HelloWorld.main",
        parameter_count: 0,
        instructions: [
          new_object("Foo", temporary(0)),
          parameter(temporary(0)),
          call("Foo.bar", 1, temporary(1)),
          parameter(temporary(1)),
          call("System.out.println", 1, nil)
        ]
      ),

      function(
        name: "Foo.bar",
        parameter_count: 1,
        instructions: [
          copy(true, temporary(1)),
          jump_unless(temporary(1), ".if.0.else"),
          copy(true, temporary(2)),
          jump_unless(temporary(2), ".if.1.else"),
          copy(1, temporary(3)),
          copy(temporary(3), variable("number")),
          jump(".if.1.end"),
          label(".if.1.else"),
          copy(2, temporary(4)),
          copy(temporary(4), variable("number")),
          label(".if.1.end"),
          jump(".if.0.end"),
          label(".if.0.else"),
          copy(3, temporary(5)),
          copy(temporary(5), variable("number")),
          label(".if.0.end"),
          return_with(variable("number"))
        ]
      )
    ], protocode
  end

  def test_while_statement
    protocode = represent(<<~JAVA)
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
      function(
        name: "HelloWorld.main",
        parameter_count: 0,
        instructions: [
          new_object("Foo", temporary(0)),
          parameter(temporary(0)),
          call("Foo.bar", 1, temporary(1)),
          parameter(temporary(1)),
          call("System.out.println", 1, nil)
        ]
      ),

      function(
        name: "Foo.bar",
        parameter_count: 1,
        instructions: [
          label(".while.0.begin"),
          copy(true, temporary(1)),
          jump_unless(temporary(1), ".while.0.end"),
          copy(1, temporary(2)),
          copy(temporary(2), variable("number")),
          jump(".while.0.begin"),
          label(".while.0.end"),
          return_with(variable("number"))
        ]
      )
    ], protocode
  end

  def test_nested_while_statements
    protocode = represent(<<~JAVA)
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
      function(
        name: "HelloWorld.main",
        parameter_count: 0,
        instructions: [
          new_object("Foo", temporary(0)),
          parameter(temporary(0)),
          call("Foo.bar", 1, temporary(1)),
          parameter(temporary(1)),
          call("System.out.println", 1, nil)
        ]
      ),

      function(
        name: "Foo.bar",
        parameter_count: 1,
        instructions: [
          label(".while.0.begin"),
          copy(true, temporary(1)),
          jump_unless(temporary(1), ".while.0.end"),
          label(".while.1.begin"),
          copy(true, temporary(2)),
          jump_unless(temporary(2), ".while.1.end"),
          copy(2, temporary(3)),
          copy(temporary(3), variable("number")),
          jump(".while.1.begin"),
          label(".while.1.end"),
          jump(".while.0.begin"),
          label(".while.0.end"),
          return_with(variable("number"))
        ]
      )
    ], protocode
  end

  def test_logical_operators
    protocode = represent(<<~JAVA)
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
      function(
        name: "HelloWorld.main",
        parameter_count: 0,
        instructions: [
          new_object("Foo", temporary(0)),
          copy(42, temporary(1)),
          parameter(temporary(0)),
          parameter(temporary(1)),
          call("Foo.bar", 2, temporary(2)),
          parameter(temporary(2)),
          call("System.out.println", 1, nil)
        ]
      ),

      function(
        name: "Foo.bar",
        parameter_count: 2,
        instructions: [
          parameter(this),
          parameter(temporary(1)),
          call("Foo.glorp", 2, temporary(2)),
          jump_unless(temporary(2), ".if.0.else"),
          copy(temporary(1), variable("result")),
          jump(".if.0.end"),
          label(".if.0.else"),
          copy(0, temporary(3)),
          copy(temporary(3), variable("result")),
          label(".if.0.end"),
          return_with(variable("result"))
        ]
      ),

      function(
        name: "Foo.glorp",
        parameter_count: 2,
        instructions: [
          copy(1, temporary(2)),
          less_than(temporary(1), temporary(2), temporary(3)),
          not_of(temporary(3), temporary(4)),
          copy(100, temporary(5)),
          less_than(temporary(1), temporary(5), temporary(6)),
          and_of(temporary(4), temporary(6), temporary(7)),
          return_with(temporary(7))
        ]
      )
    ], protocode
  end

  def test_arithmetic_operators
    protocode = represent(<<~JAVA)
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
      function(
        name: "HelloWorld.main",
        parameter_count: 0,
        instructions: [
          new_object("Foo", temporary(0)),
          copy(42, temporary(1)),
          parameter(temporary(0)),
          parameter(temporary(1)),
          call("Foo.bar", 2, temporary(2)),
          parameter(temporary(2)),
          call("System.out.println", 1, nil)
        ]
      ),

      function(
        name: "Foo.bar",
        parameter_count: 2,
        instructions: [
          copy(4, temporary(2)),
          copy(temporary(2), variable("glorp")),
          copy(7, temporary(3)),
          multiply(temporary(1), temporary(3), temporary(4)),
          subtract(temporary(1), variable("glorp"), temporary(5)),
          add(temporary(4), temporary(5), temporary(6)),
          return_with(temporary(6))
        ]
      )
    ], protocode
  end

  def test_array_length
    protocode = represent(<<~JAVA)
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
      function(
        name: "HelloWorld.main",
        parameter_count: 0,
        instructions: [
          new_object("Foo", temporary(0)),
          parameter(temporary(0)),
          call("Foo.bar", 1, temporary(1)),
          parameter(temporary(1)),
          call("System.out.println", 1, nil)
        ]
      ),

      function(
        name: "Foo.bar",
        parameter_count: 1,
        instructions: [
          new_array(integer, 3, temporary(1)),
          copy(temporary(1), variable("numbers")),
          length_of(variable("numbers"), temporary(2)),
          return_with(temporary(2))
        ]
      )
    ], protocode
  end

  def test_this
    protocode = represent(<<~JAVA)
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
      function(
        name: "HelloWorld.main",
        parameter_count: 0,
        instructions: [
          new_object("Foo", temporary(0)),
          parameter(temporary(0)),
          call("Foo.bar", 1, temporary(1)),
          parameter(temporary(1)),
          call("System.out.println", 1, nil)
        ]
      ),

      function(
        name: "Foo.bar",
        parameter_count: 1,
        instructions: [
          parameter(this),
          call("Foo.baz", 1, temporary(1)),
          return_with(temporary(1))
        ]
      ),

      function(
        name: "Foo.baz",
        parameter_count: 1,
        instructions: [
          copy(42, temporary(1)),
          return_with(temporary(1))
        ]
      )
    ], protocode
  end

  def test_method_invocation_with_many_parameters
    protocode = represent(<<~JAVA)
      class HelloWorld {
        public static void main() {
          System.out.println(new Foo().bar(5, 4));
        }
      }

      class Foo {
        public int bar(int baz, int glorp) {
          return baz + glorp;
        }
      }
    JAVA

    assert_equal [
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
    ], protocode
  end

  private
    def represent(source)
      program = MiniJava::Parser.program_from(source)
      scope   = MiniJava::ScopeVisitor.scope_for(program)

      MiniJava::ProtocodeVisitor.protocode_for(program, scope)
    end
end
