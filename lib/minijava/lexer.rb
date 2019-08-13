require "strscan"
require "active_support/core_ext/module/delegation"
require "minijava/errors"

module MiniJava
  class Lexer
    attr_reader :line

    def initialize(source)
      @scanner = StringScanner.new(source)
      @state   = :default
      @line    = 1
    end

    def next_token
      loop do
        if token = scan_next_token
          return token
        end

        return nil if eos?
      end
    end

    private
      attr_reader :scanner
      delegate :scan, :eos?, to: :scanner

      def scan_next_token
        consume_newlines
        consume_inline_whitespace
        consume_next_token
      end

      def consume_newlines
        @line += 1 while scan(/([^\S\r\n]*)(\r|\n|\r\n)/)
      end

      def consume_inline_whitespace
        scan(/\s+/)
      end

      def consume_next_token
        case @state
        when :default
          case
          when scan(%r(/\*))
            @state = :comment
            nil

          when scan(%r(//.*))
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
            raise SyntaxError, "Illegal character '#{text}' on line #{@line}"
          end

        when :comment
          case
          when scan(%r(\*/))
            @state = :default
            nil

          when scan(%r([^\*]+|\*(?!/)))
            nil
          end
        end
      end

      def emit(name, value = nil)
        [name, value]
      end
  end
end
