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

module_eval(<<'...end parser.racc/module_eval...', 'parser.racc', 119)
delegate :next_token, :line, to: :@lexer

def self.program_from(source)
  new(source).program
end

def initialize(source)
  @lexer   = MiniJava::Lexer.new(source)
  @yydebug = !ENV["DEBUG"].nil?
end

def on_error(*)
  $stderr.puts "Parse error on line #{line}"
end

alias_method :program, :do_parse
...end parser.racc/module_eval...
##### State transition tables begin ###

racc_action_table = [
   -23,    36,   117,    39,    78,    94,    29,    30,     7,    63,
    71,    11,    78,   107,    93,    70,    92,    37,     7,     7,
    63,    71,    48,    58,    10,    93,    70,    92,    17,    91,
    89,    90,    88,    87,    58,    18,    59,   -23,    60,    61,
     7,    66,    67,    68,    69,    73,     7,    59,   148,    60,
    61,    47,    66,    67,    68,    69,    73,     7,    63,    71,
    29,    30,    46,    44,    70,    29,    30,    29,    30,    63,
    71,    43,    58,     7,    93,    70,    92,    93,     7,    92,
     7,    91,    93,    58,    92,    59,    91,    60,    61,    42,
    66,    67,    68,    69,    73,     7,    59,    40,    60,    61,
    33,    66,    67,    68,    69,    73,     7,    63,    71,    32,
    93,    25,    92,    70,    91,    89,    90,    88,    87,    63,
    71,    58,    93,   120,    92,    70,    91,    89,    90,   128,
   121,    29,    30,    58,    59,   150,    60,    61,   123,    66,
    67,    68,    69,    73,     7,    71,    59,   124,    60,    61,
    70,    66,    67,    68,    69,    73,     7,    63,    71,     7,
   126,    24,     7,    70,    71,     7,     4,     3,    20,    70,
    71,    58,   133,    19,   136,    70,    66,    67,    68,    69,
    73,     7,   138,    71,    59,    16,    60,    61,    70,    66,
    67,    68,    69,    73,     7,    66,    67,    68,    69,    73,
     7,    66,    67,    68,    69,    73,     7,    71,    14,   141,
     7,    12,    70,   147,    66,    67,    68,    69,    73,     7,
    71,     8,   149,    77,    76,    70,    71,    83,    82,    84,
    85,    70,    71,    86,    75,    74,    54,    70,    66,    67,
    68,    69,    73,     7,    71,     7,     7,    50,    49,    70,
   nil,    66,    67,    68,    69,    73,     7,    66,    67,    68,
    69,    73,     7,    66,    67,    68,    69,    73,     7,    71,
   nil,   nil,   nil,   nil,    70,    66,    67,    68,    69,    73,
     7,    71,   nil,   nil,   nil,   nil,    70,    71,   nil,   nil,
   nil,   nil,    70,    71,   nil,   nil,   nil,   nil,    70,   nil,
    66,    67,    68,    69,    73,     7,    71,   nil,   nil,   nil,
   nil,    70,    66,    67,    68,    69,    73,     7,    66,    67,
    68,    69,    73,     7,    66,    67,    68,    69,    73,     7,
    71,   nil,   nil,   nil,   nil,    70,   nil,    66,    67,    68,
    69,    73,     7,    71,   nil,   nil,   nil,   nil,    70,    71,
   nil,    93,   nil,    92,    70,    91,    89,    90,    88,    87,
   nil,    66,    67,    68,    69,    73,     7,   nil,   nil,   nil,
   127,   nil,   nil,   nil,    66,    67,    68,    69,    73,     7,
    66,    67,    68,    69,    73,     7,    93,   nil,    92,   nil,
    91,    89,    90,    88,    87,   131,    93,   nil,    92,   nil,
    91,    89,    90,    88,    87,   132,   122,    93,   nil,    92,
   nil,    91,    89,    90,    88,    87,   129,    93,   nil,    92,
   nil,    91,    89,    90,    88,    87,   130,    93,   nil,    92,
   nil,    91,    89,    90,    88,    87,    93,   134,    92,   nil,
    91,    89,    90,    88,    87,    93,   145,    92,   nil,    91,
    89,    90,    88,    87,    93,   nil,    92,   nil,    91,    89,
    90,    88,    87,    93,   nil,    92,   nil,    91,    89,    90,
    88 ]

