require "minijava/syntax"

module MiniJava
  module TypesHelper
    private

    def boolean
      MiniJava::Syntax::BooleanType.instance
    end

    def integer
      MiniJava::Syntax::IntegerType.instance
    end

    def array
      MiniJava::Syntax::ArrayType.instance
    end

    def object(class_name)
      MiniJava::Syntax::ObjectType.new(class_name)
    end

    def unknown
      MiniJava::Syntax::UnknownType.instance
    end
  end
end
