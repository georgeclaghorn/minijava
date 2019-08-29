require "minijava/visitor"
require "minijava/scope"
require "minijava/errors"

module MiniJava
  class ScopeVisitor < Visitor
    def self.scope_for(root)
      Scope.build { |scope| new(scope).visit(root) }
    end

    def initialize(scope)
      @scope = scope
    end

    def visit_program(program)
      visit program.main_class_declaration
      visit_all program.class_declarations
      resolve_class_inheritance program
    end


    def visit_main_class_declaration(declaration)
      within scope.classes.add(declaration.name) do
        visit declaration.method_declaration
      end
    end

    def visit_main_method_declaration(declaration)
      scope.methods.add(name: declaration.name, type: declaration.type)
    end


    def visit_class_declaration(declaration)
      if scope.classes.include?(declaration.name)
        raise NameError, "Redefinition of class #{declaration.name}"
      else
        within scope.classes.add(declaration.name) do
          visit_all declaration.variable_declarations
          visit_all declaration.method_declarations
        end
      end
    end

    alias_method :visit_subclass_declaration, :visit_class_declaration

    def visit_variable_declaration(declaration)
      if scope.variables.include?(declaration.name)
        raise NameError, "Redefinition of variable #{declaration.name}"
      else
        scope.variables.add(name: declaration.name, type: declaration.type)
      end
    end

    def visit_method_declaration(declaration)
      if scope.methods.include?(declaration.name)
        raise NameError, "Redefinition of method #{declaration.name}"
      else
        within scope.methods.add(name: declaration.name, type: declaration.type) do
          visit_all declaration.parameters
          visit_all declaration.variable_declarations
        end
      end
    end

    def visit_formal_parameter(parameter)
      if scope.variables.include?(parameter.name)
        raise NameError, "Redefinition of variable #{parameter.name}"
      else
        scope.variables.add(name: parameter.name, type: parameter.type)
      end
    end

    private
      attr_reader :scope

      def resolve_class_inheritance(program)
        program.subclass_declarations.each do |declaration|
          class_scope = scope.class_scope_by(name: declaration.name)

          if superclass_scope = scope.class_scope_by(name: declaration.superclass_name)
            class_scope.reparent(superclass_scope)
          else
            raise NameError, "Class #{declaration.name} extends undefined class #{declaration.superclass_name}"
          end
        end
      end

      def within(subscope)
        superscope, @scope = @scope, subscope
        yield
      ensure
        @scope = superscope
      end
  end
end
