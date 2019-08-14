require "test_helper"

class MiniJava::LexerTest < Minitest::Test
  def test_counting_lines_through_code
    lexer = MiniJava::Lexer.new("foo;\nbar;\rbaz;\r\nglorp;")

    %w[ foo bar baz glorp ].each_with_index do |identifier, index|
      assert_equal [ :IDENTIFIER, identifier ], lexer.next_token
      assert_equal [ :SEMICOLON, nil ], lexer.next_token
      assert_equal index + 1, lexer.line
    end
  end

  def test_counting_lines_through_comments
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

  def test_scanning_integer_literals
    lexer = MiniJava::Lexer.new(<<~JAVA)
      0
      100
      123
      37
      03
    JAVA

    assert_equal [ :INT_LITERAL,   0 ], lexer.next_token
    assert_equal [ :INT_LITERAL, 100 ], lexer.next_token
    assert_equal [ :INT_LITERAL, 123 ], lexer.next_token
    assert_equal [ :INT_LITERAL,  37 ], lexer.next_token

    error = assert_raises(MiniJava::SyntaxError) { lexer.next_token }
    assert_equal "Illegal character '0' on line 5", error.message
  end

  def test_scanning_an_invalid_character
    lexer = MiniJava::Lexer.new("foo\nbar\n123\n^")

    assert_equal [ :IDENTIFIER, "foo" ], lexer.next_token
    assert_equal [ :IDENTIFIER, "bar" ], lexer.next_token
    assert_equal [ :INT_LITERAL, 123 ],  lexer.next_token

    error = assert_raises(MiniJava::SyntaxError) { lexer.next_token }
    assert_equal "Illegal character '^' on line 4", error.message
  end
end
