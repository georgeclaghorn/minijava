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

module_eval(<<'...end parser.racc/module_eval...', 'parser.racc', 135)
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
    64,    40,   101,    67,   102,    72,   100,    98,    99,    97,
    96,    67,   167,   101,    56,   102,     4,    72,     9,    56,
   103,    95,    72,    66,    27,    28,     9,    57,    92,    58,
    59,    56,    57,     9,    58,    59,    56,     9,     9,    21,
     7,    36,     9,    14,    57,     9,    58,    59,    10,    57,
    15,    58,    59,    83,     9,    26,    50,    26,    83,     9,
    72,     7,    82,    27,    28,    27,    28,    82,     9,    13,
    56,   127,    17,     9,    56,    21,     9,     9,     9,    53,
    27,    28,    31,    57,    72,    58,    59,    57,    32,    58,
    59,    26,   101,     9,   102,    72,   100,     9,    56,    27,
    28,    72,    33,    27,    28,   101,    72,   102,    26,    56,
     9,    57,     9,    58,    59,    56,     9,    41,    69,    43,
    56,     9,    57,    44,    58,    59,    27,    28,    57,    81,
    58,    59,     9,    57,    80,    58,    59,    81,     9,     9,
    27,    28,    80,     9,    81,    45,    26,     9,    46,    80,
    81,    47,   101,     9,   102,    80,   100,    98,    99,    97,
    74,    75,    76,    78,    79,     9,    48,     9,    74,    75,
    76,    78,    79,     9,    61,    74,    75,    76,    78,    79,
     9,    74,    75,    76,    78,    79,     9,    81,    63,    68,
    86,    87,    80,    81,    88,    89,    90,    91,    80,    81,
    67,   109,   117,   129,    80,    81,   130,   137,   138,     9,
    80,    81,   140,   101,   143,   102,    80,   100,    74,    75,
    76,    78,    79,     9,    74,    75,    76,    78,    79,     9,
    74,    75,    76,    78,    79,     9,    74,    75,    76,    78,
    79,     9,    74,    75,    76,    78,    79,     9,    81,   145,
   146,   149,   151,    80,    81,   157,     9,   160,   163,    80,
    81,   165,     3,   nil,   nil,    80,    81,   nil,   nil,   nil,
   nil,    80,    81,   nil,   nil,   nil,   nil,    80,   nil,    74,
    75,    76,    78,    79,     9,    74,    75,    76,    78,    79,
     9,    74,    75,    76,    78,    79,     9,    74,    75,    76,
    78,    79,     9,    74,    75,    76,    78,    79,     9,    81,
   nil,   nil,   nil,   nil,    80,    81,   nil,   nil,   nil,   nil,
    80,    81,   nil,   nil,   nil,   nil,    80,    81,   nil,   nil,
   nil,   nil,    80,    81,   nil,   nil,   nil,   nil,    80,   nil,
    74,    75,    76,    78,    79,     9,    74,    75,    76,    78,
    79,     9,    74,    75,    76,    78,    79,     9,    74,    75,
    76,    78,    79,     9,    74,    75,    76,    78,    79,     9,
    81,   nil,   nil,   nil,   nil,    80,    81,   nil,   nil,   nil,
   101,    80,   102,   nil,   100,    98,    99,    97,    96,   nil,
   101,   nil,   102,   nil,   100,    98,    99,    97,    96,   161,
   nil,    74,    75,    76,    78,    79,     9,    74,    75,    76,
    78,    79,     9,   159,   101,   nil,   102,   nil,   100,    98,
    99,    97,    96,   101,   nil,   102,   nil,   100,    98,    99,
    97,    96,   101,   141,   102,   nil,   100,    98,    99,    97,
    96,   101,   119,   102,   nil,   100,    98,    99,    97,    96,
   nil,   132,   nil,   nil,   nil,   nil,   135,   101,   nil,   102,
   120,   100,    98,    99,    97,    96,   131,   101,   nil,   102,
   nil,   100,    98,    99,    97,    96,   136,   101,   nil,   102,
   nil,   100,    98,    99,    97,    96,   134,   101,   nil,   102,
   nil,   100,    98,    99,    97,    96,   101,   133,   102,   nil,
   100,    98,    99,    97,    96,   101,   142,   102,   nil,   100,
    98,    99,    97,    96,   101,   155,   102,   nil,   100,    98,
    99,    97,    96,   101,   nil,   102,   nil,   100,    98,    99 ]

