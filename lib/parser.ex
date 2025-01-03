defmodule Parser do 
  def parse([:true, :eof]), do: {:ok, true}
  def parse([:false, :eof]), do: {:ok, false}
  def parse([:null, :eof]), do: {:ok, nil}
  def parse([{:string, str}, :eof]), do: {:ok, str}
  def parse([{:number, str}, :eof]), do: {:ok, String.to_float(str)}

  def parse([:lcurly | tail]) do 
    case parse_object(%{}, tail) do
      {:ok, object, [:eof]} -> {:ok, object}
      {:ok, _object, _tail} -> {:error, "no tokens should appear after the object"}
      {:error, msg} -> {:error, msg}
    end
  end

  def parse([:lbracket | tail]) do
    case parse_list([], tail) do
      {:ok, list, [:eof]} -> {:ok, list}
      {:ok, _list, _tail} -> {:error, "no tokens should appear after the list"}
      {:error, msg} -> {:error, msg}
    end
  end
  
  defp parse_object(acc, [:rcurly | tail]), do: {:ok, acc, tail}
  defp parse_object(acc, [:comma | tail]), do: parse_object(acc, tail)

  defp parse_object(acc, [{:string, key}, :colon, token, :rcurly | tail]) do
    {:ok, Map.put(acc, key, json_to_elixir(token)), tail}
  end

  defp parse_object(acc, [{:string, key}, :colon, token, :comma | tail]) do
    Map.put(acc, key, json_to_elixir(token)) |> parse_object(tail)
  end

  defp parse_object(acc, [{:string, key}, :colon, :lcurly | tail]) do 
    case parse_object(%{}, tail) do
      {:ok, child_object, rest} -> Map.put(acc, key, child_object) |> parse_object(rest) 
      {:error, msg} -> {:error, msg}
    end
  end

  defp parse_object(acc, [{:string, key}, :colon, :lbracket | tail]) do
    case parse_list([], tail) do
      {:ok, child_list, rest} -> Map.put(acc, key, child_list) |> parse_object(rest)
    end
  end

  defp parse_object(_acc, [{:string, key}, :colon, token, not_comma_or_rcurly | _tail]) do
    value = json_to_elixir(token)
    {:error, "expected: `}` or `,` but got: #{not_comma_or_rcurly}/n#{key}: #{value}>>>>#{not_comma_or_rcurly}<<<<"}
  end

  defp parse_list(acc, [:rbracket | tail]), do: {:ok, Enum.reverse(acc), tail}
  defp parse_list(acc, [:comma | tail]), do: parse_list(acc, tail)
  
  defp parse_list(acc, [token, :rbracket | tail]) do
    {:ok, Enum.reverse([json_to_elixir(token) | acc]), tail}
  end

  defp parse_list(acc, [token, :comma | tail]) when token not in [:rbracket, :comma] do
    parse_list([json_to_elixir(token) | acc], tail)
  end
  
  defp parse_list(acc, [:lcurly | tail]) do
    case parse_object(%{}, tail) do
      {:ok, child_object, rest} -> parse_list([child_object | acc], rest)
    end
  end

  defp parse_list(acc, [:lbracket | tail]) do
    case parse_list([], tail) do
      {:ok, child_list, rest} -> parse_list([child_list | acc], rest)
    end
  end

  defp json_to_elixir(:true), do: true
  defp json_to_elixir(:false), do: false
  defp json_to_elixir(:null), do: nil
  defp json_to_elixir({:string, literal}), do: literal
  
  # quick and dirty way to get both floats and ints in 1 shot. 
  # not robust so always make sure a valid float is being passed first.
  defp json_to_elixir({:number, literal}) do
    case Float.parse(literal) do
      {number, _} -> number
    end
  end
end

