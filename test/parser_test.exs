defmodule ParserTest do
  use ExUnit.Case
  doctest Parser

  test "empty object" do
    tokens = Lexer.lex([], "{}")

    assert Parser.parse(tokens) == {:ok, %{}}
  end

  test "object with 3 key value pairs" do
    tokens = Lexer.lex([], "{\"foo\":\"foo\",\"bar\":\"bar\",\"baz\":\"baz\"}")
    
    assert Parser.parse(tokens) == {:ok, %{"foo" => "foo", "bar" => "bar", "baz" => "baz"}}
  end
end
