require "test_helper"

class MiniJava::LexerTest < Minitest::Test
  def test_scanning_an_invalid_character
    lexer = MiniJava::Lexer.new("foo bar 123 ^")

    assert_equal [ :IDENTIFIER, "foo" ], lexer.next_token
    assert_equal [ :IDENTIFIER, "bar" ], lexer.next_token
    assert_equal [ :INT_LITERAL, 123 ],  lexer.next_token

    error = assert_raises(MiniJava::SyntaxError) { lexer.next_token }
    assert_equal "Illegal character '^' on line 1", error.message
  end
end
