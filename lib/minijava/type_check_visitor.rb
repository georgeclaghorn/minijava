require "minijava/visitor"
require "minijava/errors"

module MiniJava
  class TypeCheckVisitor < Visitor
    def self.check(program, scope)
      new(scope).visit(program)
    end

    def initialize(scope)
      @scope = scope
    end

    def visit_program(program)
      visit program.main_class_declaration
      visit_all program.class_declarations
    end


    def visit_main_class_declaration(declaration)
      within class_scope_by(name: declaration.name) do
        visit declaration.method_declaration
      end
    end

    def visit_main_method_declaration(declaration)
      within method_scope_by(name: declaration.name) do
        visit declaration.statement
      end
    end


    def visit_class_declaration(declaration)
      within class_scope_by(name: declaration.name) do
        visit_all declaration.method_declarations
      end
    end

    def visit_subclass_declaration(declaration)
      within class_scope_by(name: declaration.name) do
        visit_all declaration.method_declarations
      end
    end

    def visit_method_declaration(declaration)
      within method_scope_by(name: declaration.name) do
        visit_all declaration.statements
        assert_type_of declaration.return_expression, declaration.type
      end
    end


    def visit_block(block)
      visit_all block.statements
    end

    def visit_if_statement(statement)
      assert_type_of statement.condition, "boolean"
      visit statement.affirmative
      visit statement.negative
    end

    def visit_while_statement(statement)
      assert_type_of statement.condition, "boolean"
      visit statement.substatement
    end

    def visit_print_statement(statement)
      assert_type_of statement.expression, "int", "Call to System.out.println does not match its signature"
    end

    def visit_simple_assignment(assignment)
      assert_type_of assignment.value, scope.variable_type_by!(name: assignment.variable_name)
    end

    def visit_array_element_assignment(assignment)
      assert_equal "int[]", scope.variable_type_by!(name: assignment.array),
        "Incompatible types: expected %<expected>s, got %<actual>s"

      assert_type_of assignment.index, "int"
      assert_type_of assignment.value, "int"
    end


    def visit_not(operation)
      assert_type_of operation.expression, "boolean"
      MiniJava::Syntax::BooleanType.instance
    end

    def visit_and(operation)
      assert_type_of operation.left, "boolean"
      assert_type_of operation.right, "boolean"
      MiniJava::Syntax::BooleanType.instance
    end

    def visit_binary_arithmetic_operation(operation)
      assert_type_of operation.left, "int"
      assert_type_of operation.right, "int"
      MiniJava::Syntax::IntegerType.instance
    end

    alias_method :visit_less_than, :visit_binary_arithmetic_operation
    alias_method :visit_plus,      :visit_binary_arithmetic_operation
    alias_method :visit_minus,     :visit_binary_arithmetic_operation
    alias_method :visit_times,     :visit_binary_arithmetic_operation

    def visit_array_element_access(access)
      assert_type_of access.array, "int[]"
      assert_type_of access.index, "int"
      MiniJava::Syntax::IntegerType.instance
    end

    def visit_array_length(length)
      assert_type_of length.array, "int[]"
      MiniJava::Syntax::IntegerType.instance
    end

    def visit_call(call)
      if (receiver_type = visit(call.receiver)).callable?
        if receiver_scope = scope.class_scope_by(name: receiver_type.class_name)
          receiver_scope.method_type_by(name: call.method_name) ||
            raise(NameError, "Attempt to call undefined method #{call.method_name}")
        else
          raise TypeError, "Attempt to call non-method #{call.method_name}"
        end
      else
        raise TypeError, "Attempt to call non-method #{call.method_name}"
      end
    end

    def visit_access(access)
      scope.variable_type_by!(name: access.variable_name)
    end

    def visit_new_array(expression)
      MiniJava::Syntax::ArrayType.instance
    end

    def visit_new_object(expression)
      MiniJava::Syntax::ObjectType.new expression.class_name
    end

    def visit_integer_literal(literal)
      MiniJava::Syntax::IntegerType.instance
    end

    def visit_true_literal(literal)
      MiniJava::Syntax::BooleanType.instance
    end

    def visit_false_literal(literal)
      MiniJava::Syntax::BooleanType.instance
    end

    private
      attr_reader :scope
      delegate :class_scope_by, :method_scope_by, :variable_type_by!, to: :scope

      def within(subscope)
        superscope, @scope = @scope, subscope
        yield
      ensure
        @scope = superscope
      end

      def assert_type_of(visitable, expected, message = "Incompatible types: expected %<expected>s, got %<actual>s")
        assert_equal expected, visit(visitable), message
      end

      def assert_equal(expected, actual, message = "Expected %<expected>s, got %<actual>s")
        unless actual == expected || actual.to_s == expected.to_s
          raise TypeError, sprintf(message, expected: expected, actual: actual)
        end
      end
  end
end
