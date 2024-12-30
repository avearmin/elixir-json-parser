defmodule Parser do
  def parse([:lcurly | tail]) do
    parse_object(%{}, tail)
  end

  defp parse_object(acc, [:rcurly | tail]) do
    case tail do
      [:eof] -> {:ok, acc}
      _ ->  [{:ok, acc} | parse(tail)] 
    end
  end

  defp parse_object(_acc, [:eof | _tail]) do
    [{:error, "unexpected eof when expecting `}`"}]
  end
end

