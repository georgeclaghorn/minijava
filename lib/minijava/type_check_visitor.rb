require "minijava/visitor"
require "minijava/errors"

module MiniJava
  class TypeCheckVisitor < Visitor
    def self.check(program, scope)
      new(scope).visit(program)
    end

    def initialize(root_scope)
      @root_scope = root_scope
    end

    def visit_program(program)
      visit program.main_class_declaration
      visit_all program.class_declarations
    end


    def visit_main_class_declaration(declaration)
      visit declaration.method_declaration, @root_scope.class_scope_by(name: declaration.name)
    end

    def visit_main_method_declaration(declaration, scope = @root_scope)
      visit declaration.statement, scope.method_scope_by(name: declaration.name)
    end


    def visit_class_declaration(declaration)
      visit_all declaration.method_declarations, @root_scope.class_scope_by(name: declaration.name)
    end

    def visit_subclass_declaration(declaration)
      visit_all declaration.method_declarations, @root_scope.class_scope_by(name: declaration.name)
    end

    def visit_method_declaration(declaration, scope = @root_scope)
      scope = scope.method_scope_by(name: declaration.name)
      visit_all declaration.statements, scope
      visit declaration.return_expression, scope
    end


    def visit_block(block, scope = @root_scope)
      visit_all block.statements, scope
    end

    def visit_if_statement(statement, scope = @root_scope)
      visit statement.condition, scope
      visit statement.affirmative, scope
      visit statement.negative, scope
    end

    def visit_while_statement(statement, scope = @root_scope)
      visit statement.condition, scope
      visit statement.substatement, scope
    end

    def visit_print_statement(statement, scope = @root_scope)
      parameter_type = visit(statement.expression, scope)

      if parameter_type != MiniJava::Syntax::IntegerType.instance
        raise TypeError, "Call to System.out.println does not match its signature"
      end
    end

    def visit_simple_assignment(assignment, scope = @root_scope)
      left_type  = visit(assignment.left, scope)
      right_type = visit(assignment.right, scope)

      if left_type == :class || left_type == :method
        raise TypeError, "Invalid l-value: #{assignment.left} is a #{left_type}"
      end

      if right_type == :class || right_type == :method
        raise TypeError, "Invalid r-value: #{assignment.right} is a #{right_type}"
      end
    end

    def visit_array_element_assignment(assignment, scope = @root_scope)
      right_type = visit(assignment.right, scope)

      if right_type == :class || right_type == :method
        raise TypeError, "Invalid r-value: #{assignment.right} is a #{right_type}"
      end
    end


    def visit_not(operation, scope = @root_scope)
      visit(operation.expression, scope).tap do |type|
        if type != MiniJava::Syntax::BooleanType.instance
          raise TypeError, "Invalid operand: expected boolean, got #{type}"
        end
      end
    end

    def visit_and(operation, scope = @root_scope)
      left_type  = visit(operation.left, scope)
      right_type = visit(operation.right, scope)

      if left_type == :class || left_type == :method
        raise TypeError, "Invalid operand: #{operation.left} is a #{left_type}"
      end

      if right_type == :class || right_type == :method
        raise TypeError, "Invalid operand: #{operation.right} is a #{right_type}"
      end

      if left_type != MiniJava::Syntax::BooleanType.instance
        raise TypeError, "Invalid operand: expected boolean, got #{left_type}"
      end

      if right_type != MiniJava::Syntax::BooleanType.instance
        raise TypeError, "Invalid operand: expected boolean, got #{right_type}"
      end

      MiniJava::Syntax::BooleanType.instance
    end

    def visit_binary_arithmetic_operation(operation, scope = @root_scope)
      left_type  = visit(operation.left, scope)
      right_type = visit(operation.right, scope)

      if left_type == :class || left_type == :method
        raise TypeError, "Invalid operand: #{operation.left} is a #{left_type}"
      end

      if right_type == :class || right_type == :method
        raise TypeError, "Invalid operand: #{operation.right} is a #{right_type}"
      end

      if left_type != MiniJava::Syntax::IntegerType.instance
        raise TypeError, "Invalid operand: expected int, got #{left_type}"
      end

      if right_type != MiniJava::Syntax::IntegerType.instance
        raise TypeError, "Invalid operand: expected int, got #{right_type}"
      end

      MiniJava::Syntax::IntegerType.instance
    end

    alias_method :visit_less_than, :visit_binary_arithmetic_operation
    alias_method :visit_plus,      :visit_binary_arithmetic_operation
    alias_method :visit_minus,     :visit_binary_arithmetic_operation
    alias_method :visit_times,     :visit_binary_arithmetic_operation

    def visit_call(call, scope = @root_scope)
      if (receiver_type = visit(call.receiver, scope)).callable?
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

    def visit_new_array(expression, scope = @root_scope)
      MiniJava::Syntax::ArrayType.instance
    end

    def visit_new_object(expression, scope = @root_scope)
      MiniJava::Syntax::ObjectType.new expression.class_name
    end

    def visit_integer_literal(literal, scope = @root_scope)
      MiniJava::Syntax::IntegerType.instance
    end

    def visit_true_literal(literal, scope = @root_scope)
      MiniJava::Syntax::BooleanType.instance
    end

    def visit_false_literal(literal, scope = @root_scope)
      MiniJava::Syntax::BooleanType.instance
    end


    def visit_identifier(identifier, scope = @root_scope)
      scope.reference_type_by(name: identifier.name)
    end
  end
end
