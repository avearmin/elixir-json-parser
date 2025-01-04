defmodule JsonParser do
  def run() do
    for arg <- System.argv() do
      IO.puts("#{arg} -> #{valid_json?(arg)}")
    end
  end

  def valid_json?(str) do
    Lexer.lex([], str)
    |> Parser.parse()
  end
end
