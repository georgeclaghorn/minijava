require "minijava/visitor"
require "minijava/scope"
require "minijava/errors"

module MiniJava
  class ScopeVisitor < Visitor
    def self.scope_for(root)
      Scope.build { |scope| new(scope).visit(root) }
    end

    def initialize(root_scope)
      @root_scope = root_scope
    end

    def visit_program(program)
      visit program.main_class_declaration
      visit_all program.class_declarations
      resolve_class_inheritance program
    end


    def visit_main_class_declaration(declaration)
      @root_scope.classes.add(declaration.name) do |scope|
        visit declaration.method_declaration, scope
      end
    end

    def visit_main_method_declaration(declaration, scope = @root_scope)
      scope.methods.add(name: declaration.name, type: declaration.type) do |own_scope|
        own_scope.variables.add(name: declaration.formal_parameter_name, type: MiniJava::Syntax::ArrayType.instance)
      end
    end


    def visit_class_declaration(declaration)
      if @root_scope.classes.include?(declaration.name)
        raise NameError, "Redefinition of class #{declaration.name}"
      else
        @root_scope.classes.add(declaration.name) do |own_scope|
          visit_all declaration.variable_declarations, own_scope
          visit_all declaration.method_declarations, own_scope
        end
      end
    end

    alias_method :visit_subclass_declaration, :visit_class_declaration

    def visit_variable_declaration(declaration, scope = @root_scope)
      if scope.variables.include?(declaration.name)
        raise NameError, "Redefinition of variable #{declaration.name}"
      else
        scope.variables.add(name: declaration.name, type: declaration.type)
      end
    end

    def visit_method_declaration(declaration, scope = @root_scope)
      if scope.methods.include?(declaration.name)
        raise NameError, "Redefinition of method #{declaration.name}"
      else
        scope.methods.add(name: declaration.name, type: declaration.type) do |own_scope|
          visit_all declaration.formal_parameters, own_scope
          visit_all declaration.variable_declarations, own_scope
        end
      end
    end

    def visit_formal_parameter(parameter, scope = @root_scope)
      if scope.variables.include?(parameter.name)
        raise NameError, "Redefinition of variable #{parameter.name}"
      else
        scope.variables.add(name: parameter.name, type: parameter.type)
      end
    end

    private
      def resolve_class_inheritance(program)
        program.class_declarations.each do |declaration|
          unless declaration.superclass_name.nil?
            class_scope      = @root_scope.class_scope_by!(name: declaration.name)
            superclass_scope = @root_scope.class_scope_by!(name: declaration.superclass_name)

            class_scope.reparent(superclass_scope)
          end
        end
      end
  end
end
