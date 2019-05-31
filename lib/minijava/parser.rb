#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.15
# from Racc grammer file "".
#

require 'racc/parser.rb'

require "minijava/lexer"
require "minijava/syntax"
require "active_support/core_ext/module/delegation"

module MiniJava
  class Parser < Racc::Parser

module_eval(<<'...end parser.racc/module_eval...', 'parser.racc', 109)
delegate :next_token, :line, to: :@lexer

def self.program_from(source)
  new(source).program
end

def initialize(source)
  @lexer = MiniJava::Lexer.new(source)
end

def on_error(*)
  $stderr.puts "Parse error on line #{line}"
end

alias_method :program, :do_parse
...end parser.racc/module_eval...
##### State transition tables begin ###

racc_action_table = [
    81,    27,    28,   100,    61,    80,    81,    27,    28,    27,
    28,    80,    81,    60,     7,   117,     7,    80,    81,    61,
     7,     7,     7,    80,    81,    98,    88,    99,    60,    80,
     4,    74,    75,    76,    78,    79,     7,    74,    75,    76,
    78,    79,     7,    74,    75,    76,    78,    79,     7,    74,
    75,    76,    78,    79,     7,    74,    75,    76,    78,    79,
     7,    81,    27,    28,    15,     7,    80,    81,    98,     8,
    99,    16,    80,    81,    10,     7,    11,     7,    80,    81,
    14,    17,    18,     7,    80,    81,    22,    98,    23,    99,
    80,    97,    74,    75,    76,    78,    79,     7,    74,    75,
    76,    78,    79,     7,    74,    75,    76,    78,    79,     7,
    74,    75,    76,    78,    79,     7,    74,    75,    76,    78,
    79,     7,    81,    30,    31,    34,     7,    80,    81,    36,
    38,    39,    41,    80,    81,    42,    43,    44,     7,    80,
    81,    48,    56,    57,    58,    80,    81,    59,    98,    65,
    99,    80,    97,    74,    75,    76,    78,    79,     7,    74,
    75,    76,    78,    79,     7,    74,    75,    76,    78,    79,
     7,    74,    75,    76,    78,    79,     7,    74,    75,    76,
    78,    79,     7,    81,    66,    67,    52,     7,    80,    81,
    52,    84,     3,    89,    80,    81,     7,    91,   110,    53,
    80,    54,    55,    53,   119,    54,    55,   120,   122,     7,
   125,   128,   130,     7,    74,    75,    76,    78,    79,     7,
    74,    75,    76,    78,    79,     7,    74,    75,    76,    78,
    79,     7,    52,    98,   132,    99,    52,    97,    95,    96,
    94,    52,    27,    28,   133,    53,   141,    54,    55,    53,
    52,    54,    55,   nil,    53,     7,    54,    55,   nil,     7,
   nil,   nil,   nil,    53,     7,    54,    55,    52,   nil,   nil,
    98,   nil,    99,     7,    97,    95,    96,    94,    93,   nil,
    53,   nil,    54,    55,   nil,   nil,   nil,   nil,   nil,   nil,
     7,   nil,    98,   140,    99,   nil,    97,    95,    96,    94,
    93,    98,   nil,    99,   nil,    97,    95,    96,    94,    93,
    98,   138,    99,   nil,    97,    95,    96,    94,    93,   nil,
    92,   nil,   nil,   nil,   nil,   108,    98,   nil,    99,   104,
    97,    95,    96,    94,    93,   107,    98,   nil,    99,   nil,
    97,    95,    96,    94,    93,   106,    98,   nil,    99,   nil,
    97,    95,    96,    94,    93,   121,    98,   nil,    99,   nil,
    97,    95,    96,    94,    93,    98,   137,    99,   nil,    97,
    95,    96,    94,    93,    98,   127,    99,   nil,    97,    95,
    96,    94,    93,    98,   105,    99,   nil,    97,    95,    96,
    94,    93,    98,   nil,    99,   nil,    97,    95,    96 ]

