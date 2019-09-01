module MiniJava
  module IntermediateRepresentation
    Label = Struct.new(:name)
    Copy  = Struct.new(:value, :result)

    Jump       = Struct.new(:label)
    JumpUnless = Struct.new(:condition, :label)

    Parameter = Struct.new(:value)
    Call      = Struct.new(:label, :parameter_count, :result)
    Return    = Struct.new(:value)

    ArrayAccess     = Struct.new(:array, :index, :result)
    ArrayAssignment = Struct.new(:value, :array, :index)

    NewObject = Struct.new(:type, :result)
    NewArray  = Struct.new(:type, :size, :result)
  end
end