racc_action_check = [
    49,    23,    73,    50,    73,    65,    73,    73,    73,    73,
    73,    64,   166,   125,    49,   125,     1,   135,    50,    65,
    79,    73,   134,    49,    49,    49,    64,    49,    65,    49,
    49,   135,    65,    79,    65,    65,   134,    49,    23,    44,
     2,    19,    65,    12,   135,     3,   135,   135,     4,   134,
    12,   134,   134,    71,   135,    44,    41,    19,    54,   134,
    56,     5,    71,    44,    44,    19,    19,    54,     7,     8,
    41,   102,    13,    15,    56,    14,    44,   102,    19,    41,
    41,    41,    16,    41,   165,    41,    41,    56,    17,    56,
    56,    14,   124,    41,   124,    52,   124,    56,   165,    14,
    14,    84,    18,    89,    89,   105,   157,   105,    20,    52,
    21,   165,    14,   165,   165,    84,    89,    25,    52,    27,
   157,   165,    52,    30,    52,    52,   138,   138,    84,    81,
    84,    84,    52,   157,    81,   157,   157,    92,    84,   138,
    26,    26,    92,   157,    96,    32,    34,    36,    38,    96,
    97,    39,   121,    26,   121,    97,   121,   121,   121,   121,
    81,    81,    81,    81,    81,    81,    40,    42,    92,    92,
    92,    92,    92,    92,    43,    96,    96,    96,    96,    96,
    96,    97,    97,    97,    97,    97,    97,    98,    45,    51,
    57,    58,    98,    99,    59,    60,    62,    63,    99,   100,
    72,    85,    91,   103,   100,   101,   104,   113,   115,   116,
   101,    53,   117,   123,   128,   123,    53,   123,    98,    98,
    98,    98,    98,    98,    99,    99,    99,    99,    99,    99,
   100,   100,   100,   100,   100,   100,   101,   101,   101,   101,
   101,   101,    53,    53,    53,    53,    53,    53,   129,   130,
   133,   136,   140,   129,   143,   147,   151,   153,   158,   143,
   146,   163,     0,   nil,   nil,   146,    66,   nil,   nil,   nil,
   nil,    66,    69,   nil,   nil,   nil,   nil,    69,   nil,   129,
   129,   129,   129,   129,   129,   143,   143,   143,   143,   143,
   143,   146,   146,   146,   146,   146,   146,    66,    66,    66,
    66,    66,    66,    69,    69,    69,    69,    69,    69,   159,
   nil,   nil,   nil,   nil,   159,    80,   nil,   nil,   nil,   nil,
    80,    82,   nil,   nil,   nil,   nil,    82,    83,   nil,   nil,
   nil,   nil,    83,    86,   nil,   nil,   nil,   nil,    86,   nil,
   159,   159,   159,   159,   159,   159,    80,    80,    80,    80,
    80,    80,    82,    82,    82,    82,    82,    82,    83,    83,
    83,    83,    83,    83,    86,    86,    86,    86,    86,    86,
    87,   nil,   nil,   nil,   nil,    87,    88,   nil,   nil,   nil,
   156,    88,   156,   nil,   156,   156,   156,   156,   156,   nil,
   152,   nil,   152,   nil,   152,   152,   152,   152,   152,   156,
   nil,    87,    87,    87,    87,    87,    87,    88,    88,    88,
    88,    88,    88,   152,   118,   nil,   118,   nil,   118,   118,
   118,   118,   118,    93,   nil,    93,   nil,    93,    93,    93,
    93,    93,   107,   118,   107,   nil,   107,   107,   107,   107,
   107,    94,    93,    94,   nil,    94,    94,    94,    94,    94,
   nil,   107,   nil,   nil,   nil,   nil,   111,   111,   nil,   111,
    94,   111,   111,   111,   111,   111,   106,   106,   nil,   106,
   nil,   106,   106,   106,   106,   106,   112,   112,   nil,   112,
   nil,   112,   112,   112,   112,   112,   110,   110,   nil,   110,
   nil,   110,   110,   110,   110,   110,   108,   108,   108,   nil,
   108,   108,   108,   108,   108,   126,   126,   126,   nil,   126,
   126,   126,   126,   126,   144,   144,   144,   nil,   144,   144,
   144,   144,   144,   122,   nil,   122,   nil,   122,   122,   122 ]

