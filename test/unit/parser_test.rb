require "test_helper"
require "active_support/core_ext/array/access"

class MiniJava::ParserTest < Minitest::Test
  def test_parsing_decimal_integer_literals
    program = parse <<~JAVA
      class Foo {
        public static void main() {
          System.out.println(0 + 100 + 123 + 37);
        }
      }
    JAVA

    integer_literals = program.select(MiniJava::Syntax::IntegerLiteral)
    assert_equal 0, integer_literals.first.value
    assert_equal 100, integer_literals.second.value
    assert_equal 123, integer_literals.third.value
    assert_equal 37, integer_literals.fourth.value
  end

  def test_parsing_array_element_assignments
    program = parse <<~JAVA
      class Foo {
        public static void main() {
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
    JAVA

    assignments =
      program.select(MiniJava::Syntax::SimpleAssignment) + program.select(MiniJava::Syntax::ArrayElementAssignment)
    assert_equal 2, assignments.count

    assignment = assignments.second

    assert_kind_of MiniJava::Syntax::ArraySubscript, assignment.left
    assert_equal "numbers", assignment.left.array.variable_name.to_s
    assert_equal 0, assignment.left.index.value

    assert_kind_of MiniJava::Syntax::IntegerLiteral, assignment.right
    assert_equal 1, assignment.right.value
  end

  def test_parsing_array_length
    program = parse <<~JAVA
      class Foo {
        public static void main() {
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
    JAVA

    lengths = program.select(MiniJava::Syntax::ArrayLength)
    assert lengths.one?
    assert_equal "numbers", lengths.first.array.variable_name.to_s
  end

  def test_parsing_parameter_lists
    program = parse <<~JAVA
      class Foo {
        public static void main() {
          System.out.println(new Bar().baz(20, false));
        }
      }

      class Bar {
        public boolean baz(int glorp, boolean quux) {
          return quux && (glorp < 30);
        }
      }
    JAVA

    call = program.select(MiniJava::Syntax::Call).first
    assert_equal 2, call.parameters.count
    assert_equal 20, call.parameters.first.value
    assert_equal MiniJava::Syntax::FalseLiteral.instance, call.parameters.second

    method_declaration = program.select(MiniJava::Syntax::MethodDeclaration).first
    assert_equal 2, method_declaration.parameters.count

    parameter = method_declaration.parameters.first
    assert_equal MiniJava::Syntax::IntegerType.instance, parameter.type
    assert_equal "glorp", parameter.name.to_s

    parameter = method_declaration.parameters.second
    assert_equal MiniJava::Syntax::BooleanType.instance, parameter.type
    assert_equal "quux", parameter.name.to_s
  end

  def test_parsing_conditionals
    program = parse <<~JAVA
      class Foo {
        public static void main() {
          System.out.println(new Bar().baz(20, 30));
        }
      }

      class Bar {
        // Returns true if glorp is less than quux and false otherwise.
        public boolean baz(int glorp, int quux) {
          boolean result;

          if (glorp < quux) {
            result = true;
          } else {
            result = false;
          }

          return result;
        }
      }
    JAVA

    conditional = program.select(MiniJava::Syntax::IfStatement).first
    assert_kind_of MiniJava::Syntax::LessThan, conditional.condition
    assert_equal "glorp", conditional.condition.left.variable_name.to_s
    assert_equal "quux", conditional.condition.right.variable_name.to_s
    assert_kind_of MiniJava::Syntax::Block, conditional.affirmative
    assert_kind_of MiniJava::Syntax::Block, conditional.negative

    block = conditional.affirmative
    assert block.statements.one?
    assert_kind_of MiniJava::Syntax::SimpleAssignment, block.statements.first

    assignment = block.statements.first
    assert_equal "result", assignment.left.name
    assert_equal MiniJava::Syntax::TrueLiteral.instance, assignment.right

    block = conditional.negative
    assert block.statements.one?
    assert_kind_of MiniJava::Syntax::SimpleAssignment, block.statements.first

    assignment = block.statements.first
    assert_equal "result", assignment.left.name
    assert_equal MiniJava::Syntax::FalseLiteral.instance, assignment.right
  end

  def test_parsing_while_loops
    program = parse <<~JAVA
      class Foo {
        public static void main() {
          System.out.println(new NumberPicker().pick());
        }
      }

      class NumberPicker {
        int number;

        public int pick() {
          number = 0;

          while (number < 3) {
            number = 1 + number;
          }

          return number;
        }
      }
    JAVA

    loop = program.select(MiniJava::Syntax::WhileStatement).first
    assert_kind_of MiniJava::Syntax::LessThan, loop.condition
    assert_equal "number", loop.condition.left.variable_name.to_s
    assert_equal 3, loop.condition.right.value
    assert_kind_of MiniJava::Syntax::Block, loop.substatement

    block = loop.substatement
    assert block.statements.one?
    assert_kind_of MiniJava::Syntax::SimpleAssignment, block.statements.first

    assignment = block.statements.first
    assert_equal "number", assignment.left.name
    assert_kind_of MiniJava::Syntax::Plus, assignment.right

    plus = assignment.right
    assert_equal 1, plus.left.value
    assert_equal "number", plus.right.variable_name.to_s
  end

  def test_detecting_invalid_statement_syntax
    program = nil

    output = capture $stderr do
      program = parse <<~JAVA
        class Foo {
          public static void main() {
            System.out.println(int);
          }
        }

        class Bar { }
      JAVA
    end

    assert_equal "Parse error at line 3, column 24", output.strip
    assert_equal "Bar", program.class_declarations.first.name.to_s
    assert_kind_of MiniJava::Syntax::InvalidStatement, program.main_class_declaration.method_declaration.statement
  end

  def test_detecting_invalid_variable_declaration_syntax_in_class_body
    program = nil

    output = capture $stderr do
      program = parse <<~JAVA
        class Foo {
          public static void main() {
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
      JAVA
    end

    assert_equal "Parse error at line 8, column 7", output.strip

    class_declaration = program.class_declarations.first
    assert_equal "Bar", class_declaration.name.to_s
    assert_kind_of MiniJava::Syntax::InvalidVariableDeclaration, class_declaration.variable_declarations.first

    assert_equal "Quux", program.class_declarations.second.name.to_s
  end

  def test_detecting_invalid_variable_declaration_syntax_in_method_body
    program = nil

    output = capture $stderr do
      program = parse <<~JAVA
        class Foo {
          public static void main() {
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
      JAVA
    end

    assert_equal "Parse error at line 12, column 15", output.strip

    class_declaration = program.class_declarations.first
    method_declaration = class_declaration.method_declarations.first
    assert_kind_of MiniJava::Syntax::InvalidVariableDeclaration, method_declaration.variable_declarations.first
    assert_kind_of MiniJava::Syntax::SimpleAssignment, method_declaration.statements.first
  end

  def test_detecting_invalid_method_body_syntax
    program = nil

    output = capture $stderr do
      program = parse <<~JAVA
        class Foo {
          public static void main() {
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
      JAVA
    end

    assert_equal "Parse error at line 10, column 5", output.strip

    class_declaration = program.class_declarations.first
    assert_kind_of MiniJava::Syntax::InvalidMethodDeclaration, class_declaration.method_declarations.first
    assert_equal "getFloogle", class_declaration.method_declarations.second.name.to_s
  end

  def test_detecting_invalid_class_body_syntax
    program = nil

    output = capture $stderr do
      program = parse <<~JAVA
        class Foo {
          public static void main() {
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
      JAVA
    end

    assert_equal "Parse error at line 12, column 3", output.strip
    assert_kind_of MiniJava::Syntax::InvalidClassDeclaration, program.class_declarations.first
    assert_equal "Quux", program.class_declarations.second.name.to_s
  end

  def test_detecting_multiple_syntax_errors
    output = capture $stderr do
      parse <<~JAVA
        class Foo {
          public static void main() {
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
      JAVA
    end

    assert_equal <<~OUTPUT, output
      Parse error at line 3, column 41
      Parse error at line 8, column 8
      Parse error at line 12, column 5
    OUTPUT
  end

  def test_detecting_invalid_syntax_after_single_line_comment
    output = capture $stderr do
      parse <<~JAVA
        class Foo {
          public static void main() {
            // Oops!
            System.out.println(int);
          }
        }
      JAVA
    end

    assert_equal "Parse error at line 4, column 24", output.strip
  end

  def test_detecting_invalid_syntax_after_multiline_comment
    output = capture $stderr do
      parse <<~JAVA
        class Foo {
          public static void main() {
            /*
             *
             *
             *
             */
            System.out.println(int);
          }
        }
      JAVA
    end

    assert_equal "Parse error at line 8, column 24", output.strip
  end

  private
    def parse(source)
      MiniJava::Parser.program_from(source)
    end
end
