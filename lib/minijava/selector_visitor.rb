require "minijava/visitor"

module MiniJava
  class SelectorVisitor < Visitor
    def self.select(selector, root)
      [].tap { |matches| new(selector, matches).visit(root) }
    end

    def initialize(selector, matches)
      @selector, @matches = selector, matches
    end

    def visit_program(program)
      match program
      visit program.main_class_declaration
      visit_all program.class_declarations
    end


    def visit_main_class_declaration(declaration)
      match declaration
      visit declaration.name
      visit declaration.method_declaration
    end

    def visit_main_method_declaration(declaration)
      match declaration
      visit declaration.statement
    end


    def visit_class_declaration(declaration)
      match declaration
      visit declaration.name
      visit_all declaration.variable_declarations
      visit_all declaration.method_declarations
    end

    def visit_subclass_declaration(declaration)
      match declaration
      visit declaration.name
      visit declaration.superclass_name
      visit_all declaration.variable_declarations
      visit_all declaration.method_declarations
    end

    def visit_variable_declaration(declaration)
      match declaration
      visit declaration.type
      visit declaration.name
    end

    def visit_method_declaration(declaration)
      match declaration
      visit declaration.type
      visit declaration.name
      visit_all declaration.parameters
      visit_all declaration.variable_declarations
      visit_all declaration.statements
      visit declaration.return_expression
    end

    def visit_formal_parameter(parameter)
      match parameter
      visit parameter.type
      visit parameter.name
    end


    def visit_array_type(type)
      match type
    end

    def visit_boolean_type(type)
      match type
    end

    def visit_integer_type(type)
      match type
    end

    def visit_object_type(type)
      match type
      visit type.class_name
    end


    def visit_block(block)
      match block
      visit_all block.statements
    end

    def visit_if_statement(statement)
      match statement
      visit statement.condition
      visit statement.affirmative
      visit statement.negative
    end

    def visit_while_statement(statement)
      match statement
      visit statement.condition
      visit statement.substatement
    end

    def visit_print_statement(statement)
      match statement
      visit statement.expression
    end

    def visit_simple_assignment(assignment)
      match assignment
      visit assignment.variable_name
      visit assignment.value
    end

    def visit_array_element_assignment(assignment)
      match assignment
      visit assignment.array
      visit assignment.index
      visit assignment.value
    end


    def visit_unary_operation(operation)
      match operation
      visit operation.expression
    end

    alias_method :visit_not, :visit_unary_operation

    def visit_binary_operation(operation)
      match operation
      visit operation.left
      visit operation.right
    end

    alias_method :visit_and,       :visit_binary_operation
    alias_method :visit_less_than, :visit_binary_operation
    alias_method :visit_plus,      :visit_binary_operation
    alias_method :visit_minus,     :visit_binary_operation
    alias_method :visit_times,     :visit_binary_operation

    def visit_array_element_access(access)
      match access
      visit access.array
      visit access.index
    end

    def visit_array_length(length)
      match length
      visit length.array
    end

    def visit_call(call)
      match call
      visit call.receiver
      visit call.method_name
      visit_all call.parameters
    end

    def visit_access(access)
      match access
      visit access.variable_name
    end

    def visit_new_array(expression)
      match expression
      visit expression.size
    end

    def visit_new_object(expression)
      match expression
      visit expression.class_name
    end


    def visit_literal(literal)
      match literal
    end

    alias_method :visit_integer_literal, :visit_literal
    alias_method :visit_true_literal,    :visit_literal
    alias_method :visit_false_literal,   :visit_literal
    alias_method :visit_this,            :visit_literal


    def visit_identifier(identifier)
      match identifier
    end


    def visit_error(error)
      match error
    end

    alias_method :visit_invalid_variable_declaration, :visit_error
    alias_method :visit_invalid_statement, :visit_error
    alias_method :visit_invalid_method_declaration, :visit_error
    alias_method :visit_invalid_class_declaration, :visit_error

    private
      def match(node)
        @matches.append(node) if match?(node)
      end

      def match?(node)
        @selector === node
      end
  end
end
