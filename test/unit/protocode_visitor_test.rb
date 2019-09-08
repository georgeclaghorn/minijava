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
      function("HelloWorld.main", [
        new_object("Foo", temporary(0)),
        parameter(temporary(0)),
        call("Foo.bar", 1, temporary(1)),
        parameter(temporary(1)),
        call("System.out.println", 1, nil)
      ]),

      function("Foo.bar", [
        copy(42, temporary(0)),
        copy(temporary(0), variable("number")),
        return_with(variable("number"))
      ])
    ], protocode
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
      function(
        "HelloWorld.main",
        [
          new_object("Foo", temporary(0)),
          parameter(temporary(0)),
          call("Foo.bar", 1, temporary(1)),
          parameter(temporary(1)),
          call("System.out.println", 1, nil)
        ]
      ),

      function(
        "Foo.bar",
        [
          new_array(integer, 3, temporary(0)),
          copy(temporary(0), variable("numbers")),
          copy(42, temporary(1)),
          copy_into(temporary(1), variable("numbers"), 1),
          index_into(variable("numbers"), 1, temporary(2)),
          return_with(temporary(2))
        ]
      )
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
      function(
        "HelloWorld.main",
        [
          new_object("Foo", temporary(0)),
          parameter(temporary(0)),
          call("Foo.bar", 1, temporary(1)),
          parameter(temporary(1)),
          call("System.out.println", 1, nil)
        ]
      ),

      function(
        "Foo.bar",
        [
          copy(true, temporary(0)),
          jump_unless(temporary(0), ".if.0.else"),
          copy(1, temporary(1)),
          copy(temporary(1), variable("number")),
          jump(".if.0.end"),
          label(".if.0.else"),
          copy(2, temporary(2)),
          copy(temporary(2), variable("number")),
          label(".if.0.end"),
          return_with(variable("number"))
        ]
      )
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
      function(
        "HelloWorld.main",
        [
          new_object("Foo", temporary(0)),
          parameter(temporary(0)),
          call("Foo.bar", 1, temporary(1)),
          parameter(temporary(1)),
          call("System.out.println", 1, nil)
        ]
      ),

      function(
        "Foo.bar",
        [
          copy(true, temporary(0)),
          jump_unless(temporary(0), ".if.0.else"),
          copy(true, temporary(1)),
          jump_unless(temporary(1), ".if.1.else"),
          copy(1, temporary(2)),
          copy(temporary(2), variable("number")),
          jump(".if.1.end"),
          label(".if.1.else"),
          copy(2, temporary(3)),
          copy(temporary(3), variable("number")),
          label(".if.1.end"),
          jump(".if.0.end"),
          label(".if.0.else"),
          copy(3, temporary(4)),
          copy(temporary(4), variable("number")),
          label(".if.0.end"),
          return_with(variable("number"))
        ]
      )
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
      function(
        "HelloWorld.main",
        [
          new_object("Foo", temporary(0)),
          parameter(temporary(0)),
          call("Foo.bar", 1, temporary(1)),
          parameter(temporary(1)),
          call("System.out.println", 1, nil)
        ]
      ),

      function(
        "Foo.bar",
        [
          label(".while.0.begin"),
          copy(true, temporary(0)),
          jump_unless(temporary(0), ".while.0.end"),
          copy(1, temporary(1)),
          copy(temporary(1), variable("number")),
          jump(".while.0.begin"),
          label(".while.0.end"),
          return_with(variable("number"))
        ]
      )
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
      function(
        "HelloWorld.main",
        [
          new_object("Foo", temporary(0)),
          parameter(temporary(0)),
          call("Foo.bar", 1, temporary(1)),
          parameter(temporary(1)),
          call("System.out.println", 1, nil)
        ]
      ),

      function(
        "Foo.bar",
        [
          label(".while.0.begin"),
          copy(true, temporary(0)),
          jump_unless(temporary(0), ".while.0.end"),
          label(".while.1.begin"),
          copy(true, temporary(1)),
          jump_unless(temporary(1), ".while.1.end"),
          copy(2, temporary(2)),
          copy(temporary(2), variable("number")),
          jump(".while.1.begin"),
          label(".while.1.end"),
          jump(".while.0.begin"),
          label(".while.0.end"),
          return_with(variable("number"))
        ]
      )
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
      function(
        "HelloWorld.main",
        [
          new_object("Foo", temporary(0)),
          copy(42, temporary(1)),
          parameter(temporary(1)),
          parameter(temporary(0)),
          call("Foo.bar", 2, temporary(2)),
          parameter(temporary(2)),
          call("System.out.println", 1, nil)
        ]
      ),

      function(
        "Foo.bar",
        [
          parameter(variable("baz")),
          parameter(this),
          call("Foo.glorp", 2, temporary(0)),
          jump_unless(temporary(0), ".if.0.else"),
          copy(variable("baz"), variable("result")),
          jump(".if.0.end"),
          label(".if.0.else"),
          copy(0, temporary(1)),
          copy(temporary(1), variable("result")),
          label(".if.0.end"),
          return_with(variable("result"))
        ]
      ),

      function(
        "Foo.glorp",
        [
          copy(1, temporary(0)),
          less_than(variable("baz"), temporary(0), temporary(1)),
          not_of(temporary(1), temporary(2)),
          copy(100, temporary(3)),
          less_than(variable("baz"), temporary(3), temporary(4)),
          and_of(temporary(2), temporary(4), temporary(5)),
          return_with(temporary(5))
        ]
      )
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
      function(
        "HelloWorld.main",
        [
          new_object("Foo", temporary(0)),
          copy(42, temporary(1)),
          parameter(temporary(1)),
          parameter(temporary(0)),
          call("Foo.bar", 2, temporary(2)),
          parameter(temporary(2)),
          call("System.out.println", 1, nil)
        ]
      ),

      function(
        "Foo.bar",
        [
          copy(4, temporary(0)),
          copy(temporary(0), variable("glorp")),
          copy(7, temporary(1)),
          multiply(variable("baz"), temporary(1), temporary(2)),
          subtract(variable("baz"), variable("glorp"), temporary(3)),
          add(temporary(2), temporary(3), temporary(4)),
          return_with(temporary(4))
        ]
      )
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
      function(
        "HelloWorld.main",
        [
          new_object("Foo", temporary(0)),
          parameter(temporary(0)),
          call("Foo.bar", 1, temporary(1)),
          parameter(temporary(1)),
          call("System.out.println", 1, nil)
        ]
      ),

      function(
        "Foo.bar",
        [
          new_array(integer, 3, temporary(0)),
          copy(temporary(0), variable("numbers")),
          length_of(variable("numbers"), temporary(1)),
          return_with(temporary(1))
        ]
      )
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
      function(
        "HelloWorld.main",
        [
          new_object("Foo", temporary(0)),
          parameter(temporary(0)),
          call("Foo.bar", 1, temporary(1)),
          parameter(temporary(1)),
          call("System.out.println", 1, nil)
        ]
      ),

      function(
        "Foo.bar",
        [
          parameter(this),
          call("Foo.baz", 1, temporary(0)),
          return_with(temporary(0))
        ]
      ),

      function(
        "Foo.baz",
        [
          copy(42, temporary(0)),
          return_with(temporary(0))
        ]
      )
    ], instructions
  end

  private
    def represent(source)
      program = MiniJava::Parser.program_from(source)
      scope   = MiniJava::ScopeVisitor.scope_for(program)

      MiniJava::ProtocodeVisitor.protocode_for(program, scope)
    end
end