racc_action_check = [
    56,    26,    92,    28,    80,    69,    22,    22,    92,   147,
   147,     5,    56,    81,    96,   147,    96,    26,    69,    22,
   138,   138,    40,   147,     5,   142,   138,   142,    13,   142,
   142,   142,   142,   142,   138,    13,   147,    56,   147,   147,
    28,   147,   147,   147,   147,   147,   147,   138,   142,   138,
   138,    39,   138,   138,   138,   138,   138,   138,   130,   130,
    37,    37,    38,    36,   130,    75,    75,   124,   124,   129,
   129,    35,   130,    37,   116,   129,   116,   115,    75,   115,
   124,   115,   114,   129,   114,   130,   114,   130,   130,    33,
   130,   130,   130,   130,   130,   130,   129,    29,   129,   129,
    24,   129,   129,   129,   129,   129,   129,    51,    51,    23,
   106,    21,   106,    51,   106,   106,   106,   106,   106,    58,
    58,    51,   113,    94,   113,    58,   113,   113,   113,   106,
    95,    51,    51,    58,    51,   146,    51,    51,   100,    51,
    51,    51,    51,    51,    51,    77,    58,   102,    58,    58,
    77,    58,    58,    58,    58,    58,    58,    57,    57,   103,
   104,    20,    18,    57,    84,     3,     1,     0,    16,    84,
    83,    57,   118,    15,   121,    83,    77,    77,    77,    77,
    77,    77,   126,    82,    57,    12,    57,    57,    82,    57,
    57,    57,    57,    57,    57,    84,    84,    84,    84,    84,
    84,    83,    83,    83,    83,    83,    83,    78,    11,   131,
    10,     6,    78,   139,    82,    82,    82,    82,    82,    82,
   148,     4,   143,    55,    54,   148,   133,    60,    59,    61,
    62,   133,    71,    63,    53,    52,    50,    71,    78,    78,
    78,    78,    78,    78,    93,    45,    76,    42,    41,    93,
   nil,   148,   148,   148,   148,   148,   148,   133,   133,   133,
   133,   133,   133,    71,    71,    71,    71,    71,    71,   120,
   nil,   nil,   nil,   nil,   120,    93,    93,    93,    93,    93,
    93,    91,   nil,   nil,   nil,   nil,    91,    90,   nil,   nil,
   nil,   nil,    90,    70,   nil,   nil,   nil,   nil,    70,   nil,
   120,   120,   120,   120,   120,   120,    89,   nil,   nil,   nil,
   nil,    89,    91,    91,    91,    91,    91,    91,    90,    90,
    90,    90,    90,    90,    70,    70,    70,    70,    70,    70,
    88,   nil,   nil,   nil,   nil,    88,   nil,    89,    89,    89,
    89,    89,    89,    87,   nil,   nil,   nil,   nil,    87,    85,
   nil,   105,   nil,   105,    85,   105,   105,   105,   105,   105,
   nil,    88,    88,    88,    88,    88,    88,   nil,   nil,   nil,
   105,   nil,   nil,   nil,    87,    87,    87,    87,    87,    87,
    85,    85,    85,    85,    85,    85,   111,   nil,   111,   nil,
   111,   111,   111,   111,   111,   110,   110,   nil,   110,   nil,
   110,   110,   110,   110,   110,   111,    99,    99,   nil,    99,
   nil,    99,    99,    99,    99,    99,   108,   108,   nil,   108,
   nil,   108,   108,   108,   108,   108,   109,   109,   nil,   109,
   nil,   109,   109,   109,   109,   109,   119,   119,   119,   nil,
   119,   119,   119,   119,   119,   135,   135,   135,   nil,   135,
   135,   135,   135,   135,    64,   nil,    64,   nil,    64,    64,
    64,    64,    64,   112,   nil,   112,   nil,   112,   112,   112,
   112 ]

