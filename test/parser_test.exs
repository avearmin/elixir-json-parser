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

  test "just number" do
    tokens = Lexer.lex([], "55.55")

    assert Parser.parse(tokens) == {:ok, 55.55}
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
        "55.55": 55.55,
        "false": false,
        "true": true,
        "null": null,
        "foo": {
          "bar": "bar"
        },
        "baz": {
          "jazz": "jazz"
        },
        "list": [true, false, "foo"]
      }
    """)

    assert Parser.parse(tokens) == {
      :ok, 
      %{
        "one" => "one",
        "55.55" => 55.55,
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
        55.55,
        600,
        true,
        false,
        null,
        [true, false],
        {"foo": "bar"}
      ]
    """)

    assert Parser.parse(tokens) == {:ok, ["foo", "bar", 55.55, 600.0, true, false, nil, [true, false], %{"foo" => "bar"}]}
  end

  test "illegal token" do
    tokens = Lexer.lex([], "foo")

    assert Parser.parse(tokens) == {:error, "illegal token `foo`"}
  end

  test "no comma after pair in object" do
    tokens = Lexer.lex([], "{\"foo\": true \"bar\": false}")

    assert Parser.parse(tokens) == {
      :error, 
      "expected `,` or `}` after `\"foo\": true` but got `{:string, \"bar\"}`}"
    } 
  end

  test "no comma after value in array" do
    tokens = Lexer.lex([], "[true false]")

    assert Parser.parse(tokens) == {
      :error, 
      "expected `,` or `]` after `true` but got `false`"
    } 
  end

end
