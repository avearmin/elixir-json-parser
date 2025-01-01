defmodule Lexer do
  def lex(acc, <<?", tail::binary>>), do: read_string(acc, [], tail) 
  def lex(acc, <<?\s, tail::binary>>), do: lex(acc, tail)
  def lex(acc, <<?\n, tail::binary>>), do: lex(acc, tail)
  def lex(acc, <<>>), do: Enum.reverse([:eof | acc])
  
  def lex(acc, <<?n, ?u, ?l, ?l, tail::binary>>) do
    token = Token.tokenize("null")
    lex([token | acc], tail)
  end

  def lex(acc, <<?t, ?r, ?u, ?e, tail::binary>>) do
    token = Token.tokenize("true")
    lex([token | acc], tail)
  end

  def lex(acc, <<?f, ?a, ?l, ?s, ?e, tail::binary>>) do
    token = Token.tokenize("false")
    lex([token | acc], tail)
  end

  def lex(acc, <<head::utf8, tail::binary>>) do
    token = Token.tokenize(head)
    lex([token | acc], tail)
  end
  
  defp read_string(token_acc, char_acc, <<?", tail::binary>>) do
    token = Enum.reverse(char_acc) |> List.to_string() |> Token.tokenize_str()
    lex([token | token_acc], tail)
  end
  
  defp read_string(token_acc, char_acc, <<>>) do
    token = Enum.reverse(char_acc) 
      |> List.to_string() 
      |> Token.tokenize_illegal("string is missing a trailing `\"`")
    
    Enum.reverse([:eof, token | token_acc])
  end

  defp read_string(token_acc, char_acc, <<head::utf8, tail::binary>>) do
    read_string(token_acc, [head | char_acc], tail)
  end
end