racc_action_pointer = [
   153,   166,   nil,   127,   221,    10,   196,   nil,   nil,   nil,
   172,   192,   168,    13,   nil,   157,   150,   nil,   124,   nil,
   142,    95,   -19,    94,    80,   nil,     0,   nil,     2,    93,
   nil,   nil,   nil,    87,   nil,    56,    47,    35,    39,    28,
    17,   232,   226,   nil,   nil,   207,   nil,   nil,   nil,   nil,
   232,   106,   219,   232,   219,   199,    -1,   156,   118,   226,
   225,   227,   217,   210,   450,   nil,   nil,   nil,   nil,   -20,
   291,   230,   nil,   nil,   nil,    40,   208,   143,   205,   nil,
    -9,    -3,   181,   168,   162,   347,   nil,   341,   328,   304,
   285,   279,   -30,   242,   119,   128,    10,   nil,   nil,   403,
   135,   nil,   120,   121,   157,   347,   106,   nil,   413,   423,
   392,   382,   459,   118,    78,    73,    70,   nil,   170,   432,
   267,   171,   nil,   nil,    42,   nil,   167,   nil,   nil,    68,
    57,   186,   nil,   224,   nil,   441,   nil,   nil,    19,   184,
   nil,   nil,    21,   219,   nil,   nil,   119,     8,   218,   nil,
   nil,   nil,   nil ]

racc_action_default = [
   -63,   -63,    -4,   -63,   -63,    -1,   -63,   -62,   153,    -5,
   -63,   -63,   -63,   -63,    -8,   -63,   -63,   -10,   -63,    -2,
   -63,   -63,   -14,   -63,   -63,    -6,    -9,   -11,   -63,   -22,
   -21,   -23,   -10,   -63,   -15,   -63,   -63,   -63,   -63,   -63,
   -63,   -63,   -63,   -10,   -17,   -63,   -12,   -13,   -20,    -7,
   -63,   -29,   -63,   -63,   -63,   -63,   -49,   -29,   -29,   -63,
   -63,   -63,   -43,   -63,   -63,   -46,   -47,   -48,   -50,   -63,
   -63,   -63,   -60,   -61,   -16,   -24,   -63,   -63,   -63,   -30,
   -49,   -63,   -63,   -63,   -63,   -63,   -37,   -63,   -63,   -63,
   -63,   -63,   -63,   -63,   -63,   -63,   -53,   -43,   -49,   -63,
   -63,   -25,   -26,   -63,   -63,   -63,   -63,   -31,   -63,   -63,
   -63,   -63,   -38,   -39,   -40,   -41,   -42,   -44,   -63,   -63,
   -63,   -63,   -54,   -18,   -63,   -28,   -63,   -19,   -35,   -63,
   -63,   -63,   -36,   -56,   -55,   -63,   -52,   -27,   -63,   -63,
   -33,   -34,   -58,   -63,   -57,   -51,   -63,   -63,   -63,   -45,
    -3,   -32,   -59 ]

racc_goto_table = [
     6,    45,   144,    62,   101,   139,   140,    13,    26,    62,
    62,    21,     9,    34,   146,    23,    35,   152,    52,    31,
   100,    55,    15,   151,     5,    38,    41,    79,    81,     2,
   143,    51,     1,   nil,    31,   nil,   nil,   nil,   nil,   103,
   nil,   nil,    53,   nil,    96,    99,   nil,   nil,    56,   nil,
   nil,   105,   106,   137,    80,    80,   108,   109,   110,   111,
   nil,   112,   113,   114,   115,   116,    95,   119,   nil,   nil,
   nil,   nil,    31,   104,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,    62,    62,   nil,   nil,   nil,   nil,   nil,   103,   118,
    62,   nil,   nil,   nil,   135,   nil,   nil,   nil,   nil,    62,
   125,   nil,   nil,   nil,   nil,   nil,   nil,   142,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,    31,   142,   nil,   nil,   nil,    80,    80,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,    80,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,    80 ]

racc_goto_check = [
     4,    12,    24,    21,    19,     6,     6,     4,    10,    21,
    21,     8,     7,    13,     6,     4,    14,    24,    15,     4,
    16,    17,     5,     6,     3,     4,     8,    17,    17,     2,
    22,     9,     1,   nil,     4,   nil,   nil,   nil,   nil,    12,
   nil,   nil,     4,   nil,    18,    18,   nil,   nil,     4,   nil,
   nil,    18,    18,    19,     4,     4,    18,    18,    18,    18,
   nil,    18,    18,    18,    18,    18,     4,    18,   nil,   nil,
   nil,   nil,     4,     4,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,    21,    21,   nil,   nil,   nil,   nil,   nil,    12,     4,
    21,   nil,   nil,   nil,    18,   nil,   nil,   nil,   nil,    21,
     4,   nil,   nil,   nil,   nil,   nil,   nil,    18,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,     4,    18,   nil,   nil,   nil,     4,     4,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,     4,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,     4 ]