racc_action_check = [
    96,    57,    57,    79,    63,    96,    67,    34,    34,    20,
    20,    67,   140,    63,    57,    99,    79,   140,    66,    50,
    34,    99,    20,    66,   128,   102,    68,   102,    50,   128,
     1,    96,    96,    96,    96,    96,    96,    67,    67,    67,
    67,    67,    67,   140,   140,   140,   140,   140,   140,    66,
    66,    66,    66,    66,    66,   128,   128,   128,   128,   128,
   128,    80,    89,    89,    12,     3,    80,    81,   115,     4,
   115,    12,    81,    65,     5,    89,     6,    10,    65,   122,
    11,    13,    14,    16,   122,   119,    18,   113,    19,   113,
   119,   113,    80,    80,    80,    80,    80,    80,    81,    81,
    81,    81,    81,    81,    65,    65,    65,    65,    65,    65,
   122,   122,   122,   122,   122,   122,   119,   119,   119,   119,
   119,   119,    61,    21,    22,    24,    26,    61,    60,    27,
    31,    33,    35,    60,    59,    36,    37,    38,    40,    59,
    98,    44,    46,    47,    48,    98,    93,    49,   114,    53,
   114,    93,   114,    61,    61,    61,    61,    61,    61,    60,
    60,    60,    60,    60,    60,    59,    59,    59,    59,    59,
    59,    98,    98,    98,    98,    98,    98,    93,    93,    93,
    93,    93,    93,    94,    54,    55,    52,    58,    94,    95,
   106,    64,     0,    70,    95,    97,    71,    72,    91,    52,
    97,    52,    52,   106,   100,   106,   106,   101,   105,    52,
   108,   118,   120,   106,    94,    94,    94,    94,    94,    94,
    95,    95,    95,    95,    95,    95,    97,    97,    97,    97,
    97,    97,    45,   111,   123,   111,   107,   111,   111,   111,
   111,   110,    45,    45,   126,    45,   135,    45,    45,   107,
   132,   107,   107,   nil,   110,    45,   110,   110,   nil,   107,
   nil,   nil,   nil,   132,   110,   132,   132,    51,   nil,   nil,
   134,   nil,   134,   132,   134,   134,   134,   134,   134,   nil,
    51,   nil,    51,    51,   nil,   nil,   nil,   nil,   nil,   nil,
    51,   nil,   131,   134,   131,   nil,   131,   131,   131,   131,
   131,    73,   nil,    73,   nil,    73,    73,    73,    73,    73,
    82,   131,    82,   nil,    82,    82,    82,    82,    82,   nil,
    73,   nil,   nil,   nil,   nil,    87,    87,   nil,    87,    82,
    87,    87,    87,    87,    87,    86,    86,   nil,    86,   nil,
    86,    86,    86,    86,    86,    85,    85,   nil,    85,   nil,
    85,    85,    85,    85,    85,   103,   103,   nil,   103,   nil,
   103,   103,   103,   103,   103,   129,   129,   129,   nil,   129,
   129,   129,   129,   129,   116,   116,   116,   nil,   116,   116,
   116,   116,   116,    83,    83,    83,   nil,    83,    83,    83,
    83,    83,   112,   nil,   112,   nil,   112,   112,   112 ]

racc_action_pointer = [
   178,    30,   nil,    27,    69,    60,    61,   nil,   nil,   nil,
    39,    63,    49,    65,    64,   nil,    45,   nil,    67,    72,
   -16,   108,   104,   nil,   108,   nil,    88,   125,   nil,   nil,
   nil,   128,   nil,   116,   -18,   109,   130,   120,   116,   nil,
   100,   nil,   nil,   nil,   137,   217,   126,   141,   139,   123,
    15,   252,   171,   147,   182,   183,   nil,   -24,   149,   132,
   126,   120,   nil,     0,   175,    71,    16,     4,    23,   nil,
   166,   158,   194,   297,   nil,   nil,   nil,   nil,   nil,   -22,
    59,    65,   306,   379,   nil,   342,   332,   322,   nil,    37,
   nil,   183,   nil,   144,   181,   187,    -2,   193,   138,   -17,
   200,   205,    21,   352,   nil,   195,   175,   221,   187,   nil,
   226,   229,   388,    83,   144,    64,   370,   nil,   209,    83,
   209,   nil,    77,   205,   nil,   nil,   228,   nil,    22,   361,
   nil,   288,   235,   nil,   266,   243,   nil,   nil,   nil,   nil,
    10,   nil,   nil ]

