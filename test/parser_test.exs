defmodule ParserTest do
  use ExUnit.Case
  doctest Parser

  test "empty object" do
    tokens = Lexer.lex([], "{}")

    assert Parser.parse(tokens) == {:ok, %{}}
  end

  test "empty list" do
    tokens = Lexer.lex([], "[]")

    assert Parser.parse(tokens) == {:ok, []}
  end

  test "just string" do
    tokens = Lexer.lex([], "\"foo\"")

    assert Parser.parse(tokens) == {:ok, "foo"}
  end

  test "just true" do
    tokens = Lexer.lex([], "true")

    assert Parser.parse(tokens) == {:ok, true}
  end

  test "just false" do
    tokens = Lexer.lex([], "false")

    assert Parser.parse(tokens) == {:ok, false}
  end

  test "just null" do
    tokens = Lexer.lex([], "null")

    assert Parser.parse(tokens) == {:ok, nil}
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

  test "list with all types of elements" do
    tokens = Lexer.lex([], """
      [
        "foo",
        "bar",
        true,
        false,
        null,
        [true, false],
        {"foo": "bar"}
      ]
    """)

    assert Parser.parse(tokens) == {:ok, ["foo", "bar", true, false, nil, [true, false], %{"foo" => "bar"}]}
  end
end