racc_goto_pointer = [
   nil,    32,    29,    22,    -3,    10,  -124,     7,    -6,   -12,
   -14,   nil,   -36,   -13,   -10,   -25,   -55,   -30,   -26,   -71,
   nil,   -48,  -103,   nil,  -131,   nil ]

racc_goto_default = [
   nil,   nil,   nil,   nil,    98,   nil,    57,   nil,   nil,    22,
   nil,    27,    28,   nil,   nil,   nil,   nil,   nil,    64,   nil,
   102,    97,   nil,    65,   nil,    72 ]

racc_reduce_table = [
  0, 0, :racc_error,
  2, 40, :_reduce_1,
  5, 41, :_reduce_2,
  13, 44, :_reduce_3,
  0, 42, :_reduce_4,
  2, 42, :_reduce_5,
  5, 46, :_reduce_6,
  7, 46, :_reduce_7,
  2, 46, :_reduce_8,
  2, 47, :_reduce_9,
  0, 48, :_reduce_10,
  2, 48, :_reduce_11,
  3, 50, :_reduce_12,
  3, 50, :_reduce_13,
  0, 49, :_reduce_14,
  2, 49, :_reduce_15,
  4, 52, :_reduce_16,
  2, 52, :_reduce_17,
  6, 53, :_reduce_18,
  5, 54, :_reduce_19,
  3, 51, :_reduce_20,
  1, 51, :_reduce_21,
  1, 51, :_reduce_22,
  1, 51, :_reduce_23,
  0, 55, :_reduce_24,
  1, 55, :_reduce_25,
  1, 58, :_reduce_26,
  3, 58, :_reduce_27,
  2, 59, :_reduce_28,
  0, 56, :_reduce_29,
  2, 56, :_reduce_30,
  3, 45, :_reduce_31,
  7, 45, :_reduce_32,
  5, 45, :_reduce_33,
  5, 45, :_reduce_34,
  4, 45, :_reduce_35,
  4, 45, :_reduce_36,
  2, 45, :_reduce_37,
  3, 57, :_reduce_38,
  3, 57, :_reduce_39,
  3, 57, :_reduce_40,
  3, 57, :_reduce_41,
  3, 57, :_reduce_42,
  1, 57, :_reduce_43,
  3, 57, :_reduce_44,
  6, 57, :_reduce_45,
  1, 57, :_reduce_46,
  1, 57, :_reduce_47,
  1, 57, :_reduce_48,
  1, 57, :_reduce_49,
  1, 57, :_reduce_50,
  5, 57, :_reduce_51,
  4, 57, :_reduce_52,
  2, 57, :_reduce_53,
  3, 57, :_reduce_54,
  4, 60, :_reduce_55,
  0, 61, :_reduce_56,
  1, 61, :_reduce_57,
  1, 63, :_reduce_58,
  3, 63, :_reduce_59,
  1, 62, :_reduce_60,
  1, 64, :_reduce_61,
  1, 43, :_reduce_62 ]

racc_reduce_n = 63

racc_shift_n = 153

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
  :TRUE => 33,
  :FALSE => 34,
  :THIS => 35,
  :NEW => 36,
  :DECIMAL_NUMERAL => 37,
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
  "TRUE",
  "FALSE",
  "THIS",
  "NEW",
  "DECIMAL_NUMERAL",
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
  "ArraySubscript",
  "ActualParameters",
  "IntegerLiteral",
  "OneOrMoreActualParameters",
  "DecimalNumeral" ]

Racc_debug_parser = true

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

