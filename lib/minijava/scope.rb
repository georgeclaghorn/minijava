require "minijava/hash_with_normalized_keys"
require "minijava/errors"

module MiniJava
  class Scope
    attr_accessor :parent
    attr_reader :declaration, :classes, :methods, :variables

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

    def variable_declaration_by_name(name)
      variables[name] || parent.variable_declaration_by_name(name)
    end

    def variable_type_by_name(name)
      variable_declaration_by_name(name)&.type
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

    def method_scope_by_name(name)
      nil
    end

    def method_declaration_by_name(name)
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

    def variable_declaration_by_name(name)
      nil
    end

    def variable_type_by_name(name)
      nil
    end
  end


  class ScopeMap
    attr_reader :parent, :scopes
    delegate :[], :include?, to: :scopes

    def initialize(parent = nil)
      @parent = parent
      @scopes = SymbolMap.new
    end

    def add_scope_for(declaration)
      Scope.new(parent, declaration).tap { |scope| scopes.add(declaration.name, scope) }
    end
  end

  class VariableMap
    attr_reader :declarations
    delegate :[], :include?, to: :declarations

    def initialize
      @declarations = SymbolMap.new
    end

    def add(declaration)
      declarations.add(declaration.name, declaration)
      self
    end
  end

  class SymbolMap
    delegate :[], :include?, to: :@symbols

    def initialize
      @symbols = HashWithNormalizedKeys.new(&:to_s)
    end

    def add(name, value)
      ensure_undefined name
      store name, value
    end

    def store(name, value)
      @symbols.store(name, value)
      self
    end

    private
      def ensure_undefined(name)
        raise NameError, "Symbol #{name} is already defined" if include?(name)
      end
  end
end
