require "minijava/intermediate_representation"

module MiniJava
  module InstructionsHelper
    private

    def label(name)
      MiniJava::IntermediateRepresentation::Label.new(name)
    end

    def copy(value, result)
      MiniJava::IntermediateRepresentation::Copy.new(value, result)
    end

    def parameter(value)
      MiniJava::IntermediateRepresentation::Parameter.new(value)
    end

    def call(label, parameter_count, result = nil)
      MiniJava::IntermediateRepresentation::Call.new(label, parameter_count, result)
    end

    def return_with(value)
      MiniJava::IntermediateRepresentation::Return.new(value)
    end

    def new_object(type, result)
      MiniJava::IntermediateRepresentation::NewObject.new(type, result)
    end

    def new_array(type, size, result)
      MiniJava::IntermediateRepresentation::NewArray.new(type, size, result)
    end
  end
end