module_eval(<<'.,.,', 'parser.racc', 33)
  def _reduce_8(val, _values)
     MiniJava::Syntax::InvalidClassDeclaration.instance 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 34)
  def _reduce_9(val, _values)
     [ val[0], val[1] ] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 36)
  def _reduce_10(val, _values)
     [] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 36)
  def _reduce_11(val, _values)
     val[0].append(val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 38)
  def _reduce_12(val, _values)
     MiniJava::Syntax::VariableDeclaration.new(val[0], val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 39)
  def _reduce_13(val, _values)
     MiniJava::Syntax::InvalidVariableDeclaration.instance 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 41)
  def _reduce_14(val, _values)
     [] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 41)
  def _reduce_15(val, _values)
     val[0].append(val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 45)
  def _reduce_16(val, _values)
     MiniJava::Syntax::MethodDeclaration.new(*val[0], *val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 47)
  def _reduce_17(val, _values)
     MiniJava::Syntax::InvalidMethodDeclaration.instance 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 48)
  def _reduce_18(val, _values)
     [ val[1], val[2], val[4] ] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 52)
  def _reduce_19(val, _values)
     [ val[0], val[1], val[3] ] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 55)
  def _reduce_20(val, _values)
     MiniJava::Syntax::ArrayType.instance 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 56)
  def _reduce_21(val, _values)
     MiniJava::Syntax::BooleanType.instance 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 57)
  def _reduce_22(val, _values)
     MiniJava::Syntax::IntegerType.instance 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 58)
  def _reduce_23(val, _values)
     MiniJava::Syntax::IdentifierType.new(val[0]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 60)
  def _reduce_24(val, _values)
     [] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 60)
  def _reduce_25(val, _values)
     val[0] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 63)
  def _reduce_26(val, _values)
     [ val[0] ] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 64)
  def _reduce_27(val, _values)
     val[1].prepend(val[0]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 66)
  def _reduce_28(val, _values)
     MiniJava::Syntax::FormalParameter.new(val[0], val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 68)
  def _reduce_29(val, _values)
     [] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 68)
  def _reduce_30(val, _values)
     val[1].prepend(val[0]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 71)
  def _reduce_31(val, _values)
     MiniJava::Syntax::Block.new(val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 72)
  def _reduce_32(val, _values)
     MiniJava::Syntax::IfStatement.new(val[2], val[4], val[6]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 73)
  def _reduce_33(val, _values)
     MiniJava::Syntax::WhileStatement.new(val[2], val[4]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 74)
  def _reduce_34(val, _values)
     MiniJava::Syntax::PrintStatement.new(val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 75)
  def _reduce_35(val, _values)
     MiniJava::Syntax::Assignment.new(val[0], val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 76)
  def _reduce_36(val, _values)
     MiniJava::Syntax::Assignment.new(val[0], val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 77)
  def _reduce_37(val, _values)
     MiniJava::Syntax::InvalidStatement.instance 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 80)
  def _reduce_38(val, _values)
     MiniJava::Syntax::And.new(val[0], val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 81)
  def _reduce_39(val, _values)
     MiniJava::Syntax::LessThan.new(val[0], val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 82)
  def _reduce_40(val, _values)
     MiniJava::Syntax::Plus.new(val[0], val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 83)
  def _reduce_41(val, _values)
     MiniJava::Syntax::Minus.new(val[0], val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 84)
  def _reduce_42(val, _values)
     MiniJava::Syntax::Times.new(val[0], val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 85)
  def _reduce_43(val, _values)
     val[0] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 86)
  def _reduce_44(val, _values)
     MiniJava::Syntax::ArrayLength.new(val[0]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 87)
  def _reduce_45(val, _values)
     MiniJava::Syntax::Call.new(val[0], val[2], val[4]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 88)
  def _reduce_46(val, _values)
     val[0] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 89)
  def _reduce_47(val, _values)
     MiniJava::Syntax::TrueLiteral.instance 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 90)
  def _reduce_48(val, _values)
     MiniJava::Syntax::FalseLiteral.instance 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 91)
  def _reduce_49(val, _values)
     val[0] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 92)
  def _reduce_50(val, _values)
     MiniJava::Syntax::This.instance 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 93)
  def _reduce_51(val, _values)
     MiniJava::Syntax::NewArray.new(val[3]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 94)
  def _reduce_52(val, _values)
     MiniJava::Syntax::NewObject.new(val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 95)
  def _reduce_53(val, _values)
     MiniJava::Syntax::Not.new(val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 96)
  def _reduce_54(val, _values)
     val[1] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 98)
  def _reduce_55(val, _values)
     MiniJava::Syntax::ArraySubscript.new(val[0], val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 100)
  def _reduce_56(val, _values)
     [] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 100)
  def _reduce_57(val, _values)
     val[0] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 103)
  def _reduce_58(val, _values)
     [ val[0] ] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 104)
  def _reduce_59(val, _values)
     val[1].prepend(val[0]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 106)
  def _reduce_60(val, _values)
     MiniJava::Syntax::IntegerLiteral.new(val[0]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 107)
  def _reduce_61(val, _values)
     Integer(val[0]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 109)
  def _reduce_62(val, _values)
     MiniJava::Syntax::Identifier.new(val[0]) 
  end
.,.,

def _reduce_none(val, _values)
  val[0]
end

  end   # class Parser
  end   # module MiniJava
