require "active_support/core_ext/string/inflections"

module MiniJava
  class Visitor
    def visit(visitable, *args)
      send "visit_#{visitable.class.name.demodulize.underscore}", visitable, *args
    end

    def visit_all(visitables, *args)
      visitables.collect { |visitable| visit(visitable, *args) }
    end


    # Most visitors don't care about error nodes. Ignore them by default.
    def visit_invalid_variable_declaration(*); end
    def visit_invalid_statement(*); end
    def visit_invalid_method_declaration(*); end
    def visit_invalid_class_declaration(*); end
  end
end
