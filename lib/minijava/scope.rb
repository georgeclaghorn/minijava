module MiniJava
  class Scope
    attr_reader :parent, :declaration, :classes, :methods, :variables

    def self.build(*args, &block)
      new(*args).tap(&block)
    end

    def initialize(parent = NullScope.instance, declaration = nil)
      @parent      = parent
      @declaration = declaration
      @classes     = ScopeMap.new(self)
      @methods     = ScopeMap.new(self)
      @variables   = VariableMap.new
    end

    def reparent(parent)
      @parent = parent
    end


    def class?(name)
      classes.include?(name) || parent.class?(name)
    end

    def class_scope_by_name(name)
      classes[name] || parent.class_scope_by_name(name)
    end


    def method?(name)
      methods.include?(name) || parent.method?(name)
    end

    def method_scope_by_name(name)
      methods[name] || parent.method_scope_by_name(name)
    end

    def method_declaration_by_name(name)
      method_scope_by_name(name)&.declaration
    end

    def method_declaration_in_class_by_name(class_name, method_name)
      class_scope_by_name(class_name)&.method_declaration_by_name(method_name)
    end

    def method_type_in_class_by_name(class_name, method_name)
      method_declaration_in_class_by_name(class_name, method_name)&.type
    end


    def variable?(name)
      variables.include?(name) || parent.variable?(name)
    end

    def variable_type_by_name(name)
      variables.type_for(name) || parent.variable_type_by_name(name)
    end
  end

  class NullScope
    include Singleton

    def class?(name)
      false
    end

    def class_scope_by_name(name)
      nil
    end


    def method?(name)
      false
    end

    def method_declaration_by_name(name)
      nil
    end

    def method_scope_by_name(name)
      nil
    end

    def method_declaration_in_class_by_name(class_name, method_name)
      nil
    end

    def method_type_in_class_by_name(class_name, method_name)
      nil
    end


    def variable?(name)
      false
    end

    def variable_type_by_name(name)
      nil
    end
  end


  class ScopeMap
    def initialize(parent = nil)
      @parent = parent
      @scopes = {}
    end

    def add(declaration)
      @scopes[declaration.name.to_s] = Scope.new(@parent, declaration)
    end

    def include?(name)
      @scopes.include?(name.to_s)
    end

    def [](name)
      @scopes[name.to_s]
    end
  end

  class VariableMap
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
