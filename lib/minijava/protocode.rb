module MiniJava
  module Protocode
    Label = Struct.new(:name)

    Not      = Struct.new(:operand, :result)
    And      = Struct.new(:left, :right, :result)
    LessThan = Struct.new(:left, :right, :result)
    Add      = Struct.new(:left, :right, :result)
    Subtract = Struct.new(:left, :right, :result)
    Multiply = Struct.new(:left, :right, :result)
    Copy     = Struct.new(:value, :result)

    Jump       = Struct.new(:label)
    JumpUnless = Struct.new(:condition, :label)

    Parameter = Struct.new(:value)
    Call      = Struct.new(:label, :parameter_count, :result)
    Return    = Struct.new(:value)

    ArrayAccess     = Struct.new(:array, :index, :result)
    ArrayAssignment = Struct.new(:value, :array, :index)
    ArrayLength     = Struct.new(:array, :result)

    NewObject = Struct.new(:type, :result)
    NewArray  = Struct.new(:type, :size, :result)
  end
end
