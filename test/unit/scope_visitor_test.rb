require "test_helper"

class MiniJava::ScopeVisitorTest < MiniTest::Test
  def test_building_program_scope
    program = MiniJava::Parser.program_from(<<~JAVA)
      class HelloWorld {
        public static void main(String[] args) {
          System.out.println(new Incrementor().next());
        }
      }

      class Incrementor {
        int foo;

        public int next() {
          int number;
          foo = 1 + foo;
          number = foo;
          return number;
        }
      }
    JAVA

    program_scope = MiniJava::ScopeVisitor.scope_for(program)
    assert program_scope.class?("HelloWorld")
    assert program_scope.class?("Incrementor")

    class_scope = program_scope.class_scope_for("HelloWorld")
    assert class_scope.methods.include?("main")
    assert_equal MiniJava::Syntax::VoidType.instance, class_scope.method_type_for("main")

    method_scope = class_scope.method_scope_for("main")
    assert method_scope.variables.include?("args")
    assert_equal MiniJava::Syntax::ArrayType.instance, method_scope.variable_type_for("args")

    class_scope = program_scope.class_scope_for("Incrementor")
    assert class_scope.variable?("foo")
    assert_equal MiniJava::Syntax::IntegerType.instance, class_scope.variable_type_for("foo")

    assert class_scope.method?("next")
    assert_equal MiniJava::Syntax::IntegerType.instance, class_scope.method_type_for("next")

    method_scope = class_scope.method_scope_for("next")
    assert method_scope.variable?("foo")
    assert_equal MiniJava::Syntax::IntegerType.instance, method_scope.variable_type_for("foo")

    assert method_scope.variable?("number")
    assert_equal MiniJava::Syntax::IntegerType.instance, method_scope.variable_type_for("number")
  end
end
