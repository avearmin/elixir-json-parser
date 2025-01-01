defmodule ParserTest do
  use ExUnit.Case
  doctest Parser

  test "empty object" do
    tokens = Lexer.lex([], "{}")

    assert Parser.parse(tokens) == {:ok, %{}}
  end

  test "object with all types of key values" do
    tokens = Lexer.lex([], """
      {
        "one": "one",
        "false": false,
        "true": true,
        "null": null,
        "foo": {
          "bar": "bar"
        },
        "baz": {
          "jazz": "jazz"
        }
        "list": [true, false, "foo"]
      }
    """)

    assert Parser.parse(tokens) == {
      :ok, 
      %{
        "one" => "one",
        "false" => false,
        "true" => true,
        "null" => nil,
        "foo" => %{"bar" => "bar"}, 
        "baz" => %{"jazz" => "jazz"},
        "list" => [true, false, "foo"]
      }
    }
  end
end