racc_action_pointer = [
   248,    16,    26,     7,    48,    47,   nil,    30,    54,   nil,
   nil,   nil,    28,    55,    74,    35,    66,    70,    86,    40,
    91,    72,   nil,     0,   nil,   102,   115,   115,   nil,   nil,
   108,   nil,   126,   nil,   129,   nil,   109,   nil,   125,   128,
   143,    55,   129,   169,    38,   168,   nil,   nil,   nil,    -1,
   -20,   173,    94,   209,    54,   nil,    59,   188,   189,   192,
   193,   nil,   180,   195,   -12,     4,   264,   nil,   nil,   270,
   nil,    49,   177,    -2,   nil,   nil,   nil,   nil,   nil,    -5,
   313,   127,   319,   325,   100,   185,   331,   368,   374,    78,
   nil,   181,   135,   419,   437,   nil,   142,   148,   185,   191,
   197,   203,    39,   199,   204,   101,   463,   428,   492,   nil,
   483,   453,   473,   204,   nil,   181,   171,   208,   410,   nil,
   nil,   148,   519,   209,    88,     9,   501,   nil,   212,   246,
   246,   nil,   nil,   237,    21,    16,   228,   nil,   101,   nil,
   247,   nil,   nil,   252,   510,   nil,   258,   226,   nil,   nil,
   nil,   218,   386,   254,   nil,   nil,   376,   105,   255,   307,
   nil,   nil,   nil,   246,   nil,    83,    -4,   nil ]

racc_action_default = [
   -70,   -70,    -1,   -70,   -70,    -2,    -5,   -70,   -70,   -69,
   168,    -6,   -70,   -70,   -12,   -70,   -70,   -70,   -70,   -10,
   -11,   -13,   -14,   -70,   -19,   -70,   -70,   -30,   -29,   -31,
   -70,    -3,   -70,    -7,    -9,   -15,   -70,   -20,   -70,   -70,
   -70,   -70,   -70,   -70,   -12,   -70,   -18,   -16,   -17,   -70,
   -27,   -70,   -70,   -70,   -31,   -39,   -37,   -70,   -70,   -70,
   -70,   -28,   -70,   -70,   -70,   -70,   -70,   -47,   -21,   -70,
   -40,   -70,   -70,   -70,   -56,   -57,   -58,   -59,   -60,   -70,
   -70,   -70,   -70,   -70,   -38,   -70,   -70,   -70,   -70,   -32,
    -8,   -70,   -70,   -70,   -70,   -26,   -70,   -70,   -70,   -70,
   -70,   -70,   -70,   -70,   -70,   -63,   -70,   -70,   -70,   -41,
   -70,   -70,   -70,   -70,   -33,   -34,   -70,   -70,   -70,   -24,
   -25,   -48,   -49,   -50,   -51,   -52,   -70,   -54,   -70,   -70,
   -70,   -64,   -45,   -70,   -70,   -70,   -70,   -22,   -70,   -36,
   -70,   -23,   -53,   -65,   -70,   -62,   -70,   -70,   -43,   -44,
   -35,   -70,   -67,   -70,   -66,   -61,   -70,   -70,   -70,   -70,
   -55,   -46,   -42,   -70,   -68,   -70,   -70,    -4 ]

racc_goto_table = [
     8,   114,    70,   154,    12,    42,    18,    35,    37,    52,
     6,    29,    30,    11,    51,    70,    29,    65,    38,   164,
    39,   113,    37,    29,    84,     5,     2,    85,   153,    49,
     1,    34,    16,    38,    70,   nil,    62,    35,    54,    60,
   nil,    29,   nil,   nil,    73,   nil,    54,    38,   nil,    71,
   150,   nil,   nil,    71,   nil,   nil,   nil,    93,   nil,   nil,
    94,    38,    71,   nil,   nil,   nil,   nil,   nil,   116,   nil,
   nil,   105,   106,   107,   108,   nil,   104,   110,   111,   112,
   nil,    71,   nil,   118,   147,   148,    29,   121,   122,   123,
   124,   125,   126,   nil,   nil,   nil,   nil,   nil,   nil,   128,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   162,   nil,   nil,
   nil,   nil,   nil,   139,   nil,   166,   nil,   116,   nil,   nil,
   144,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,    71,    71,   nil,   nil,    29,   nil,   156,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   158,   nil,
   nil,   nil,   nil,   nil,    71,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,    71 ]

