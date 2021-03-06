module MiniJava
  require "minijava/lexer"
  require "minijava/parser"

  require "minijava/syntax"
  require "minijava/scope"
  require "minijava/protocode"

  require "minijava/visitor"
  require "minijava/selector_visitor"
  require "minijava/scope_visitor"
  require "minijava/type_check_visitor"
  require "minijava/protocode_visitor"

  require "minijava/targets/amd64/generator"

  require "minijava/errors"
end
