require "test_helper"
require "active_support/core_ext/array/access"

class MiniJava::ParserTest < Minitest::Test
  def test_detecting_invalid_statement_syntax
    program = nil

    output = capture $stderr do
      program = parse <<~PROGRAM
        class Foo {
          public static void main(String[] args) {
            System.out.println(int);
          }
        }

        class Bar { }
      PROGRAM
    end

    assert_equal "Parse error on line 3", output.strip
    assert_equal "Bar", program.class_declarations.first.name.to_s
    assert_kind_of MiniJava::Syntax::InvalidStatement, program.main_class_declaration.method_declaration.statement
  end

  def test_detecting_invalid_variable_declaration_syntax_in_class_body
    program = nil

    output = capture $stderr do
      program = parse <<~PROGRAM
        class Foo {
          public static void main(String[] args) {
            System.out.println(new Bar().getBaz());
          }
        }

        class Bar {
          baz int;

          public int getBaz() {
            return baz;
          }
        }

        class Quux { }
      PROGRAM
    end

    assert_equal "Parse error on line 8", output.strip

    assert_equal "Bar", program.class_declarations.first.name.to_s
    assert_kind_of MiniJava::Syntax::InvalidVariableDeclaration, program.class_declarations.first.variable_declarations.first

    assert_equal "Quux", program.class_declarations.second.name.to_s
  end

  def test_detecting_invalid_variable_declaration_syntax_in_method_body
    program = nil

    output = capture $stderr do
      program = parse <<~PROGRAM
        class Foo {
          public static void main(String[] args) {
            System.out.println(new Bar().getGlorp());
          }
        }

        class Bar {
          int baz;

          public int getGlorp() {
            // Unsupported assignment in declaration:
            int glorp = 0;
            glorp = baz + 1;
            return glorp;
          }
        }
      PROGRAM
    end

    assert_equal "Parse error on line 12", output.strip

    class_declaration = program.class_declarations.first
    method_declaration = class_declaration.method_declarations.first
    assert_kind_of MiniJava::Syntax::InvalidVariableDeclaration, method_declaration.variable_declarations.first
    assert_kind_of MiniJava::Syntax::Assignment, method_declaration.statements.first
  end

  def test_detecting_invalid_method_body_syntax
    program = nil

    output = capture $stderr do
      program = parse <<~PROGRAM
        class Foo {
          public static void main(String[] args) {
            System.out.println(new Bar().getBaz(5));
          }
        }

        class Bar {
          public int getBaz(int glorp) {
            return glorp + 1;
            quux
          }

          public int getFloogle() { return 1; }
        }
      PROGRAM
    end

    assert_equal "Parse error on line 10", output.strip

    class_declaration = program.class_declarations.first
    assert_kind_of MiniJava::Syntax::InvalidMethodDeclaration, class_declaration.method_declarations.first
    assert_equal "getFloogle", class_declaration.method_declarations.second.name.to_s
  end

  def test_detecting_invalid_class_body_syntax
    program = nil

    output = capture $stderr do
      program = parse <<~PROGRAM
        class Foo {
          public static void main(String[] args) {
            System.out.println(new Bar().getBaz(5));
          }
        }

        class Bar {
          public int getBaz(int glorp) {
            return glorp + 1;
          }

          quux
        }

        class Quux { }
      PROGRAM
    end

    assert_equal "Parse error on line 12", output.strip
    assert_kind_of MiniJava::Syntax::InvalidClassDeclaration, program.class_declarations.first
    assert_equal "Quux", program.class_declarations.second.name.to_s
  end

  def test_detecting_multiple_syntax_errors
    output = capture $stderr do
      parse <<~PROGRAM
        class Foo {
          public static void main(String[] args) {
            System.out.println(new Bar().getBaz(int));
          }
        }

        class Bar {
          quux int;

          public int getBaz(int glorp) {
            return glorp + 1;
            quux
          }
        }
      PROGRAM
    end

    assert_equal <<~OUTPUT, output
      Parse error on line 3
      Parse error on line 8
      Parse error on line 12
    OUTPUT
  end

  def test_detecting_invalid_syntax_after_single_line_comment
    output = capture $stderr do
      parse <<~PROGRAM
        class Foo {
          public static void main(String[] args) {
            // Oops!
            System.out.println(int);
          }
        }
      PROGRAM
    end

    assert_equal "Parse error on line 4", output.strip
  end

  def test_detecting_invalid_syntax_after_multiline_comment
    output = capture $stderr do
      parse <<~PROGRAM
        class Foo {
          public static void main(String[] args) {
            /*
             *
             *
             *
             */
            System.out.println(int);
          }
        }
      PROGRAM
    end

    assert_equal "Parse error on line 8", output.strip
  end

  def test_parsing_decimal_integer_literals
    program = parse <<~PROGRAM
      class Foo {
        public static void main(String[] args) {
          System.out.println(0 + 100 + 123 + 37);
        }
      }
    PROGRAM

    integer_literals = program.select(MiniJava::Syntax::IntegerLiteral)
    assert_equal 0, integer_literals.first.value
    assert_equal 100, integer_literals.second.value
    assert_equal 123, integer_literals.third.value
    assert_equal 37, integer_literals.fourth.value
  end

  def test_parsing_array_element_assignments
    program = parse <<~PROGRAM
      class Foo {
        public static void main(String[] args) {
          System.out.println(new NumberPicker().pick());
        }
      }

      class NumberPicker {
        int[] numbers;

        public int pick() {
          numbers = new int[1];
          numbers[0] = 1;
          return numbers[0];
        }
      }
    PROGRAM

    assignments = program.select(MiniJava::Syntax::Assignment)
    assert_equal 2, assignments.count

    assignment = assignments.second

    assert_kind_of MiniJava::Syntax::ArraySubscript, assignment.left
    assert_equal "numbers", assignment.left.array.name
    assert_equal 0, assignment.left.index.value

    assert_kind_of MiniJava::Syntax::IntegerLiteral, assignment.right
    assert_equal 1, assignment.right.value
  end

  def test_parsing_array_length
    program = parse <<~PROGRAM
      class Foo {
        public static void main(String[] args) {
          System.out.println(new NumberPicker().pick());
        }
      }

      class NumberPicker {
        int[] numbers;

        public int pick() {
          numbers = new int[1];
          numbers[0] = numbers.length;
          return numbers[0];
        }
      }
    PROGRAM

    lengths = program.select(MiniJava::Syntax::ArrayLength)
    assert lengths.one?
    assert_equal "numbers", lengths.first.array.name
  end

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

    def parse(source)
      MiniJava::Parser.program_from(source)
    end
end
