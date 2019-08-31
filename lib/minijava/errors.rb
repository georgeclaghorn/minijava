module MiniJava
  class Error < StandardError; end
  class SyntaxError < Error; end
  class NameError < Error; end
end
