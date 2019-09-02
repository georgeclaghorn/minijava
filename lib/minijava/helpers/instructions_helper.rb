require "minijava/protocode"

module MiniJava
  module InstructionsHelper
    private

    def label(name)
      MiniJava::Protocode::Label.new(name)
    end

    def not_of(operand, result)
      MiniJava::Protocode::Not.new(operand, result)
    end

    def and_of(left, right, result)
      MiniJava::Protocode::And.new(left, right, result)
    end

    def less_than(left, right, result)
      MiniJava::Protocode::LessThan.new(left, right, result)
    end

    def copy(value, result)
      MiniJava::Protocode::Copy.new(value, result)
    end

    def jump(label)
      MiniJava::Protocode::Jump.new(label)
    end

    def jump_unless(condition, label)
      MiniJava::Protocode::JumpUnless.new(condition, label)
    end

    def parameter(value)
      MiniJava::Protocode::Parameter.new(value)
    end

    def call(label, parameter_count, result = nil)
      MiniJava::Protocode::Call.new(label, parameter_count, result)
    end

    def return_with(value)
      MiniJava::Protocode::Return.new(value)
    end

    def index_into(array, index, result)
      MiniJava::Protocode::ArrayAccess.new(array, index, result)
    end

    def copy_into(value, array, index)
      MiniJava::Protocode::ArrayAssignment.new(value, array, index)
    end

    def length_of(array, result)
      MiniJava::Protocode::ArrayLength.new(array, result)
    end

    def new_object(type, result)
      MiniJava::Protocode::NewObject.new(type, result)
    end

    def new_array(type, size, result)
      MiniJava::Protocode::NewArray.new(type, size, result)
    end
  end
end
