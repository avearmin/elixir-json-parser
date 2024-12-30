defmodule JsonParserTest do
  use ExUnit.Case
  doctest JsonParser

  test "lex {}" do
    assert JsonParser.lex([], "{}") == [:lcurly, :rcurly]
  end
end
