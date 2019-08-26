module MiniJava
  class Error < StandardError; end
  class SyntaxError < Error; end
  class NameError < Error; end
  class TypeError < Error; end
end
