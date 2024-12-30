defmodule Lexer do
  def lex(acc, <<head::utf8, tail::binary>>) do
    token = Token.tokenize(head)
    lex([token | acc], tail)
  end
  
  def lex(acc, <<>>) do
    Enum.reverse(acc)
  end
end
