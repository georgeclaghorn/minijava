require "active_support/core_ext/string/inflections"
require "active_support/core_ext/object/try"

module MiniJava
  class Visitor
    def visit(visitable)
      try "visit_#{visitable.class.name.demodulize.underscore}", visitable
    end

    def visit_all(visitables)
      visitables.each { |visitable| visit(visitable) }
    end
  end
end
