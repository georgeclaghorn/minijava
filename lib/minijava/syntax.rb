module MiniJava
  module Syntax
    Program = Struct.new(:main_class_declaration, :class_declarations)


    #== Declarations

    MainClassDeclaration  = Struct.new(:name, :method_declaration)
    MainMethodDeclaration = Struct.new(:formal_parameter_name, :statement)

    ClassDeclaration    = Struct.new(:name, :variable_declarations, :method_declarations)
    SubclassDeclaration = Struct.new(:name, :superclass_name, :variable_declarations, :method_declarations)

    MethodDeclaration =
      Struct.new(:type, :name, :formal_parameters, :variable_declarations, :statements, :return_expression)

    VariableDeclaration = Struct.new(:type, :name)
    FormalParameter     = Struct.new(:type, :name)


    #== Types

    class ArrayType
    end

    ARRAY_TYPE = ArrayType.new

    class BooleanType
    end

    BOOLEAN_TYPE = BooleanType.new

    class IntegerType
    end

    INTEGER_TYPE = IntegerType.new

    IdentifierType = Struct.new(:identifier)


    #== Statements

    Block           = Struct.new(:statements)

    IfStatement     = Struct.new(:condition, :affirmative, :negative)
    WhileStatement  = Struct.new(:condition, :statement)
    PrintStatement  = Struct.new(:expression)

    Assignment      = Struct.new(:assignee, :value)
    ArrayAssignment = Struct.new(:array, :index, :value)


    #== Expressions

    Not            = Struct.new(:expression)
    And            = Struct.new(:left, :right)
    LessThan       = Struct.new(:left, :right)
    Plus           = Struct.new(:left, :right)
    Minus          = Struct.new(:left, :right)
    Times          = Struct.new(:left, :right)

    ArraySubscript = Struct.new(:array, :index)

    Call           = Struct.new(:receiver, :method_name, :parameters)

    NewArray       = Struct.new(:size)
    NewObject      = Struct.new(:class_name)


    #== Literals

    IntegerLiteral = Struct.new(:value)

    class TrueLiteral
    end

    TRUE_LITERAL = TrueLiteral.new

    class FalseLiteral
    end

    FALSE_LITERAL = FalseLiteral.new

    class This
    end

    THIS = This.new


    #== Other

    Identifier = Struct.new(:name) do
      def to_s
        name
      end
    end
  end
end