racc_goto_check = [
     4,    19,     6,    23,     4,    12,     8,    11,    13,    17,
     7,     4,     4,     7,    15,     6,     4,    17,     4,    23,
     4,    16,    13,     4,    17,     3,     2,    21,    22,     9,
     1,    10,     5,     4,     6,   nil,     8,    11,     4,     4,
   nil,     4,   nil,   nil,    18,   nil,     4,     4,   nil,     4,
    19,   nil,   nil,     4,   nil,   nil,   nil,    18,   nil,   nil,
    18,     4,     4,   nil,   nil,   nil,   nil,   nil,    12,   nil,
   nil,    18,    18,    18,    18,   nil,     4,    18,    18,    18,
   nil,     4,   nil,    18,     6,     6,     4,    18,    18,    18,
    18,    18,    18,   nil,   nil,   nil,   nil,   nil,   nil,     4,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,     6,   nil,   nil,
   nil,   nil,   nil,     4,   nil,     6,   nil,    12,   nil,   nil,
    18,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,     4,     4,   nil,   nil,     4,   nil,    18,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,     4,   nil,
   nil,   nil,   nil,   nil,     4,   nil,   nil,   nil,   nil,   nil,
   nil,   nil,     4 ]

racc_goto_pointer = [
   nil,    30,    26,    23,    -3,    19,   -50,     8,    -8,   -12,
    12,   -12,   -21,   -12,   nil,   -27,   -68,   -32,    -9,   -88,
   nil,   -29,  -115,  -140 ]

racc_goto_default = [
   nil,   nil,   nil,   nil,    77,   nil,    55,   nil,   nil,    19,
    20,    22,    23,    24,    25,   nil,   nil,   nil,   152,   nil,
   115,   nil,   nil,   nil ]

racc_reduce_table = [
  0, 0, :racc_error,
  1, 40, :_reduce_1,
  2, 40, :_reduce_2,
  5, 41, :_reduce_3,
  13, 44, :_reduce_4,
  1, 42, :_reduce_5,
  2, 42, :_reduce_6,
  5, 46, :_reduce_7,
  7, 46, :_reduce_8,
  2, 47, :_reduce_9,
  1, 47, :_reduce_10,
  1, 47, :_reduce_11,
  0, 47, :_reduce_12,
  1, 47, :_reduce_none,
  1, 48, :_reduce_14,
  2, 48, :_reduce_15,
  3, 50, :_reduce_16,
  3, 50, :_reduce_none,
  3, 50, :_reduce_none,
  1, 49, :_reduce_19,
  2, 49, :_reduce_20,
  4, 52, :_reduce_21,
  6, 53, :_reduce_22,
  5, 54, :_reduce_23,
  4, 54, :_reduce_24,
  4, 54, :_reduce_25,
  3, 54, :_reduce_26,
  1, 54, :_reduce_none,
  3, 51, :_reduce_28,
  1, 51, :_reduce_29,
  1, 51, :_reduce_30,
  1, 51, :_reduce_31,
  0, 55, :_reduce_32,
  1, 55, :_reduce_33,
  1, 58, :_reduce_34,
  3, 58, :_reduce_35,
  2, 59, :_reduce_36,
  0, 60, :_reduce_37,
  1, 60, :_reduce_38,
  1, 56, :_reduce_39,
  2, 56, :_reduce_40,
  3, 45, :_reduce_41,
  7, 45, :_reduce_42,
  5, 45, :_reduce_43,
  5, 45, :_reduce_44,
  4, 45, :_reduce_45,
  7, 45, :_reduce_46,
  2, 45, :_reduce_none,
  3, 57, :_reduce_48,
  3, 57, :_reduce_49,
  3, 57, :_reduce_50,
  3, 57, :_reduce_51,
  3, 57, :_reduce_52,
  4, 57, :_reduce_53,
  3, 57, :_reduce_54,
  6, 57, :_reduce_55,
  1, 57, :_reduce_56,
  1, 57, :_reduce_57,
  1, 57, :_reduce_58,
  1, 57, :_reduce_59,
  1, 57, :_reduce_60,
  5, 57, :_reduce_61,
  4, 57, :_reduce_62,
  2, 57, :_reduce_63,
  3, 57, :_reduce_64,
  0, 61, :_reduce_65,
  1, 61, :_reduce_66,
  1, 62, :_reduce_67,
  3, 62, :_reduce_68,
  1, 43, :_reduce_69 ]

