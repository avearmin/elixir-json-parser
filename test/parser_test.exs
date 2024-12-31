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

  test "object with 1 string and 2 nested object values" do
    tokens = Lexer.lex([], "{\"one\": \"one\",\"foo\": {\"bar\": \"bar\"},\"baz\": {\"jazz\": \"jazz\"}}")

    assert Parser.parse(tokens) == {
      :ok, 
      %{
        "one" => "one", 
        "foo" => %{"bar" => "bar"}, 
        "baz" => %{"jazz" => "jazz"}
      }
    }
  end
end