racc_action_default = [
   -56,   -56,    -4,   -56,   -56,    -1,   -56,   -55,   143,    -5,
   -56,   -56,   -56,   -56,   -56,    -9,   -56,    -2,   -56,   -56,
   -12,   -56,   -56,    -6,    -8,   -10,   -56,   -19,   -18,   -20,
    -9,   -56,   -13,   -56,   -56,   -56,   -56,   -56,   -56,    -9,
   -56,   -11,   -17,    -7,   -56,   -26,   -56,   -56,   -56,   -56,
   -20,   -26,   -26,   -56,   -56,   -56,   -14,   -21,   -56,   -56,
   -56,   -56,   -27,   -56,   -56,   -56,   -56,   -56,   -56,   -22,
   -23,   -56,   -56,   -56,   -42,   -43,   -44,   -45,   -46,   -56,
   -56,   -56,   -56,   -56,   -28,   -56,   -56,   -56,   -15,   -56,
   -25,   -56,   -16,   -56,   -56,   -56,   -56,   -56,   -56,   -56,
   -56,   -56,   -49,   -56,   -32,   -56,   -56,   -56,   -56,   -24,
   -56,   -34,   -35,   -36,   -37,   -38,   -56,   -40,   -56,   -56,
   -56,   -50,   -56,   -56,   -30,   -31,   -56,   -39,   -51,   -56,
   -48,   -56,   -56,    -3,   -53,   -56,   -52,   -47,   -33,   -29,
   -56,   -41,   -54 ]

racc_goto_table = [
     6,    40,    69,    19,   123,   124,    45,    12,   126,   136,
    24,    13,    32,    21,    33,    46,    68,    29,    37,    49,
     5,   142,     2,    35,    71,    62,    64,   135,     9,     1,
   139,    29,   nil,   nil,   109,   nil,   nil,    47,   nil,   nil,
   nil,   nil,    50,   nil,   nil,    73,    82,    83,    63,    63,
   nil,    85,    86,    87,    29,    72,    71,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   102,   103,    90,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   101,   nil,   nil,   111,
   112,   113,   114,   115,   116,   nil,    29,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   118,   nil,   nil,   nil,
   nil,   nil,   nil,    63,    63,   129,   nil,    63,   131,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,    63 ]

racc_goto_check = [
     4,    12,    19,     8,     6,     6,     9,     4,     6,    22,
    10,     5,    13,     4,    14,    15,    16,     4,     8,    17,
     3,    22,     2,     4,    12,    17,    17,    21,     7,     1,
     6,     4,   nil,   nil,    19,   nil,   nil,     4,   nil,   nil,
   nil,   nil,     4,   nil,   nil,    18,    18,    18,     4,     4,
   nil,    18,    18,    18,     4,     4,    12,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,    18,    18,     4,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,     4,   nil,   nil,    18,
    18,    18,    18,    18,    18,   nil,     4,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,     4,   nil,   nil,   nil,
   nil,   nil,   nil,     4,     4,    18,   nil,     4,    18,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,     4 ]

racc_goto_pointer = [
   nil,    29,    22,    18,    -3,     0,  -102,    23,   -12,   -33,
   -10,   nil,   -33,   -12,   -10,   -24,   -41,   -26,   -14,   -55,
   nil,  -101,  -119 ]

racc_goto_default = [
   nil,   nil,   nil,   nil,    77,   nil,    51,   nil,   nil,    20,
   nil,    25,    26,   nil,   nil,   nil,   nil,   nil,   134,   nil,
    70,   nil,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  2, 40, :_reduce_1,
  5, 41, :_reduce_2,
  13, 44, :_reduce_3,
  0, 42, :_reduce_4,
  2, 42, :_reduce_5,
  5, 46, :_reduce_6,
  7, 46, :_reduce_7,
  2, 47, :_reduce_none,
  0, 48, :_reduce_9,
  2, 48, :_reduce_10,
  3, 50, :_reduce_11,
  0, 49, :_reduce_12,
  2, 49, :_reduce_13,
  4, 52, :_reduce_14,
  6, 53, :_reduce_15,
  5, 54, :_reduce_16,
  3, 51, :_reduce_17,
  1, 51, :_reduce_18,
  1, 51, :_reduce_19,
  1, 51, :_reduce_20,
  0, 55, :_reduce_21,
  1, 55, :_reduce_22,
  1, 58, :_reduce_23,
  3, 58, :_reduce_24,
  2, 59, :_reduce_25,
  0, 56, :_reduce_26,
  2, 56, :_reduce_27,
  3, 45, :_reduce_28,
  7, 45, :_reduce_29,
  5, 45, :_reduce_30,
  5, 45, :_reduce_31,
  4, 45, :_reduce_32,
  7, 45, :_reduce_33,
  3, 57, :_reduce_34,
  3, 57, :_reduce_35,
  3, 57, :_reduce_36,
  3, 57, :_reduce_37,
  3, 57, :_reduce_38,
  4, 57, :_reduce_39,
  3, 57, :_reduce_40,
  6, 57, :_reduce_41,
  1, 57, :_reduce_42,
  1, 57, :_reduce_43,
  1, 57, :_reduce_44,
  1, 57, :_reduce_45,
  1, 57, :_reduce_46,
  5, 57, :_reduce_47,
  4, 57, :_reduce_48,
  2, 57, :_reduce_49,
  3, 57, :_reduce_50,
  0, 60, :_reduce_51,
  1, 60, :_reduce_52,
  1, 61, :_reduce_53,
  3, 61, :_reduce_54,
  1, 43, :_reduce_55 ]

