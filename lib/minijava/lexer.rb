require "strscan"
require "active_support/core_ext/module/delegation"
require "minijava/errors"

module MiniJava
  class Lexer
    attr_reader :line

    def initialize(source)
      @scanner = StringScanner.new(source)
      @line    = 1
    end

    def next_token
      loop do
        if token = scan_next_token
          return token
        end

        if scanner.eos?
          return nil
        end
      end
    end

    private
      attr_reader :scanner
      delegate :peek, :scan, to: :scanner

      def scan_next_token
        @line += 1 if peek(1) == "\n"

        case
        when scan(/[ \r\n\t\f]/)
          nil

        when scan(/\/\*.*?\*\/|\/\*\*+\/|\/\/[^\r\n]*/)
          nil

        when scan(/class/)
          emit :CLASS

        when scan(/extends/)
          emit :EXTENDS

        when scan(/public/)
          emit :PUBLIC

        when scan(/static/)
          emit :STATIC

        when scan(/void/)
          emit :VOID

        when scan(/main/)
          emit :MAIN

        when scan(/new/)
          emit :NEW

        when scan(/if/)
          emit :IF

        when scan(/else/)
          emit :ELSE

        when scan(/while/)
          emit :WHILE

        when scan(/length/)
          emit :LENGTH

        when scan(/true/)
          emit :TRUE

        when scan(/false/)
          emit :FALSE

        when scan(/return/)
          emit :RETURN

        when scan(/this/)
          emit :THIS

        when scan(/boolean/)
          emit :BOOLEAN

        when scan(/int/)
          emit :INT

        when scan(/String/)
          emit :STRING

        when scan(/System\.out\.println/)
          emit :PRINTLN

        when scan(/\{/)
          emit :LBRACE

        when scan(/\}/)
          emit :RBRACE

        when scan(/;/)
          emit :SEMICOLON

        when scan(/,/)
          emit :COMMA

        when scan(/\(/)
          emit :LPAREN

        when scan(/\)/)
          emit :RPAREN

        when scan(/\[/)
          emit :LBRACKET

        when scan(/\]/)
          emit :RBRACKET

        when scan(/\./)
          emit :DOT

        when scan(/\!/)
          emit :NOT

        when scan(/\*/)
          emit :STAR

        when scan(/\+/)
          emit :PLUS

        when scan(/-/)
          emit :MINUS

        when scan(/</)
          emit :LT

        when scan(/&&/)
          emit :AND

        when scan(/=/)
          emit :EQUAL

        when text = scan(/[a-zA-Z_][a-zA-Z0-9_]*/)
          emit :IDENTIFIER, text

        when text = scan(/0(?![1-9]+)|[1-9][0-9]*/)
          emit :INT_LITERAL, Integer(text)

        when text = scan(/./)
          raise ParseError, "Illegal character '#{text}' on line #{@line}"
        end
      end

      def emit(name, value = nil)
        [name, value]
      end
  end
end
