defmodule LexerTest do
  use ExUnit.Case
  doctest Lexer

  test "lex {}" do
    assert Lexer.lex([], "{}") == [:lcurly, :rcurly, :eof]
  end
end
