require "minijava/visitors/visitor"

module MiniJava
  module Visitors
    class SelectorVisitor < Visitor
      attr_reader :selector

      def initialize(selector)
        @selector = selector
      end

      def visit(visitable)
        super || []
      end


      def visit_program(program)
        select(program) + visit(program.main_class_declaration) + visit_all(program.class_declarations)
      end


      def visit_main_class_declaration(declaration)
        select(declaration) + visit(declaration.name) + visit(declaration.method_declaration)
      end

      def visit_main_method_declaration(declaration)
        select(declaration) + visit(declaration.formal_parameter_name) + visit(declaration.statement)
      end


      def visit_class_declaration(declaration)
        select(declaration) + visit(declaration.name) +
          visit_all(declaration.variable_declarations) + visit_all(declaration.method_declarations)
      end

      def visit_subclass_declaration(declaration)
        select(declaration) + visit(declaration.name) + visit(declaration.superclass_name) +
          visit_all(declaration.variable_declarations) + visit_all(declaration.method_declarations)
      end

      def visit_variable_declaration(declaration)
        select(declaration) + visit(declaration.type) + visit(declaration.name)
      end

      def visit_method_declaration(declaration)
        select(declaration) +
          visit(declaration.type) +
          visit(declaration.name) +
          visit_all(declaration.formal_parameters) +
          visit_all(declaration.variable_declarations) +
          visit_all(declaration.statements) +
          visit(declaration.return_expression)
      end

      def visit_formal_parameter(parameter)
        select(parameter) + visit(parameter.type) + visit(parameter.name)
      end


      def visit_array_type(type)
        select type
      end

      def visit_boolean_type(type)
        select type
      end

      def visit_integer_type(type)
        select type
      end

      def visit_identifier_type(type)
        select(type) + visit(type.identifier)
      end


      def visit_block(block)
        select(block) + visit_all(block.statements)
      end

      def visit_if_statement(statement)
        select(statement) + visit(statement.condition) + visit(statement.affirmative) + visit(statement.negative)
      end

      def visit_while_statement(statement)
        select(statement) + visit(statement.condition) + visit(statement.substatement)
      end

      def visit_print_statement(statement)
        select(statement) + visit(statement.expression)
      end

      def visit_assignment(assignment)
        select(assignment) + visit(assignment.assignee) + visit(assignment.value)
      end

      def visit_array_assignment(assignment)
        select(assignment) + visit(assignment.array) + visit(assignment.index) + visit(assignment.value)
      end


      def visit_unary_operation(operation)
        select(operation) + visit(operation.expression)
      end

      alias_method :visit_not, :visit_unary_operation

      def visit_binary_operation(operation)
        select(operation) + visit(operation.left) + visit(operation.right)
      end

      alias_method :visit_and,       :visit_binary_operation
      alias_method :visit_less_than, :visit_binary_operation
      alias_method :visit_plus,      :visit_binary_operation
      alias_method :visit_minus,     :visit_binary_operation
      alias_method :visit_times,     :visit_binary_operation

      def visit_array_subscript(subscript)
        select(subscript) + visit(subscript.array) + visit(subscript.index)
      end

      def visit_call(call)
        select(call) + visit(call.receiver) + visit(call.method_name) + visit_all(call.parameters)
      end

      def visit_new_array(expression)
        select(expression) + visit(expression.size)
      end

      def visit_new_object(expression)
        select(expression) + visit(expression.class_name)
      end


      def visit_literal(literal)
        select literal
      end

      alias_method :visit_integer_literal, :visit_literal
      alias_method :visit_true_literal,    :visit_literal
      alias_method :visit_false_literal,   :visit_literal
      alias_method :visit_this,            :visit_literal


      def visit_identifier(identifier)
        select identifier
      end

      private
        def select(visitable)
          selector === visitable ? [ visitable ] : []
        end

        def visit_all(visitables)
          visitables.flat_map { |visitable| visit(visitable) }
        end
    end
  end
end
