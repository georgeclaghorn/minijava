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
      within new_class_scope_for(declaration) do
        visit declaration.method_declaration
      end
    end

    def visit_main_method_declaration(declaration)
      scope.methods.add_scope_for(declaration)
    end


    def visit_class_declaration(declaration)
      within new_class_scope_for(declaration) do
        visit_all declaration.variable_declarations
        visit_all declaration.method_declarations
      end
    end

    alias_method :visit_subclass_declaration, :visit_class_declaration

    def visit_variable_declaration(declaration)
      scope.variables.add(declaration)
    end

    def visit_method_declaration(declaration)
      within new_method_scope_for(declaration) do
        visit_all declaration.parameters
        visit_all declaration.variable_declarations
      end
    end

    def visit_formal_parameter(parameter)
      scope.variables.add(parameter)
    end

    private
      attr_reader :scope

      def within(subscope)
        superscope, @scope = @scope, subscope
        yield
      ensure
        @scope = superscope
      end

      def new_class_scope_for(declaration)
        scope.classes.add_scope_for(declaration)
      end

      def new_method_scope_for(declaration)
        scope.methods.add_scope_for(declaration)
      end


      def resolve_class_inheritance(program)
        program.subclass_declarations.each do |declaration|
          class_scope = scope.class_scope_by_name(declaration.name)

          if superclass_scope = scope.class_scope_by_name(declaration.superclass_name)
            class_scope.reparent(superclass_scope)
          else
            raise NameError, "Cannot find class #{declaration.superclass_name}"
          end
        end
      end
  end
end
