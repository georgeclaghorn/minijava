require "strscan"
require "active_support/core_ext/module/delegation"
require "minijava/errors"

module MiniJava
  class Lexer
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
        when text = scan(/class/)
          emit :CLASS

        when text = scan(/extends/)
          emit :EXTENDS

        when text = scan(/public/)
          emit :PUBLIC

        when text = scan(/static/)
          emit :STATIC

        when text = scan(/void/)
          emit :VOID

        when text = scan(/main/)
          emit :MAIN

        when text = scan(/new/)
          emit :NEW

        when text = scan(/if/)
          emit :IF

        when text = scan(/else/)
          emit :ELSE

        when text = scan(/while/)
          emit :WHILE

        when text = scan(/length/)
          emit :LENGTH

        when text = scan(/true/)
          emit :TRUE

        when text = scan(/false/)
          emit :FALSE

        when text = scan(/return/)
          emit :RETURN

        when text = scan(/this/)
          emit :THIS

        when text = scan(/boolean/)
          emit :BOOLEAN

        when text = scan(/int/)
          emit :INT

        when text = scan(/String/)
          emit :STRING

        when text = scan(/System\.out\.println/)
          emit :PRINTLN

        when text = scan(/\{/)
          emit :LBRACE

        when text = scan(/\}/)
          emit :RBRACE

        when text = scan(/;/)
          emit :SEMICOLON

        when text = scan(/,/)
          emit :COMMA

        when text = scan(/\(/)
          emit :LPAREN

        when text = scan(/\)/)
          emit :RPAREN

        when text = scan(/\[/)
          emit :LBRACKET

        when text = scan(/\]/)
          emit :RBRACKET

        when text = scan(/\./)
          emit :DOT

        when text = scan(/\!/)
          emit :NOT

        when text = scan(/\*/)
          emit :STAR

        when text = scan(/\+/)
          emit :PLUS

        when text = scan(/-/)
          emit :MINUS

        when text = scan(/</)
          emit :LT

        when text = scan(/&&/)
          emit :AND

        when text = scan(/=/)
          emit :EQUAL

        when text = scan(/[a-zA-Z_][a-zA-Z0-9_]*/)
          emit :IDENTIFIER, text

        when text = scan(/0(?![1-9]+)|[1-9][0-9]*/)
          emit :INT_LITERAL, Integer(text)

        when text = scan(/[ \r\n\t\f]+/)
          nil

        when text = scan(/\/\*.*?\*\/|\/\*\*+\/|\/\/[^\r\n]*/)
          nil

        when text = scan(/./)
          raise ParseError, "Illegal character '#{text}' on line #{@line}"
        end
      end

      def emit(name, value = nil)
        [name, value]
      end
  end
end
