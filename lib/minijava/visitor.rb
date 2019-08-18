require "active_support/core_ext/string/inflections"

module MiniJava
  class Visitor
    def visit(visitable, *args)
      send "visit_#{visitable.class.name.demodulize.underscore}", visitable, *args
      nil
    end

    def visit_all(visitables, *args)
      visitables.each { |visitable| visit(visitable, *args) }
    end
  end
end
