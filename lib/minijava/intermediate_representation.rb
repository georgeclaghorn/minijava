module MiniJava
  module IntermediateRepresentation
    Label = Struct.new(:name)
    Copy  = Struct.new(:value, :result)

    Parameter = Struct.new(:value)
    Call      = Struct.new(:label, :parameter_count, :result)
    Return    = Struct.new(:value)

    ArrayAccess     = Struct.new(:array, :index, :result)
    ArrayAssignment = Struct.new(:value, :array, :index)

    NewObject = Struct.new(:type, :result)
    NewArray  = Struct.new(:type, :size, :result)
  end
end
