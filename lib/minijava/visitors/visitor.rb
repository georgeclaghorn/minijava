require "active_support/core_ext/string/inflections"
require "active_support/core_ext/object/try"

module MiniJava
  module Visitors
    class Visitor
      def visit(visitable)
        try "visit_#{visitable.class.name.demodulize.underscore}", visitable
      end
    end
  end
end
