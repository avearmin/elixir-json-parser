defmodule LexerTest do
  use ExUnit.Case
  doctest JsonParser

  test "lex {}" do
    assert Lexer.lex([], "{}") == [:lcurly, :rcurly]
  end
end
