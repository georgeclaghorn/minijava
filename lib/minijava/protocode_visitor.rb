require "minijava/visitor"
require "minijava/protocode"

module MiniJava
  class ProtocodeVisitor < Visitor
    include Syntax::TypesHelper
    include Protocode::InstructionsHelper, Protocode::OperandsHelper

    def self.protocode_for(program, scope)
      [].tap { |functions| new(scope, functions).visit(program) }
    end

    def initialize(scope, functions)
      @scope     = scope
      @functions = functions
      @labelings = Protocode::NumberedLabelingsByPrefix.new
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
        build_function do
          visit declaration.statement
        end
      end
    end


    def visit_class_declaration(declaration)
      within class_scope_by_name(declaration.name) do
        visit_all declaration.method_declarations
      end
    end

    def visit_method_declaration(declaration)
      within method_scope_by_name(declaration.name) do
        build_function parameter_count: declaration.parameters.count + 1 do
          visit_all declaration.statements

          with_result_of declaration.return_expression do |destination|
            emit return_with(destination.operand)
          end
        end
      end
    end


    def visit_block(block)
      visit_all block.statements
    end

    def visit_if_statement(statement)
      with_next_if_labeling do |labels|
        with_result_of statement.condition do |condition|
          emit jump_unless(condition.operand, labels.else)
        end

        visit statement.affirmative
        emit jump(labels.end)

        label_with labels.else
        visit statement.negative

        label_with labels.end
      end
    end

    def visit_while_statement(statement)
      with_next_while_labeling do |labels|
        label_with labels.begin

        with_result_of statement.condition do |condition|
          emit jump_unless(condition.operand, labels.end)
        end

        visit statement.body
        emit jump(labels.begin)

        label_with labels.end
      end
    end

    def visit_print_statement(statement)
      push visit(statement.expression)
      emit call("System.out.println", 1)
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
        with_next_temporary do |destination|
          emit not_of(expression.operand, destination)
          propagate destination, boolean
        end
      end
    end

    def visit_and(operation)
      with_result_of operation.left do |left|
        with_result_of operation.right do |right|
          with_next_temporary do |destination|
            emit and_of(left.operand, right.operand, destination)
            propagate destination, boolean
          end
        end
      end
    end

    def visit_less_than(operation)
      with_result_of operation.left do |left|
        with_result_of operation.right do |right|
          with_next_temporary do |destination|
            emit less_than(left.operand, right.operand, destination)
            propagate destination, boolean
          end
        end
      end
    end

    def visit_plus(operation)
      with_result_of operation.left do |left|
        with_result_of operation.right do |right|
          with_next_temporary do |destination|
            emit add(left.operand, right.operand, destination)
            propagate destination, integer
          end
        end
      end
    end

    def visit_minus(operation)
      with_result_of operation.left do |left|
        with_result_of operation.right do |right|
          with_next_temporary do |destination|
            emit subtract(left.operand, right.operand, destination)
            propagate destination, integer
          end
        end
      end
    end

    def visit_times(operation)
      with_result_of operation.left do |left|
        with_result_of operation.right do |right|
          with_next_temporary do |destination|
            emit multiply(left.operand, right.operand, destination)
            propagate destination, integer
          end
        end
      end
    end

    def visit_variable_access(access)
      if index = formal_parameter_index_by_name(access.variable.name)
        propagate temporary(index + 1), variable_type_by_name(access.variable.name)
      else
        propagate variable(access.variable.name), variable_type_by_name(access.variable.name)
      end
    end

    def visit_array_access(access)
      with_result_of access.array do |array|
        with_next_temporary do |destination|
          emit index_into(array.operand, access.index.value, destination)
          propagate destination, integer
        end
      end
    end

    def visit_array_length(length)
      with_result_of length.array do |array|
        with_next_temporary do |destination|
          emit length_of(array.operand, destination)
          propagate destination, integer
        end
      end
    end

    def visit_method_invocation(invocation)
      with_result_of invocation.receiver do |receiver|
        with_results_of invocation.parameters do |parameters|
          push receiver, parameters

          with_next_temporary do |destination|
            emit call("#{receiver.type.class_name}.#{invocation.name}", parameters.count + 1, destination)
            propagate destination, method_type_in_class_by_name(receiver.type, invocation.name)
          end
        end
      end
    end

    def visit_new_object(expression)
      with_next_temporary do |destination|
        emit new_object(expression.class_name.to_s, destination)
        propagate destination, object(expression.class_name)
      end
    end

    def visit_new_array(expression)
      with_next_temporary do |destination|
        emit new_array(integer, expression.size.value, destination)
        propagate destination, array
      end
    end

    def visit_integer_literal(literal)
      with_next_temporary do |destination|
        emit copy(literal.value, destination)
        propagate destination, boolean
      end
    end

    def visit_boolean_literal(literal)
      with_next_temporary do |destination|
        emit copy(literal.value, destination)
        propagate destination, boolean
      end
    end

    def visit_this(*)
      propagate this, object(parent.declaration.name)
    end

    private
      attr_reader :scope, :function
      delegate :parent, :declaration, :class_scope_by_name,
        :method_scope_by_name, :method_type_in_class_by_name, :variable_type_by_name, to: :scope

      def within(subscope)
        superscope, @scope = @scope, subscope
        yield
      ensure
        @scope = superscope
      end

      def formal_parameter_index_by_name(name)
        declaration.parameters.index { |parameter| parameter.name == name }
      end


      def build_function(name: "#{parent.declaration.name}.#{declaration.name}", parameter_count: 0)
        @function    = Protocode::Function.new(name, parameter_count, [])
        @temporaries = Protocode::NumberedTemporaries.new(parameter_count)

        yield
      ensure
        @functions.append(@function)

        @function    = nil
        @temporaries = nil
      end

      def label_with(name)
        emit label(name)
      end

      def push(*symbols)
        symbols.flatten.each { |symbol| emit parameter(symbol.operand) }
      end

      def emit(instruction)
        function.instructions.append(instruction)
        nil
      end

      def propagate(operand, type)
        Protocode::Result.new operand, type
      end


      def with_result_of(visitable)
        yield visit(visitable)
      end

      def with_results_of(visitable)
        yield visit_all(visitable)
      end

      def with_next_temporary
        yield @temporaries.next
      end

      def with_next_if_labeling
        yield @labelings.next(".if")
      end

      def with_next_while_labeling
        yield @labelings.next(".while")
      end
  end
end
