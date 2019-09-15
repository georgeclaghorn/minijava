module MiniJava
  module Protocode
    #== Instructions

    Function        = Struct.new(:name, :parameters, :instructions)

    Label           = Struct.new(:name)

    Not             = Struct.new(:source, :destination)
    And             = Struct.new(:left, :right, :destination)
    LessThan        = Struct.new(:left, :right, :destination)
    Add             = Struct.new(:left, :right, :destination)
    Subtract        = Struct.new(:left, :right, :destination)
    Multiply        = Struct.new(:left, :right, :destination)
    Copy            = Struct.new(:source, :destination)

    Jump            = Struct.new(:label)
    JumpUnless      = Struct.new(:condition, :label)

    Parameter       = Struct.new(:source)
    Call            = Struct.new(:label, :parameter_count, :destination)
    Return          = Struct.new(:source)

    ArrayAccess     = Struct.new(:array, :index, :destination)
    ArrayAssignment = Struct.new(:source, :array, :index)
    ArrayLength     = Struct.new(:array, :destination)

    NewObject       = Struct.new(:type, :destination)
    NewArray        = Struct.new(:type, :size, :destination)

    module InstructionsHelper
      private

      def function(name:, parameters:, instructions:)
        Function.new(name, parameters, instructions)
      end

      def label(name)
        Label.new(name)
      end

      def not_of(operand, result)
        Not.new(operand, result)
      end

      def and_of(left, right, result)
        And.new(left, right, result)
      end

      def less_than(left, right, result)
        LessThan.new(left, right, result)
      end

      def add(left, right, result)
        Add.new(left, right, result)
      end

      def subtract(left, right, result)
        Subtract.new(left, right, result)
      end

      def multiply(left, right, result)
        Multiply.new(left, right, result)
      end

      def copy(value, result)
        Copy.new(value, result)
      end

      def jump(label)
        Jump.new(label)
      end

      def jump_unless(condition, label)
        JumpUnless.new(condition, label)
      end

      def parameter(value)
        Parameter.new(value)
      end

      def call(label, parameter_count, result = nil)
        Call.new(label, parameter_count, result)
      end

      def return_with(value)
        Return.new(value)
      end

      def index_into(array, index, result)
        ArrayAccess.new(array, index, result)
      end

      def copy_into(value, array, index)
        ArrayAssignment.new(value, array, index)
      end

      def length_of(array, result)
        ArrayLength.new(array, result)
      end

      def new_object(type, result)
        MiniJava::Protocode::NewObject.new(type, result)
      end

      def new_array(type, size, result)
        MiniJava::Protocode::NewArray.new(type, size, result)
      end
    end

    class NumberedLabelingsByPrefix
      def initialize
        @labelings = Hash.new { |hash, prefix| hash[prefix] = NumberedLabelings.new(prefix) }
      end

      def next(prefix)
        @labelings[prefix].next
      end
    end

    class NumberedLabelings
      attr_reader :prefix

      def initialize(prefix)
        @prefix  = prefix
        @numbers = 0.step(by: 1)
      end

      def next
        Labeling.new("#{prefix}.#{@numbers.next}")
      end
    end

    class Labeling
      attr_reader :prefix

      def initialize(prefix)
        @prefix = prefix
      end

      def begin
        get "begin"
      end

      def else
        get "else"
      end

      def end
        get "end"
      end

      def get(suffix)
        "#{prefix}.#{suffix}"
      end
    end


    #== Operands

    TemporaryOperand = Struct.new(:number)
    VariableOperand  = Struct.new(:name)

    class ThisOperand
      include Singleton
    end

    module OperandsHelper
      private

      def temporary(number)
        TemporaryOperand.new(number)
      end

      def variable(name)
        VariableOperand.new(name)
      end

      def this
        ThisOperand.instance
      end
    end

    class NumberedTemporaries
      def initialize(start = 0)
        @numbers = start.step(by: 1)
      end

      def next
        TemporaryOperand.new(@numbers.next)
      end
    end


    #== Other

    Result = Struct.new(:operand, :type)
  end
end