racc_reduce_n = 70

racc_shift_n = 168

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
  "OneOrMoreClassDeclarations",
  "Identifier",
  "MainMethodDeclaration",
  "Statement",
  "ClassDeclaration",
  "ClassBody",
  "OneOrMoreVariableDeclarations",
  "OneOrMoreMethodDeclarations",
  "VariableDeclaration",
  "Type",
  "MethodDeclaration",
  "MethodSignature",
  "MethodBody",
  "FormalParameters",
  "OneOrMoreStatements",
  "Expression",
  "OneOrMoreFormalParameters",
  "FormalParameter",
  "Statements",
  "ActualParameters",
  "OneOrMoreActualParameters" ]

Racc_debug_parser = false

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'parser.racc', 18)
  def _reduce_1(val, _values)
     MiniJava::Syntax::Program.new(val[0], []) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 19)
  def _reduce_2(val, _values)
     MiniJava::Syntax::Program.new(val[0], val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 22)
  def _reduce_3(val, _values)
     MiniJava::Syntax::MainClassDeclaration.new(val[1], val[3]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 27)
  def _reduce_4(val, _values)
     MiniJava::Syntax::MainMethodDeclaration.new(val[8], val[11]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 30)
  def _reduce_5(val, _values)
     [ val[0] ] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 31)
  def _reduce_6(val, _values)
     val[0].append(val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 34)
  def _reduce_7(val, _values)
     MiniJava::Syntax::ClassDeclaration.new(val[1], *val[3]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 36)
  def _reduce_8(val, _values)
     MiniJava::Syntax::SubclassDeclaration.new(val[1], val[3], *val[5]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 38)
  def _reduce_9(val, _values)
     [ val[0], val[1] ] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 39)
  def _reduce_10(val, _values)
     [ val[0], [] ] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 40)
  def _reduce_11(val, _values)
     [ [], val[0] ] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 41)
  def _reduce_12(val, _values)
     [ [], [] ] 
  end
.,.,

# reduce 13 omitted

module_eval(<<'.,.,', 'parser.racc', 45)
  def _reduce_14(val, _values)
     val[0].nil? ? [] : [ val[0] ] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 46)
  def _reduce_15(val, _values)
     val[0].append(val[1]) unless val[1].nil? 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 48)
  def _reduce_16(val, _values)
     MiniJava::Syntax::VariableDeclaration.new(val[0], val[1]) 
  end
.,.,

# reduce 17 omitted

# reduce 18 omitted

module_eval(<<'.,.,', 'parser.racc', 53)
  def _reduce_19(val, _values)
     [ val[0] ] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 54)
  def _reduce_20(val, _values)
     val[0].append(val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 58)
  def _reduce_21(val, _values)
     MiniJava::Syntax::MethodDeclaration.new(*val[0], *val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 59)
  def _reduce_22(val, _values)
     [ val[1], val[2], val[4] ] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 63)
  def _reduce_23(val, _values)
     [ val[0], val[1], val[3] ] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 65)
  def _reduce_24(val, _values)
     [ val[0], [], val[2] ] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 67)
  def _reduce_25(val, _values)
     [ [], val[0], val[2] ] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 68)
  def _reduce_26(val, _values)
     [ [], [], val[1] ] 
  end
.,.,

# reduce 27 omitted

