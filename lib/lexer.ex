defmodule Lexer do
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

  def lex(acc, <<head::utf8, tail::binary>>) when head in [?{, ?}, ?[, ?], ?:, ?,] do
    token = Token.tokenize(head)
    lex([token | acc], tail)
  end

  def lex(acc, <<head::utf8, tail::binary>>) when head in [?\s, ?\n], do: lex(acc, tail)
  def lex(acc, <<?", tail::binary>>), do: read_string(acc, [], tail)

  def lex(acc, <<head::utf8, tail::binary>>),
    do: read_ident(acc, [], <<head::utf8, tail::binary>>)

  def lex(acc, <<>>), do: Enum.reverse([:eof | acc])

  defp read_string(token_acc, char_acc, <<?", tail::binary>>) do
    token = Enum.reverse(char_acc) |> List.to_string() |> Token.tokenize_str()
    lex([token | token_acc], tail)
  end

  defp read_string(token_acc, char_acc, <<>>) do
    token =
      Enum.reverse(char_acc)
      |> List.to_string()
      |> Token.tokenize_illegal()

    Enum.reverse([:eof, token | token_acc])
  end

  defp read_string(token_acc, char_acc, <<head::utf8, tail::binary>>) do
    read_string(token_acc, [head | char_acc], tail)
  end

  defp read_ident(token_acc, char_acc, <<head::utf8, tail::binary>>)
       when head in [?\s, ?\n, ?,] do
    token = Enum.reverse(char_acc) |> List.to_string() |> tokenize_ident()
    lex([token | token_acc], <<head::utf8, tail::binary>>)
  end

  defp read_ident(token_acc, char_acc, <<>>) do
    token =
      Enum.reverse(char_acc)
      |> List.to_string()
      |> tokenize_ident()

    Enum.reverse([:eof, token | token_acc])
  end

  defp read_ident(token_acc, char_acc, <<head::utf8, tail::binary>>) do
    read_ident(token_acc, [head | char_acc], tail)
  end

  defp tokenize_ident(str) do
    if is_num(str, 0) do
      Token.tokenize_num(str)
    else
      Token.tokenize_illegal(str)
    end
  end

  defp is_num(<<>>, _decimal_count), do: true

  defp is_num(<<head::utf8, tail::binary>>, decimal_count) do
    cond do
      decimal_count > 1 -> false
      head >= ?0 and head <= ?9 -> is_num(tail, decimal_count)
      head == ?. -> is_num(tail, decimal_count + 1)
      true -> false
    end
  end
end
