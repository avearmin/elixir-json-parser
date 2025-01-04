defmodule LexerTest do
  use ExUnit.Case
  doctest Lexer

  test "lex {}" do
    assert Lexer.lex([], "{}") == [:lcurly, :rcurly, :eof]
  end

  test "lex {\"foo\": \"bar\"}" do
    assert Lexer.lex([], "{\"foo\": \"bar\"}") == [
             :lcurly,
             {:string, "foo"},
             :colon,
             {:string, "bar"},
             :rcurly,
             :eof
           ]
  end

  test "lex \"foo" do
    assert Lexer.lex([], "\"foo") == [{:illegal, "foo"}, :eof]
  end

  test "lex true false null" do
    assert Lexer.lex([], "true false null") == [true, false, :null, :eof]
  end

  test "lex numbers" do
    assert Lexer.lex([], "55.55 600") == [{:number, "55.55"}, {:number, "600"}, :eof]
  end

  test "lex illegals" do
    assert Lexer.lex([], "55.55.55 foo 55.5a 6oo") == [
             {:illegal, "55.55.55"},
             {:illegal, "foo"},
             {:illegal, "55.5a"},
             {:illegal, "6oo"},
             :eof
           ]
  end
end
