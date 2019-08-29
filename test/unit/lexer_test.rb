require "test_helper"

class MiniJava::LexerTest < Minitest::Test
  def test_scanning_keywords
    lexer = MiniJava::Lexer.new(<<~JAVA)
      boolean
      int
      true
      System.out.println
    JAVA

    assert_equal [ :BOOLEAN, nil ], lexer.next_token
    assert_equal [ :INT,     nil ], lexer.next_token
    assert_equal [ :TRUE,    nil ], lexer.next_token
    assert_equal [ :PRINTLN, nil ], lexer.next_token
  end

  def test_scanning_identifiers
    lexer = MiniJava::Lexer.new(<<~JAVA)
      asdf
      snake_case
      camelCase
      PascalCase
      foo123
      123bar
    JAVA

    assert_equal [ :IDENTIFIER,      "asdf"       ], lexer.next_token
    assert_equal [ :IDENTIFIER,      "snake_case" ], lexer.next_token
    assert_equal [ :IDENTIFIER,      "camelCase"  ], lexer.next_token
    assert_equal [ :IDENTIFIER,      "PascalCase" ], lexer.next_token
    assert_equal [ :IDENTIFIER,      "foo123"     ], lexer.next_token
    assert_equal [ :DECIMAL_NUMERAL, "123"        ], lexer.next_token
    assert_equal [ :IDENTIFIER,      "bar"        ], lexer.next_token
  end

  def test_scanning_decimal_numerals
    lexer = MiniJava::Lexer.new(<<~JAVA)
      0
      100
      123
      37
      03
    JAVA

    assert_equal [ :DECIMAL_NUMERAL, "0"   ], lexer.next_token
    assert_equal [ :DECIMAL_NUMERAL, "100" ], lexer.next_token
    assert_equal [ :DECIMAL_NUMERAL, "123" ], lexer.next_token
    assert_equal [ :DECIMAL_NUMERAL, "37"  ], lexer.next_token

    error = assert_raises(MiniJava::SyntaxError) { lexer.next_token }
    assert_equal "Unexpected token '03' at line 5, column 1", error.message
  end

  def test_scanning_an_invalid_character
    lexer = MiniJava::Lexer.new("foo\nbar\n123\n ^")

    assert_equal [ :IDENTIFIER,      "foo" ], lexer.next_token
    assert_equal [ :IDENTIFIER,      "bar" ], lexer.next_token
    assert_equal [ :DECIMAL_NUMERAL, "123" ], lexer.next_token

    error = assert_raises(MiniJava::SyntaxError) { lexer.next_token }
    assert_equal "Unexpected token '^' at line 4, column 2", error.message
  end

  def test_ignoring_single_line_comments
    lexer = MiniJava::Lexer.new(<<~JAVA)
      foo;
      bar;
      // baz
      glorp;
    JAVA

    %w[ foo bar glorp ].each do |identifier|
      assert_equal [ :IDENTIFIER, identifier ], lexer.next_token
      assert_equal [ :SEMICOLON, nil ], lexer.next_token
    end

    assert_equal 4, lexer.line
  end

  def test_counting_lines_through_code
    lexer = MiniJava::Lexer.new("foo;\nbar;\rbaz;\r\nglorp;")

    assert_equal 1, lexer.line

    %w[ foo bar baz glorp ].each_with_index do |identifier, index|
      assert_equal [ :IDENTIFIER, identifier ], lexer.next_token
      assert_equal [ :SEMICOLON, nil ], lexer.next_token
      assert_equal index + 1, lexer.line
    end
  end

  def test_counting_columns_through_code
    lexer = MiniJava::Lexer.new(<<~JAVA)
      foo bar
        baz      glorp  123
      quux
    JAVA

    assert_equal 1, lexer.column

    assert_equal [ :IDENTIFIER, "foo" ], lexer.next_token
    assert_equal 1, lexer.column

    assert_equal [ :IDENTIFIER, "bar" ], lexer.next_token
    assert_equal 5, lexer.column

    assert_equal [ :IDENTIFIER, "baz" ], lexer.next_token
    assert_equal 3, lexer.column

    assert_equal [ :IDENTIFIER, "glorp" ], lexer.next_token
    assert_equal 12, lexer.column

    assert_equal [ :DECIMAL_NUMERAL, "123" ], lexer.next_token
    assert_equal 19, lexer.column

    assert_equal [ :IDENTIFIER, "quux" ], lexer.next_token
    assert_equal 1, lexer.column
  end

  def test_counting_lines_through_multiline_comments
    lexer = MiniJava::Lexer.new(<<~JAVA)
      foo;
      bar;
      /**
       * baz
       * glorp\r

       */
      quux;
    JAVA

    { "foo" => 1, "bar" => 2, "quux" => 8 }.each do |identifier, line|
      assert_equal [ :IDENTIFIER, identifier ], lexer.next_token
      assert_equal [ :SEMICOLON, nil ], lexer.next_token
      assert_equal line, lexer.line
    end
  end
end
