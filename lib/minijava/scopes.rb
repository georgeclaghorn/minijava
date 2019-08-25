module MiniJava
  class Scope
    def self.build(*args, &block)
      new(*args).tap(&block)
    end
  end

  class ProgramScope < Scope
    attr_reader :classes

    def initialize
      @classes = ClassSet.new
    end

    def class?(name)
      classes.include?(name)
    end

    def class_scope_for(name)
      classes.scope_for(name)
    end
  end

  class ClassScope < Scope
    attr_reader :variables, :methods

    def initialize
      @variables = VariableSet.new
      @methods   = MethodSet.new(self)
    end

    def method?(name)
      methods.include?(name)
    end

    def method_type_for(name)
      methods.type_for(name)
    end

    def method_scope_for(name)
      methods.scope_for(name)
    end

    def variable?(name)
      variables.include?(name)
    end

    def variable_type_for(name)
      variables.type_for(name)
    end
  end

  class MethodScope < Scope
    attr_reader :parent, :variables

    def initialize(parent)
      @parent    = parent
      @variables = VariableSet.new
    end

    def variable?(name)
      variables.include?(name) || parent.variable?(name)
    end

    def variable_type_for(name)
      variables.type_for(name) || parent.variable_type_for(name)
    end
  end


  class ClassSet
    def initialize
      @scopes = {}
    end

    def add(name, &block)
      @scopes[name.to_s] = ClassScope.build(&block)
      nil
    end

    def include?(name)
      @scopes.include?(name.to_s)
    end

    def scope_for(name)
      @scopes[name.to_s]
    end
  end

  class MethodSet
    Entry = Struct.new(:type, :scope)

    def initialize(parent)
      @parent  = parent
      @entries = {}
    end

    def add(name:, type:, &block)
      @entries[name.to_s] = Entry.new(type, MethodScope.build(@parent, &block))
      nil
    end

    def include?(name)
      @entries.include?(name.to_s)
    end

    def type_for(name)
      @entries[name.to_s]&.type
    end

    def scope_for(name)
      @entries[name.to_s]&.scope
    end
  end

  class VariableSet
    def initialize
      @types = {}
    end

    def add(name:, type:)
      @types[name.to_s] = type
      nil
    end

    def include?(name)
      @types.include?(name.to_s)
    end

    def type_for(name)
      @types[name.to_s]
    end
  end
end
