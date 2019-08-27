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
        visit declaration.return_expression
      end
    end


    def visit_block(block)
      visit_all block.statements
    end

    def visit_if_statement(statement)
      visit statement.condition
      visit statement.affirmative
      visit statement.negative
    end

    def visit_while_statement(statement)
      visit statement.condition
      visit statement.substatement
    end

    def visit_print_statement(statement)
      assert_type_of statement.expression, "int", "Call to System.out.println does not match its signature"
    end

    def visit_simple_assignment(assignment)
      left_type  = visit(assignment.left)
      right_type = visit(assignment.right)

      if left_type == :class || left_type == :method
        raise TypeError, "Invalid l-value: #{assignment.left} is a #{left_type}"
      end

      if right_type == :class || right_type == :method
        raise TypeError, "Invalid r-value: #{assignment.right} is a #{right_type}"
      end
    end

    def visit_array_element_assignment(assignment)
      right_type = visit(assignment.right)

      if right_type == :class || right_type == :method
        raise TypeError, "Invalid r-value: #{assignment.right} is a #{right_type}"
      end
    end


    def visit_not(operation)
      assert_type_of operation.expression, "boolean", "Invalid operand: expected boolean, got %<actual>s"
      MiniJava::Syntax::BooleanType.instance
    end

    def visit_and(operation)
      assert_type_of operation.left, "boolean", "Invalid operand: expected boolean, got %<actual>s"
      assert_type_of operation.right, "boolean", "Invalid operand: expected boolean, got %<actual>s"
      MiniJava::Syntax::BooleanType.instance
    end

    def visit_binary_arithmetic_operation(operation)
      assert_type_of operation.left, "int", "Invalid operand: expected int, got %<actual>s"
      assert_type_of operation.right, "int", "Invalid operand: expected int, got %<actual>s"
      MiniJava::Syntax::IntegerType.instance
    end

    alias_method :visit_less_than, :visit_binary_arithmetic_operation
    alias_method :visit_plus,      :visit_binary_arithmetic_operation
    alias_method :visit_minus,     :visit_binary_arithmetic_operation
    alias_method :visit_times,     :visit_binary_arithmetic_operation

    def visit_array_subscript(subscript)
      assert_type_of subscript.array, "int[]"
      assert_type_of subscript.index, "int", "Expected integer index into array, got %<actual>s"
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


    def visit_identifier(identifier)
      scope.reference_type_by(name: identifier.name)
    end

    private
      attr_reader :scope
      delegate :class_scope_by, :method_scope_by, to: :scope

      def within(subscope)
        superscope, @scope = @scope, subscope
        yield
      ensure
        @scope = superscope
      end

      def assert_type_of(visitable, expected, message = "Expected %<expected>s, got %<actual>s")
        visit(visitable).then do |actual|
          unless actual == expected || actual.to_s == expected
            raise TypeError, sprintf(message, expected: expected, actual: actual)
          end
        end
      end
  end
end
