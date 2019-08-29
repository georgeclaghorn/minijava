require "test_helper"

class MiniJava::SelectorVisitorTest < MiniTest::Test
  def test_selecting_identifiers_in_depth_first_order
    program = MiniJava::Parser.program_from(<<~JAVA)
      class HelloWorld {
        public static void main() {
          System.out.println(new NumberPicker().pick());
        }
      }

      class NumberPicker {
        public int pick() {
          int number;
          number = 1;
          return number;
        }
      }
    JAVA

    identifiers = MiniJava::SelectorVisitor.select(MiniJava::Syntax::Identifier, program)
    assert_equal 8, identifiers.count
    assert_equal %w[ HelloWorld NumberPicker pick number ], identifiers.collect(&:name).uniq
  end

  def test_selecting_errors
    program = nil

    capture $stderr do
      program = MiniJava::Parser.program_from(<<~JAVA)
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

    errors = MiniJava::SelectorVisitor.select(MiniJava::Syntax::InvalidVariableDeclaration, program)
    assert_equal 1, errors.count
  end
end
