require "minijava/visitor"
require "minijava/protocode"

module MiniJava
  class ProtocodeVisitor < Visitor
    include Syntax::TypesHelper
    include Protocode::InstructionsHelper, Protocode::OperandsHelper

    def self.protocode_for(program, scope)
      [].tap { |instructions| new(scope, instructions).visit(program) }
    end

    def initialize(scope, instructions)
      @scope, @instructions = scope, instructions
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
        label_with method_label(scope.parent.context.name, declaration.name)
        visit declaration.statement
      end
    end


    def visit_class_declaration(declaration)
      within class_scope_by_name(declaration.name) do
        visit_all declaration.method_declarations
      end
    end

    def visit_method_declaration(declaration)
      within method_scope_by_name(declaration.name) do
        label_with method_label(scope.parent.context.name, declaration.name)
        visit_all declaration.statements

        with_result_of declaration.return_expression do |result|
          emit return_with(result.operand)
        end
      end
    end


    def visit_block(block)
      visit_all block.statements
    end

    def visit_if_statement(statement)
      with_next_if_label_prefix do |prefix|
        with_result_of statement.condition do |condition|
          emit jump_unless(condition.operand, "#{prefix}.else")
        end

        visit statement.affirmative
        emit jump("#{prefix}.end")

        label_with "#{prefix}.else"
        visit statement.negative

        label_with "#{prefix}.end"
      end
    end

    def visit_while_statement(statement)
      with_next_while_label_prefix do |prefix|
        label_with "#{prefix}.begin"

        with_result_of statement.condition do |condition|
          emit jump_unless(condition.operand, "#{prefix}.end")
        end

        visit statement.body
        emit jump("#{prefix}.begin")

        label_with "#{prefix}.end"
      end
    end

    def visit_print_statement(statement)
      push visit(statement.expression)
      emit call("__println", 1)
    end

    def visit_variable_assignment(statement)
      with_result_of statement.value do |value|
        emit copy(value.operand, variable(statement.variable.name))
      end
    end

    def visit_array_element_assignment(statement)
      with_result_of statement.value do |value|
        emit copy_into(value.operand, variable(statement.array.name), statement.index.value)
      end
    end


    def visit_not(operation)
      with_result_of operation.expression do |expression|
        with_next_register do |result|
          emit not_of(expression.operand, result)
          propagate result, boolean
        end
      end
    end

    def visit_and(operation)
      with_result_of operation.left do |left|
        with_result_of operation.right do |right|
          with_next_register do |result|
            emit and_of(left.operand, right.operand, result)
            propagate result, boolean
          end
        end
      end
    end

    def visit_less_than(operation)
      with_result_of operation.left do |left|
        with_result_of operation.right do |right|
          with_next_register do |result|
            emit less_than(left.operand, right.operand, result)
            propagate result, boolean
          end
        end
      end
    end

    def visit_plus(operation)
      with_result_of operation.left do |left|
        with_result_of operation.right do |right|
          with_next_register do |result|
            emit add(left.operand, right.operand, result)
            propagate result, integer
          end
        end
      end
    end

    def visit_minus(operation)
      with_result_of operation.left do |left|
        with_result_of operation.right do |right|
          with_next_register do |result|
            emit subtract(left.operand, right.operand, result)
            propagate result, integer
          end
        end
      end
    end

    def visit_times(operation)
      with_result_of operation.left do |left|
        with_result_of operation.right do |right|
          with_next_register do |result|
            emit multiply(left.operand, right.operand, result)
            propagate result, integer
          end
        end
      end
    end

    def visit_variable_access(access)
      propagate variable(access.variable.name), variable_type_by_name(access.variable.name)
    end

    def visit_array_access(access)
      with_result_of access.array do |array|
        with_next_register do |result|
          emit index_into(array.operand, access.index.value, result)
          propagate result, integer
        end
      end
    end

    def visit_array_length(length)
      with_result_of length.array do |array|
        with_next_register do |result|
          emit length_of(array.operand, result)
          propagate result, integer
        end
      end
    end

    def visit_method_invocation(invocation)
      with_result_of invocation.receiver do |receiver|
        with_results_of invocation.parameters do |parameters|
          push_all parameters
          push receiver

          with_next_register do |result|
            emit call(method_label(receiver.type.class_name, invocation.name), parameters.count + 1, result)
            propagate result, method_type_in_class_by_name(receiver.type.class_name, invocation.name)
          end
        end
      end
    end

    def visit_new_object(expression)
      with_next_register do |result|
        emit new_object(expression.class_name.to_s, result)
        propagate result, object(expression.class_name)
      end
    end

    def visit_new_array(expression)
      with_next_register do |result|
        emit new_array(integer, expression.size.value, result)
        propagate result, array
      end
    end

    def visit_integer_literal(literal)
      with_next_register do |result|
        emit copy(literal.value, result)
        propagate result, boolean
      end
    end

    def visit_true_literal(literal)
      with_next_register do |result|
        emit copy(true, result)
        propagate result, boolean
      end
    end

    def visit_false_literal(literal)
      with_next_register do |result|
        emit copy(false, result)
        propagate result, boolean
      end
    end

    def visit_this(*)
      propagate this, object(scope.parent.context.name)
    end

    private
      attr_reader :scope, :instructions
      delegate :class_scope_by_name, :method_scope_by_name,
        :method_declaration_in_class_by_name, :variable_type_by_name, to: :scope

      def within(subscope)
        superscope, @scope = @scope, subscope
        yield
      ensure
        @scope = superscope
      end

      def method_type_in_class_by_name(class_name, method_name)
        method_declaration_in_class_by_name(class_name, method_name).type
      end


      def with_next_register
        yield register(@register.nil? ? @register = 0 : @register += 1)
      end

      def with_next_if_label_prefix
        yield ".if.#{@if ? @if += 1 : @if = 0}"
      end

      def with_next_while_label_prefix
        yield ".while.#{@while ? @while += 1 : @while = 0}"
      end


      def method_label(class_name, method_name)
        "#{class_name}.#{method_name}"
      end

      def label_with(name)
        emit label(name)
      end

      def push_all(symbols)
        symbols.reverse.each { |symbol| push symbol }
      end

      def push(symbol)
        emit parameter(symbol.operand)
      end

      def emit(instruction)
        instructions.append(instruction)
        nil
      end


      def with_result_of(visitable)
        yield visit(visitable)
      end

      def with_results_of(visitable)
        yield visit_all(visitable)
      end

      def propagate(operand, type)
        Protocode::Result.new operand, type
      end
  end
end
