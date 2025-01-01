defmodule Parser do 
  def parse([:true | :eof]), do: {:ok, true}
  def parse([:false | :eof]), do: {:ok, false}
  def parse([:null | :eof]), do: {:ok, nil}
  def parse([{:string, str}]), do: {:ok, str}

  def parse([:lcurly | tail]) do 
    case parse_object(%{}, tail) do
      {:ok, object, [:eof]} -> {:ok, object}
      {:ok, _object, _tail} -> {:error, "no tokens should appear after the object"}
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

  defp parse_object(_acc, [{:string, key}, :colon, token, not_comma_or_rcurly | _tail]) do
    value = json_to_elixir(token)
    {:error, "expected: `}` or `,` but got: #{not_comma_or_rcurly}/n#{key}: #{value}>>>>#{not_comma_or_rcurly}<<<<"}
  end

  defp json_to_elixir(:true), do: true
  defp json_to_elixir(:false), do: false
  defp json_to_elixir(:null), do: nil
  defp json_to_elixir({:string, literal}), do: literal
end

