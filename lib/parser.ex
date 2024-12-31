defmodule Parser do 
  def parse([:lcurly | tail]) do 
    case parse_object(%{}, tail) do
      {:ok, object, _rest} -> {:ok, object}
      {:error, msg} -> {:error, msg}
    end
  end
  
  defp parse_object(acc, [:rcurly | tail]), do: {:ok, acc, tail}
  defp parse_object(acc, [:comma | tail]), do: parse_object(acc, tail)

  defp parse_object(acc, [{:string, key}, :colon, {:string, value} | tail]) do
    Map.put(acc, key, value) |> parse_object(tail)
  end

  defp parse_object(acc, [{:string, key}, :colon, :lcurly | tail]) do 
    case parse_object(%{}, tail) do
      {:ok, child_object, rest} -> Map.put(acc, key, child_object) |> parse_object(rest) 
      {:error, msg} -> {:error, msg}
    end
  end
end

