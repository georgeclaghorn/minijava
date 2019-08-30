require "singleton"
require "minijava/selector_visitor"

module MiniJava
  module Syntax
    Program = Struct.new(:main_class_declaration, :class_declarations) do
      def subclass_declarations
        class_declarations.reject { |declaration| declaration.superclass_name.nil? }
      end

      def select(selector)
        MiniJava::SelectorVisitor.select(selector, self)
      end
    end


    #== Declarations

    MainClassDeclaration = Struct.new(:name, :method_declaration)

    MainMethodDeclaration = Struct.new(:statement) do
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

    MethodDeclaration   = Struct.new(:type, :name, :parameters, :variable_declarations, :statements, :return_expression)
    FormalParameter     = Struct.new(:type, :name)

    VariableDeclaration = Struct.new(:type, :name)


    #== Types

    class Type
      def dereferenceable?
        false
      end

      def known?
        true
      end
    end

    class ArrayType < Type
      include Singleton

      def to_s
        "int[]"
      end
    end

    class BooleanType < Type
      include Singleton

      def to_s
        "boolean"
      end
    end

    class IntegerType < Type
      include Singleton

      def to_s
        "int"
      end
    end

    class VoidType < Type
      include Singleton

      def to_s
        "void"
      end
    end

    class ObjectType < Type
      attr_reader :class_name

      def initialize(class_name)
        @class_name = class_name
      end

      def dereferenceable?
        true
      end

      def ==(other)
        other.is_a?(ObjectType) && other.class_name == class_name
      end

      def to_s
        class_name.to_s
      end
    end

    class UnknownType < Type
      include Singleton

      def dereferenceable?
        true
      end

      def known?
        false
      end

      def to_s
        "<unknown>"
      end
    end


    #== Statements

    Block          = Struct.new(:statements)
    IfStatement    = Struct.new(:condition, :affirmative, :negative)
    WhileStatement = Struct.new(:condition, :substatement)
    PrintStatement = Struct.new(:expression)

    VariableAssignment = Struct.new(:variable, :value)
    ArrayElementAssignment = Struct.new(:array, :index, :value)


    #== Expressions

    Not      = Struct.new(:expression)
    And      = Struct.new(:left, :right)
    LessThan = Struct.new(:left, :right)
    Plus     = Struct.new(:left, :right)
    Minus    = Struct.new(:left, :right)
    Times    = Struct.new(:left, :right)

    VariableAccess = Struct.new(:variable)
    ArrayAccess    = Struct.new(:array, :index)
    ArrayLength    = Struct.new(:array)

    MethodInvocation = Struct.new(:receiver, :name, :parameters)

    NewArray  = Struct.new(:size)
    NewObject = Struct.new(:class_name)


    #== Literals

    IntegerLiteral = Struct.new(:value) do
      def to_i
        value
      end
    end

    class TrueLiteral
      include Singleton
    end

    class FalseLiteral
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

    class This
      include Singleton
    end
  end
end
