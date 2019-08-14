require "test_helper"

class MiniJava::Visitors::SelectorVisitorTest < MiniTest::Test
  def test_selecting_identifiers_in_depth_first_order
    program = MiniJava::Parser.program_from(<<~JAVA)
      class HelloWorld {
        public static void main(String[] args) {
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

    visitor = MiniJava::Visitors::SelectorVisitor.new(MiniJava::Syntax::Identifier)

    identifiers = visitor.visit(program)
    assert_equal 9, identifiers.count
    assert_equal %w[ HelloWorld args NumberPicker pick number ], identifiers.collect(&:name).uniq
  end
end