racc_reduce_n = 56

racc_shift_n = 143

racc_token_table = {
  false => 0,
  :error => 1,
  :LPAREN => 2,
  :RPAREN => 3,
  :LBRACKET => 4,
  :RBRACKET => 5,
  :DOT => 6,
  :NOT => 7,
  :STAR => 8,
  :PLUS => 9,
  :MINUS => 10,
  :LT => 11,
  :AND => 12,
  :EQUAL => 13,
  :CLASS => 14,
  :LBRACE => 15,
  :RBRACE => 16,
  :PUBLIC => 17,
  :STATIC => 18,
  :VOID => 19,
  :MAIN => 20,
  :STRING => 21,
  :EXTENDS => 22,
  :SEMICOLON => 23,
  :RETURN => 24,
  :INT => 25,
  :BOOLEAN => 26,
  :COMMA => 27,
  :IF => 28,
  :ELSE => 29,
  :WHILE => 30,
  :PRINTLN => 31,
  :LENGTH => 32,
  :INT_LITERAL => 33,
  :TRUE => 34,
  :FALSE => 35,
  :THIS => 36,
  :NEW => 37,
  :IDENTIFIER => 38 }

racc_nt_base = 39

racc_use_result_var = false

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "LPAREN",
  "RPAREN",
  "LBRACKET",
  "RBRACKET",
  "DOT",
  "NOT",
  "STAR",
  "PLUS",
  "MINUS",
  "LT",
  "AND",
  "EQUAL",
  "CLASS",
  "LBRACE",
  "RBRACE",
  "PUBLIC",
  "STATIC",
  "VOID",
  "MAIN",
  "STRING",
  "EXTENDS",
  "SEMICOLON",
  "RETURN",
  "INT",
  "BOOLEAN",
  "COMMA",
  "IF",
  "ELSE",
  "WHILE",
  "PRINTLN",
  "LENGTH",
  "INT_LITERAL",
  "TRUE",
  "FALSE",
  "THIS",
  "NEW",
  "IDENTIFIER",
  "$start",
  "Program",
  "MainClassDeclaration",
  "ClassDeclarations",
  "Identifier",
  "MainMethodDeclaration",
  "Statement",
  "ClassDeclaration",
  "ClassBody",
  "VariableDeclarations",
  "MethodDeclarations",
  "VariableDeclaration",
  "Type",
  "MethodDeclaration",
  "MethodSignature",
  "MethodBody",
  "FormalParameters",
  "Statements",
  "Expression",
  "OneOrMoreFormalParameters",
  "FormalParameter",
  "ActualParameters",
  "OneOrMoreActualParameters" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'parser.racc', 17)
  def _reduce_1(val, _values)
     MiniJava::Syntax::Program.new(val[0], val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 20)
  def _reduce_2(val, _values)
     MiniJava::Syntax::MainClassDeclaration.new(val[1], val[3]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 25)
  def _reduce_3(val, _values)
     MiniJava::Syntax::MainMethodDeclaration.new(val[8], val[11]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 27)
  def _reduce_4(val, _values)
     [] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 27)
  def _reduce_5(val, _values)
     val[0].append(val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 30)
  def _reduce_6(val, _values)
     MiniJava::Syntax::ClassDeclaration.new(val[1], *val[3]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 32)
  def _reduce_7(val, _values)
     MiniJava::Syntax::SubclassDeclaration.new(val[1], val[3], *val[5]) 
  end
.,.,

# reduce 8 omitted

