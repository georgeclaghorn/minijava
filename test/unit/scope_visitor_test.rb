require "test_helper"

class MiniJava::ScopeVisitorTest < MiniTest::Test
  def test_building_program_scope
    program = MiniJava::Parser.program_from(<<~JAVA)
      class HelloWorld {
        public static void main() {
          System.out.println(new Incrementor().next(true));
        }
      }

      class Incrementor {
        int foo;

        public int next(boolean bar) {
          int number;
          foo = 1 + foo;
          number = foo;
          return number;
        }
      }

      class Decrementor extends Incrementor {
        public int next(boolean bar) {
          foo = foo - 1;
          return foo;
        }
      }
    JAVA

    program_scope = MiniJava::ScopeVisitor.scope_for(program)
    assert program_scope.class?("HelloWorld")
    assert program_scope.class?("Incrementor")


    class_scope = program_scope.class_scope_by(name: "HelloWorld")
    assert class_scope.method?("main")
    assert_equal MiniJava::Syntax::VoidType.instance, class_scope.method_type_by(name: "main")


    class_scope = program_scope.class_scope_by(name: "Incrementor")

    assert class_scope.variable?("foo")
    assert_equal MiniJava::Syntax::IntegerType.instance, class_scope.variable_type_by(name: "foo")

    assert class_scope.method?("next")
    assert_equal MiniJava::Syntax::IntegerType.instance, class_scope.method_type_by(name: "next")

    method_scope = class_scope.method_scope_by(name: "next")

    assert method_scope.variable?("bar")
    assert_equal MiniJava::Syntax::BooleanType.instance, method_scope.variable_type_by(name: "bar")

    assert method_scope.variable?("foo")
    assert_equal MiniJava::Syntax::IntegerType.instance, method_scope.variable_type_by(name: "foo")

    assert method_scope.variable?("number")
    assert_equal MiniJava::Syntax::IntegerType.instance, method_scope.variable_type_by(name: "number")


    class_scope = program_scope.class_scope_by(name: "Decrementor")

    assert class_scope.variable?("foo")
    assert_equal MiniJava::Syntax::IntegerType.instance, class_scope.variable_type_by(name: "foo")

    assert class_scope.method?("next")
    assert_equal MiniJava::Syntax::IntegerType.instance, class_scope.method_type_by(name: "next")

    method_scope = class_scope.method_scope_by(name: "next")

    assert method_scope.variable?("foo")
    assert_equal MiniJava::Syntax::IntegerType.instance, method_scope.variable_type_by(name: "foo")

    assert !method_scope.variable?("number")
  end

  def test_forbidding_class_redefinition
    program = MiniJava::Parser.program_from(<<~JAVA)
      class HelloWorld {
        public static void main() {
          System.out.println(9);
        }
      }

      class HelloWorld { }
    JAVA

    error = assert_raises(MiniJava::NameError) { MiniJava::ScopeVisitor.scope_for(program) }
    assert_equal "Redefinition of class HelloWorld", error.message
  end

  def test_forbidding_variable_redefinition
    program = MiniJava::Parser.program_from(<<~JAVA)
      class HelloWorld {
        public static void main() {
          System.out.println(9);
        }
      }

      class Foo {
        int baz;
        int baz;
      }
    JAVA

    error = assert_raises(MiniJava::NameError) { MiniJava::ScopeVisitor.scope_for(program) }
    assert_equal "Redefinition of variable baz", error.message
  end

  def test_forbidding_method_redefinition
    program = MiniJava::Parser.program_from(<<~JAVA)
      class HelloWorld {
        public static void main() {
          System.out.println(new Foo().bar());
        }
      }

      class Foo {
        public int bar() {
          return 9;
        }

        public int bar() {
          return 10;
        }
      }
    JAVA

    error = assert_raises(MiniJava::NameError) { MiniJava::ScopeVisitor.scope_for(program) }
    assert_equal "Redefinition of method bar", error.message
  end

  def test_variable_shadowing
    program = MiniJava::Parser.program_from(<<~JAVA)
      class HelloWorld {
        public static void main() {
          System.out.println(new Foo().bar());
        }
      }

      class Foo {
        boolean baz;

        public int bar() {
          int baz;
          return 9;
        }
      }
    JAVA

    program_scope = MiniJava::ScopeVisitor.scope_for(program)
    class_scope   = program_scope.class_scope_by(name: "Foo")
    method_scope  = class_scope.method_scope_by(name: "bar")

    assert_equal MiniJava::Syntax::BooleanType.instance, class_scope.variable_type_by(name: "baz")
    assert_equal MiniJava::Syntax::IntegerType.instance, method_scope.variable_type_by(name: "baz")
  end

  def test_forbidding_inheritance_from_undefined_class
    program = MiniJava::Parser.program_from(<<~JAVA)
      class HelloWorld {
        public static void main() {
          System.out.println(new Foo().bar());
        }
      }

      class Foo extends Bar { }
    JAVA

    error = assert_raises(MiniJava::NameError) { MiniJava::ScopeVisitor.scope_for(program) }
    assert_equal "Class Foo extends undefined class Bar", error.message
  end

  def test_double_inheritance
    program = MiniJava::Parser.program_from(<<~JAVA)
      class HelloWorld {
        public static void main() {
          System.out.println(new Foo().bar());
        }
      }

      class Foo { }
      class Bar extends Foo { }
      class Baz extends Bar { }
    JAVA

    program_scope = MiniJava::ScopeVisitor.scope_for(program)

    assert program_scope.class?("Foo")
    assert program_scope.class?("Bar")
    assert program_scope.class?("Baz")

    foo_scope = program_scope.class_scope_by(name: "Foo")
    bar_scope = program_scope.class_scope_by(name: "Bar")
    baz_scope = program_scope.class_scope_by(name: "Baz")

    # Weird, albeit intentional, arrangement: Bar and Baz are declared in the program scope but
    # parented by their respective superclass' scopes, *not* the program scope.
    #
    # A scope's parent is not necessarily the lexical scope of its corresponding AST node.
    assert_equal foo_scope, bar_scope.parent
    assert_equal bar_scope, baz_scope.parent
  end
end
