require "minijava/visitor"
require "minijava/scopes"
require "minijava/errors"

module MiniJava
  class ScopeVisitor < Visitor
    def self.scope_for(program)
      ProgramScope.build { |root| new(root).visit(program) }
    end

    def initialize(root)
      @root = root
    end

    def visit_program(program)
      visit program.main_class_declaration
      visit_all program.class_declarations
    end


    def visit_main_class_declaration(declaration)
      @root.classes.add(declaration.name) do |scope|
        visit declaration.method_declaration, scope
      end
    end

    def visit_main_method_declaration(declaration, scope)
      scope.methods.add(name: declaration.name, type: declaration.type) do |own_scope|
        own_scope.variables.add(name: declaration.formal_parameter_name, type: MiniJava::Syntax::ArrayType.instance)
      end
    end


    def visit_class_declaration(declaration)
      if @root.classes.include?(declaration.name)
        raise NameError, "Redefinition of class #{declaration.name}"
      else
        @root.classes.add(declaration.name) do |own_scope|
          visit_all declaration.variable_declarations, own_scope
          visit_all declaration.method_declarations, own_scope
        end
      end
    end

    def visit_variable_declaration(declaration, scope)
      if scope.variables.include?(declaration.name)
        raise NameError, "Redefinition of variable #{declaration.name}"
      else
        scope.variables.add(name: declaration.name, type: declaration.type)
      end
    end

    def visit_method_declaration(declaration, scope)
      if scope.methods.include?(declaration.name)
        raise NameError, "Redefinition of method #{declaration.name}"
      else
        scope.methods.add(name: declaration.name, type: declaration.type) do |own_scope|
          visit_all declaration.formal_parameters, own_scope
          visit_all declaration.variable_declarations, own_scope
        end
      end
    end

    def visit_formal_parameter(parameter, scope)
      if scope.variables.include?(parameter.name)
        raise NameError, "Redefinition of variable #{parameter.name}"
      else
        scope.variables.add(name: parameter.name, type: parameter.type)
      end
    end
  end
end
