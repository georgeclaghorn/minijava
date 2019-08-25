require "singleton"
require "minijava/selector_visitor"

module MiniJava
  module Syntax
    Program = Struct.new(:main_class_declaration, :class_declarations) do
      def select(selector)
        MiniJava::SelectorVisitor.select(selector, self)
      end
    end


    #== Declarations

    MainClassDeclaration = Struct.new(:name, :method_declaration)

    MainMethodDeclaration = Struct.new(:formal_parameter_name, :statement) do
      def type
        VoidType.instance
      end

      def name
        Identifier.new "main"
      end
    end

    ClassDeclaration = Struct.new(:name, :variable_declarations, :method_declarations) do
      def superclass_name
        nil
      end
    end

    SubclassDeclaration = Struct.new(:name, :superclass_name, :variable_declarations, :method_declarations)

    MethodDeclaration =
      Struct.new(:type, :name, :formal_parameters, :variable_declarations, :statements, :return_expression)

    VariableDeclaration = Struct.new(:type, :name)
    FormalParameter     = Struct.new(:type, :name)


    #== Types

    class ArrayType
      include Singleton
    end

    class BooleanType
      include Singleton
    end

    class IntegerType
      include Singleton
    end

    class VoidType
      include Singleton
    end

    IdentifierType = Struct.new(:identifier)


    #== Statements

    Block           = Struct.new(:statements)

    IfStatement     = Struct.new(:condition, :affirmative, :negative)
    WhileStatement  = Struct.new(:condition, :substatement)
    PrintStatement  = Struct.new(:expression)

    Assignment      = Struct.new(:left, :right)


    #== Expressions

    Not            = Struct.new(:expression)
    And            = Struct.new(:left, :right)
    LessThan       = Struct.new(:left, :right)
    Plus           = Struct.new(:left, :right)
    Minus          = Struct.new(:left, :right)
    Times          = Struct.new(:left, :right)

    ArraySubscript = Struct.new(:array, :index)
    ArrayLength    = Struct.new(:array)

    Call           = Struct.new(:receiver, :method_name, :parameters)

    NewArray       = Struct.new(:size)
    NewObject      = Struct.new(:class_name)


    #== Literals

    IntegerLiteral = Struct.new(:value)

    class TrueLiteral
      include Singleton
    end

    class FalseLiteral
      include Singleton
    end

    class This
      include Singleton
    end


    #== Errors

    class InvalidVariableDeclaration
      include Singleton
    end

    class InvalidStatement
      include Singleton
    end

    class InvalidMethodDeclaration
      include Singleton
    end

    class InvalidClassDeclaration
      include Singleton
    end


    #== Other

    Identifier = Struct.new(:name) do
      def to_s
        name
      end
    end
  end
end
