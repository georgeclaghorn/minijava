module MiniJava
  require "minijava/lexer"
  require "minijava/parser"

  require "minijava/syntax"
  require "minijava/intermediate_representation"

  require "minijava/scope"

  require "minijava/visitor"
  require "minijava/selector_visitor"
  require "minijava/scope_visitor"
  require "minijava/type_check_visitor"
  require "minijava/intermediate_representation_visitor"

  require "minijava/errors"

  require "minijava/helpers/types_helper"
  require "minijava/helpers/instructions_helper"
end
