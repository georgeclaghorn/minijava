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

        visit(declaration.return_expression).then do |result|
          emit return_with(result.location)
        end
      end
    end


    def visit_block(block)
      visit_all block.statements
    end

    def visit_if_statement(statement)
      visit(statement.condition).then do |condition|
        next_if_label_prefix.then do |prefix|
          emit jump_unless(condition.location, "#{prefix}.else")

          visit statement.affirmative
          emit jump("#{prefix}.end")

          label_with "#{prefix}.else"
          visit statement.negative

          label_with "#{prefix}.end"
        end
      end
    end

    def visit_while_statement(statement)
      next_while_label_prefix.then do |prefix|
        label_with "#{prefix}.begin"

        visit(statement.condition).then do |condition|
          emit jump_unless(condition.location, "#{prefix}.end")
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
      visit(statement.value).then do |value|
        emit copy(value.location, variable(statement.variable.name))
      end
    end

    def visit_array_element_assignment(statement)
      visit(statement.value).then do |value|
        emit copy_into(value.location, variable(statement.array.name), statement.index.value)
      end
    end


    def visit_not(operation)
      visit(operation.expression).then do |operand|
        emit_to(boolean) { |result| not_of operand.location, result }
      end
    end

    def visit_and(operation)
      visit(operation.left).then do |left|
        visit(operation.right).then do |right|
          emit_to(boolean) { |result| and_of left.location, right.location, result }
        end
      end
    end

    def visit_less_than(operation)
      visit(operation.left).then do |left|
        visit(operation.right).then do |right|
          emit_to(boolean) { |result| less_than left.location, right.location, result }
        end
      end
    end

    def visit_plus(operation)
      visit(operation.left).then do |left|
        visit(operation.right).then do |right|
          emit_to(integer) { |result| add left.location, right.location, result }
        end
      end
    end

    def visit_minus(operation)
      visit(operation.left).then do |left|
        visit(operation.right).then do |right|
          emit_to(integer) { |result| subtract left.location, right.location, result }
        end
      end
    end

    def visit_times(operation)
      visit(operation.left).then do |left|
        visit(operation.right).then do |right|
          emit_to(integer) { |result| multiply left.location, right.location, result }
        end
      end
    end

    def visit_variable_access(access)
      Protocode::Result.new variable(access.variable.name), variable_type_by_name(access.variable.name)
    end

    def visit_array_access(access)
      visit(access.array).then do |array|
        emit_to(integer) { |result| index_into array.location, access.index.value, result }
      end
    end

    def visit_array_length(length)
      visit(length.array).then do |array|
        emit_to(integer) { |result| length_of array.location, result }
      end
    end

    def visit_method_invocation(invocation)
      visit(invocation.receiver).then do |receiver|
        visit_all(invocation.parameters).then do |parameters|
          push_all parameters
          push receiver

          emit_to method_type_in_class_by_name(receiver.type.class_name, invocation.name) do |result|
            call method_label(receiver.type.class_name, invocation.name), parameters.count + 1, result
          end
        end
      end
    end

    def visit_new_object(expression)
      emit_to(object(expression.class_name)) { |result| new_object expression.class_name.to_s, result }
    end

    def visit_new_array(expression)
      emit_to(array) { |result| new_array integer, expression.size.value, result }
    end

    def visit_integer_literal(literal)
      emit_to(integer) { |result| copy literal.value, result }
    end

    def visit_true_literal(literal)
      emit_to(boolean) { |result| copy true, result }
    end

    def visit_false_literal(literal)
      emit_to(boolean) { |result| copy false, result }
    end

    def visit_this(*)
      Protocode::Result.new this, object(scope.parent.context.name)
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


      def next_register
        register @register.nil? ? @register = 0 : @register += 1
      end

      def next_if_label_prefix
        ".if.#{@if ? @if += 1 : @if = 0}"
      end

      def next_while_label_prefix
        ".while.#{@while ? @while += 1 : @while = 0}"
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
        emit parameter(symbol.location)
      end

      def emit_to(type)
        Protocode::Result.new next_register.tap { |result| emit yield(result) }, type
      end

      def emit(instruction)
        instructions.append(instruction)
        nil
      end
  end
end
