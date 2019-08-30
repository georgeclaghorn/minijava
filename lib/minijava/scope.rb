require "minijava/errors"

module MiniJava
  class Scope
    attr_reader :parent, :classes, :methods, :variables

    def self.build(*args, &block)
      new(*args).tap(&block)
    end

    def initialize(parent = NullScope.instance)
      @parent    = parent
      @classes   = ClassSet.new(self)
      @methods   = MethodSet.new(self)
      @variables = VariableSet.new
    end

    def reparent(parent)
      @parent = parent
    end


    def class?(name)
      classes.include?(name) || parent.class?(name)
    end

    def class_scope_by_name(name)
      classes.scope_for(name) || parent.class_scope_by_name(name)
    end


    def method?(name)
      methods.include?(name) || parent.method?(name)
    end

    def method_type_by_name(name)
      methods.type_for(name) || parent.method_type_by_name(name)
    end

    def method_scope_by_name(name)
      methods.scope_for(name) || parent.method_scope_by_name(name)
    end


    def variable?(name)
      variables.include?(name) || parent.variable?(name)
    end

    def variable_type_by_name(name)
      variables.type_for(name) || parent.variable_type_by_name(name)
    end

    def variable_type_by_name!(name)
      variable_type_by_name(name) || raise(NameError, "Cannot find variable: #{name}")
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

    def method_type_by_name(name)
      nil
    end

    def method_scope_by_name(name)
      nil
    end


    def variable?(name)
      false
    end

    def variable_type_by_name(name)
      nil
    end
  end


  class ClassSet
    def initialize(parent)
      @parent = parent
      @scopes = {}
    end

    def add(name)
      @scopes[name.to_s] = Scope.new(@parent)
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
      Scope.new(@parent).tap { |scope| @entries[name.to_s] = Entry.new(type, scope) }
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
