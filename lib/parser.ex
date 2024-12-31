defmodule Parser do 
  def parse([:lcurly | tail]), do: parse_object(%{}, tail)
  
  defp parse_object(acc, [:rcurly | _tail]), do: {:ok, acc}
  defp parse_object(acc, [:comma | tail]), do: parse_object(acc, tail)

  defp parse_object(acc, [{:string, key}, :colon, {:string, value} | tail]) do
    new_acc = Map.put(acc, key, value)
    parse_object(new_acc, tail)
  end
end