module_eval(<<'.,.,', 'parser.racc', 35)
  def _reduce_9(val, _values)
     [] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 35)
  def _reduce_10(val, _values)
     val[0].append(val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 36)
  def _reduce_11(val, _values)
     MiniJava::Syntax::VariableDeclaration.new(val[0], val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 38)
  def _reduce_12(val, _values)
     [] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 38)
  def _reduce_13(val, _values)
     val[0].append(val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 42)
  def _reduce_14(val, _values)
     MiniJava::Syntax::MethodDeclaration.new(*val[0], *val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 43)
  def _reduce_15(val, _values)
     [ val[1], val[2], val[4] ] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 47)
  def _reduce_16(val, _values)
     [ val[0], val[1], val[3] ] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 50)
  def _reduce_17(val, _values)
     MiniJava::Syntax::ARRAY_TYPE 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 51)
  def _reduce_18(val, _values)
     MiniJava::Syntax::BOOLEAN_TYPE 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 52)
  def _reduce_19(val, _values)
     MiniJava::Syntax::INTEGER_TYPE 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 53)
  def _reduce_20(val, _values)
     MiniJava::Syntax::IdentifierType.new(val[0]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 55)
  def _reduce_21(val, _values)
     [] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 55)
  def _reduce_22(val, _values)
     val[0] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 58)
  def _reduce_23(val, _values)
     [ val[0] ] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 59)
  def _reduce_24(val, _values)
     val[1].prepend(val[0]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 61)
  def _reduce_25(val, _values)
     MiniJava::Syntax::FormalParameter.new(val[0], val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 63)
  def _reduce_26(val, _values)
     [] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 63)
  def _reduce_27(val, _values)
     val[1].prepend(val[0]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 66)
  def _reduce_28(val, _values)
     MiniJava::Syntax::Block.new(val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 67)
  def _reduce_29(val, _values)
     MiniJava::Syntax::IfStatement.new(val[2], val[4], val[6]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 68)
  def _reduce_30(val, _values)
     MiniJava::Syntax::WhileStatement.new(val[2], val[4]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 69)
  def _reduce_31(val, _values)
     MiniJava::Syntax::PrintStatement.new(val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 70)
  def _reduce_32(val, _values)
     MiniJava::Syntax::Assignment.new(val[0], val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 72)
  def _reduce_33(val, _values)
     MiniJava::Syntax::ArrayAssignment.new(val[0], val[2], val[5]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 75)
  def _reduce_34(val, _values)
     MiniJava::Syntax::And.new(val[0], val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 76)
  def _reduce_35(val, _values)
     MiniJava::Syntax::LessThan.new(val[0], val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 77)
  def _reduce_36(val, _values)
     MiniJava::Syntax::Plus.new(val[0], val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 78)
  def _reduce_37(val, _values)
     MiniJava::Syntax::Minus.new(val[0], val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 79)
  def _reduce_38(val, _values)
     MiniJava::Syntax::Times.new(val[0], val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 80)
  def _reduce_39(val, _values)
     MiniJava::Syntax::ArraySubscript.new(val[0], val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 81)
  def _reduce_40(val, _values)
     MiniJava::Syntax::ArrayLength.new(val[0]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 82)
  def _reduce_41(val, _values)
     MiniJava::Syntax::Call.new(val[0], val[2], val[4]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 83)
  def _reduce_42(val, _values)
     MiniJava::Syntax::IntegerLiteral.new(val[0]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 84)
  def _reduce_43(val, _values)
     MiniJava::Syntax::TRUE_LITERAL 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 85)
  def _reduce_44(val, _values)
     MiniJava::Syntax::FALSE_LITERAL 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 86)
  def _reduce_45(val, _values)
     val[0] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 87)
  def _reduce_46(val, _values)
     MiniJava::Syntax::THIS 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 88)
  def _reduce_47(val, _values)
     MiniJava::Syntax::NewArray.new(val[3]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 89)
  def _reduce_48(val, _values)
     MiniJava::Syntax::NewObject.new(val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 90)
  def _reduce_49(val, _values)
     MiniJava::Syntax::Not.new(val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 91)
  def _reduce_50(val, _values)
     val[1] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 93)
  def _reduce_51(val, _values)
     [] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 93)
  def _reduce_52(val, _values)
     val[0] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 96)
  def _reduce_53(val, _values)
     [ val[0] ] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 97)
  def _reduce_54(val, _values)
     val[1].prepend(val[0]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 99)
  def _reduce_55(val, _values)
     MiniJava::Syntax::Identifier.new(val[0]) 
  end
.,.,

def _reduce_none(val, _values)
  val[0]
end

  end   # class Parser
  end   # module MiniJava
