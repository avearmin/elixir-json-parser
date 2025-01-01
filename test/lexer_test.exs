defmodule LexerTest do
  use ExUnit.Case
  doctest Lexer

  test "lex {}" do
    assert Lexer.lex([], "{}") == [:lcurly, :rcurly, :eof]
  end

  test "lex {\"foo\": \"bar\"}" do
    assert Lexer.lex([], "{\"foo\": \"bar\"}") == [:lcurly, {:string, "foo"}, :colon, {:string, "bar"}, :rcurly, :eof]
  end
  
  test "lex \"foo" do
    assert Lexer.lex([], "\"foo") == [{:illegal, "foo", "string is missing a trailing `\"`"}, :eof]
  end

  test "lex true false null" do
    assert Lexer.lex([], "true false null") == [:true, :false, :null, :eof]
  end
end