module_eval(<<'.,.,', 'parser.racc', 72)
  def _reduce_28(val, _values)
     MiniJava::Syntax::ARRAY_TYPE 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 73)
  def _reduce_29(val, _values)
     MiniJava::Syntax::BOOLEAN_TYPE 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 74)
  def _reduce_30(val, _values)
     MiniJava::Syntax::INTEGER_TYPE 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 75)
  def _reduce_31(val, _values)
     MiniJava::Syntax::IdentifierType.new(val[0]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 77)
  def _reduce_32(val, _values)
     [] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 77)
  def _reduce_33(val, _values)
     val[0] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 80)
  def _reduce_34(val, _values)
     [ val[0] ] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 81)
  def _reduce_35(val, _values)
     val[1].prepend(val[0]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 83)
  def _reduce_36(val, _values)
     MiniJava::Syntax::FormalParameter.new(val[0], val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 85)
  def _reduce_37(val, _values)
     [] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 85)
  def _reduce_38(val, _values)
     val[0] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 87)
  def _reduce_39(val, _values)
     [ val[0] ] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 88)
  def _reduce_40(val, _values)
     val[0].append(val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 91)
  def _reduce_41(val, _values)
     MiniJava::Syntax::Block.new(val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 92)
  def _reduce_42(val, _values)
     MiniJava::Syntax::IfStatement.new(val[2], val[4], val[6]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 93)
  def _reduce_43(val, _values)
     MiniJava::Syntax::WhileStatement.new(val[2], val[4]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 94)
  def _reduce_44(val, _values)
     MiniJava::Syntax::PrintStatement.new(val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 95)
  def _reduce_45(val, _values)
     MiniJava::Syntax::Assignment.new(val[0], val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 97)
  def _reduce_46(val, _values)
     MiniJava::Syntax::ArrayAssignment.new(val[0], val[2], val[5]) 
  end
.,.,

# reduce 47 omitted

module_eval(<<'.,.,', 'parser.racc', 101)
  def _reduce_48(val, _values)
     MiniJava::Syntax::And.new(val[0], val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 102)
  def _reduce_49(val, _values)
     MiniJava::Syntax::LessThan.new(val[0], val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 103)
  def _reduce_50(val, _values)
     MiniJava::Syntax::Plus.new(val[0], val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 104)
  def _reduce_51(val, _values)
     MiniJava::Syntax::Minus.new(val[0], val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 105)
  def _reduce_52(val, _values)
     MiniJava::Syntax::Times.new(val[0], val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 106)
  def _reduce_53(val, _values)
     MiniJava::Syntax::ArraySubscript.new(val[0], val[2]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 107)
  def _reduce_54(val, _values)
     MiniJava::Syntax::ArrayLength.new(val[0]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 108)
  def _reduce_55(val, _values)
     MiniJava::Syntax::Call.new(val[0], val[2], val[4]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 109)
  def _reduce_56(val, _values)
     MiniJava::Syntax::IntegerLiteral.new(val[0]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 110)
  def _reduce_57(val, _values)
     MiniJava::Syntax::TRUE_LITERAL 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 111)
  def _reduce_58(val, _values)
     MiniJava::Syntax::FALSE_LITERAL 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 112)
  def _reduce_59(val, _values)
     val[0] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 113)
  def _reduce_60(val, _values)
     MiniJava::Syntax::THIS 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 114)
  def _reduce_61(val, _values)
     MiniJava::Syntax::NewArray.new(val[3]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 115)
  def _reduce_62(val, _values)
     MiniJava::Syntax::NewObject.new(val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 116)
  def _reduce_63(val, _values)
     MiniJava::Syntax::Not.new(val[1]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 117)
  def _reduce_64(val, _values)
     val[1] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 119)
  def _reduce_65(val, _values)
     [] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 119)
  def _reduce_66(val, _values)
     val[0] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 122)
  def _reduce_67(val, _values)
     [ val[0] ] 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 123)
  def _reduce_68(val, _values)
     val[1].prepend(val[0]) 
  end
.,.,

module_eval(<<'.,.,', 'parser.racc', 125)
  def _reduce_69(val, _values)
     MiniJava::Syntax::Identifier.new(val[0]) 
  end
.,.,

def _reduce_none(val, _values)
  val[0]
end

  end   # class Parser
  end   # module MiniJava
