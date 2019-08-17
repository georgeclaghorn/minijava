require "active_support/core_ext/string/inflections"

module MiniJava
  class Visitor
    def visit(visitable)
      send "visit_#{visitable.class.name.demodulize.underscore}", visitable
    end

    def visit_all(visitables)
      visitables.each { |visitable| visit(visitable) }
    end
  end
end
