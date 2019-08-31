require "minijava/visitor"

module MiniJava
  class TypeCheckVisitor < Visitor
    def self.check(program, scope)
      [].tap { |errors| new(scope, errors).visit(program) }
    end

    def initialize(scope, errors)
      @scope, @errors = scope, errors
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
      assert_type_of boolean, statement.condition
      visit statement.affirmative
      visit statement.negative
    end

    def visit_while_statement(statement)
      assert_type_of boolean, statement.condition
      visit statement.substatement
    end

    def visit_print_statement(statement)
      assert_type_of integer, statement.expression
    end

    def visit_variable_assignment(assignment)
      if type = variable_type_by_name(assignment.variable)
        assert_type_of type, assignment.value
      else
        flunk "Cannot find variable: #{assignment.variable}"
      end
    end

    def visit_array_element_assignment(assignment)
      if type = variable_type_by_name(assignment.array)
        assert_equal array, type, "Incompatible types: expected %<expected>s, got %<actual>s"
      else
        flunk "Cannot find variable: #{assignment.array}"
      end

      assert_type_of integer, assignment.index
      assert_type_of integer, assignment.value
    end


    def visit_not(operation)
      assert_type_of boolean, operation.expression
      boolean
    end

    def visit_and(operation)
      assert_type_of boolean, operation.left
      assert_type_of boolean, operation.right
      boolean
    end

    def visit_less_than(operation)
      assert_type_of integer, operation.left
      assert_type_of integer, operation.right
      boolean
    end

    def visit_binary_arithmetic_operation(operation)
      assert_type_of integer, operation.left
      assert_type_of integer, operation.right
      integer
    end

    alias_method :visit_plus,  :visit_binary_arithmetic_operation
    alias_method :visit_minus, :visit_binary_arithmetic_operation
    alias_method :visit_times, :visit_binary_arithmetic_operation

    def visit_variable_access(access)
      if type = variable_type_by_name(access.variable)
        type
      else
        flunk "Cannot find variable: #{access.variable}"
        unknown
      end
    end

    def visit_array_access(access)
      assert_type_of array, access.array
      assert_type_of integer, access.index
      integer
    end

    def visit_array_length(length)
      assert_type_of array, length.array
      integer
    end

    def visit_method_invocation(invocation)
      if declaration = method_declaration_for_invocation(invocation)
        assert_types_of declaration.parameters.collect(&:type), invocation.parameters,
          "Cannot find method #{invocation.name}(%<actual>s) - found #{invocation.name}(%<expected>s)"

        declaration.type
      else
        unknown
      end
    end

    def visit_new_array(expression)
      array
    end

    def visit_new_object(expression)
      if scope.class?(expression.class_name)
        object expression.class_name
      else
        flunk "Cannot find class: #{expression.class_name}"
        unknown
      end
    end

    def visit_integer_literal(literal)
      integer
    end

    def visit_true_literal(literal)
      boolean
    end

    def visit_false_literal(literal)
      boolean
    end

    def visit_this(this)
      if context.static?
        flunk "non-static variable this cannot be referenced from a static context"
        unknown
      else
        object scope.parent.context.name
      end
    end

    private
      attr_reader :scope, :errors
      delegate :class_scope_by_name, :method_scope_by_name, :variable_type_by_name, :context, to: :scope

      def within(subscope)
        superscope, @scope = @scope, subscope
        yield
      ensure
        @scope = superscope
      end


      def method_declaration_for_invocation(invocation)
        if (type = visit(invocation.receiver)).known?
          if type.dereferenceable?
            class_scope_by_name(type.class_name).method_declaration_by_name(invocation.name) ||
              flunk("Cannot find method #{type}.#{invocation.name}")
          else
            flunk "#{type} cannot be dereferenced"
          end
        end
      end


      def boolean
        MiniJava::Syntax::BooleanType.instance
      end

      def integer
        MiniJava::Syntax::IntegerType.instance
      end

      def array
        MiniJava::Syntax::ArrayType.instance
      end

      def object(class_name)
        MiniJava::Syntax::ObjectType.new(class_name)
      end

      def unknown
        MiniJava::Syntax::UnknownType.instance
      end

      def assert_types_of(expected, visitables, message = "Incompatible types: expected %<expected>s; got %<actual>s")
        if (actual = visit_all(visitables)).all?(&:known?)
          assert_equal expected, actual, sprintf(message, expected: expected.join(", "), actual: actual.join(", "))
        end
      end

      def assert_type_of(expected, visitable, message = "Incompatible types: expected %<expected>s, got %<actual>s")
        if (actual = visit(visitable)).known?
          assert_equal expected, actual, message
        end
      end

      def assert_equal(expected, actual, message = "Expected %<expected>s, got %<actual>s")
        assert actual == expected, sprintf(message, expected: expected, actual: actual)
      end

      def assert(test, message)
        flunk message unless test
      end

      def flunk(message)
        errors.append(message)
        nil
      end
  end
end
