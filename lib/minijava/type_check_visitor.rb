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
      within class_scope_by_name(declaration.name) do
        visit declaration.method_declaration
      end
    end

    def visit_main_method_declaration(declaration)
      within method_scope_by_name(declaration.name) do
        visit declaration.statement
      end
    end


    def visit_class_declaration(declaration)
      within class_scope_by_name(declaration.name) do
        visit_all declaration.method_declarations
      end
    end

    def visit_subclass_declaration(declaration)
      within method_scope_by_name(declaration.name) do
        visit_all declaration.method_declarations
      end
    end

    def visit_method_declaration(declaration)
      within method_scope_by_name(declaration.name) do
        visit_all declaration.statements
        assert_type_of declaration.type, declaration.return_expression
      end
    end


    def visit_block(block)
      visit_all block.statements
    end

    def visit_if_statement(statement)
      assert_type_of "boolean", statement.condition
      visit statement.affirmative
      visit statement.negative
    end

    def visit_while_statement(statement)
      assert_type_of "boolean", statement.condition
      visit statement.substatement
    end

    def visit_print_statement(statement)
      assert_type_of "int", statement.expression
    end

    def visit_variable_assignment(assignment)
      assert_type_of scope.variable_type_by_name!(assignment.variable), assignment.value
    end

    def visit_array_element_assignment(assignment)
      assert_equal "int[]", scope.variable_type_by_name!(assignment.array),
        "Incompatible types: expected %<expected>s, got %<actual>s"

      assert_type_of "int", assignment.index
      assert_type_of "int", assignment.value
    end


    def visit_not(operation)
      assert_type_of "boolean", operation.expression
      MiniJava::Syntax::BooleanType.instance
    end

    def visit_and(operation)
      assert_type_of "boolean", operation.left
      assert_type_of "boolean", operation.right
      MiniJava::Syntax::BooleanType.instance
    end

    def visit_binary_arithmetic_operation(operation)
      assert_type_of "int", operation.left
      assert_type_of "int", operation.right
      MiniJava::Syntax::IntegerType.instance
    end

    alias_method :visit_less_than, :visit_binary_arithmetic_operation
    alias_method :visit_plus,      :visit_binary_arithmetic_operation
    alias_method :visit_minus,     :visit_binary_arithmetic_operation
    alias_method :visit_times,     :visit_binary_arithmetic_operation

    def visit_array_access(access)
      assert_type_of "int[]", access.array
      assert_type_of "int", access.index
      MiniJava::Syntax::IntegerType.instance
    end

    def visit_array_length(length)
      assert_type_of "int[]", length.array
      MiniJava::Syntax::IntegerType.instance
    end

    def visit_method_invocation(invocation)
      if (receiver_type = visit(invocation.receiver)).dereferenceable?
        if receiver_scope = scope.class_scope_by_name(receiver_type.class_name)
          receiver_scope.method_type_by_name(invocation.name) ||
            raise(NameError, "Cannot find method #{receiver_type}.#{invocation.name}()")
        else
          raise TypeError, "Cannot find method #{receiver_type}.#{invocation.name}()"
        end
      else
        raise TypeError, "#{receiver_type} cannot be dereferenced"
      end
    end

    def visit_variable_access(access)
      scope.variable_type_by_name!(access.variable)
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
      delegate :class_scope_by_name, :method_scope_by_name, to: :scope

      def within(subscope)
        superscope, @scope = @scope, subscope
        yield
      ensure
        @scope = superscope
      end


      def assert_type_of(expected, visitable, message = "Incompatible types: expected %<expected>s, got %<actual>s")
        assert_equal expected, visit(visitable), message
      end

      def assert_equal(expected, actual, message = "Expected %<expected>s, got %<actual>s")
        unless actual == expected || actual.to_s == expected.to_s
          raise TypeError, sprintf(message, expected: expected, actual: actual)
        end
      end
  end
end
