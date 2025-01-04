defmodule Parser do 
  def parse(tokens) do
    case parse_value(tokens) do
      {:ok, result, [:eof]} -> 
        {:ok, result}

      {:ok, _result, leftover} -> 
        {:error, "expected :eof, but got leftover tokens #{inspect(leftover)}"}

      {:error, msg} -> 
        {:error, msg}
    end
  end

  defp parse_value([:true | rest]), do: {:ok, true, rest}
  defp parse_value([:false | rest]), do: {:ok, false, rest}
  defp parse_value([:null | rest]), do: {:ok, nil, rest}
  
  defp parse_value([{:string, literal} | rest]) do
    {:ok, literal, rest}
  end
   
  defp parse_value([{:number, literal} | rest]) do
    case Float.parse(literal) do
      {number, ""} -> 
        {:ok, number, rest}

      {_number, _leftover} -> 
        {:error, "invalid number #{literal}"}

      :error -> 
        {:error, "invalid number #{literal}"}
    end
  end

  defp parse_value([:lcurly | rest]) do
    parse_object(%{}, rest)
  end

  defp parse_value([:lbracket | rest]) do
    parse_array([], rest)
  end
  
  defp parse_object(acc, [:rcurly | rest]), do: {:ok, acc, rest}

  defp parse_object(acc, [{:string, key}, :colon | rest]) do
    case parse_value(rest) do
      {:ok, value, [:comma | leftover]} -> 
        parse_object(Map.put(acc, key, value), leftover)

      {:ok, value, [:rcurly | leftover]} -> 
        {:ok, Map.put(acc, key, value), leftover}

      {:error, msg} -> 
        {:error, msg}
    end
  end
  
  def parse_array(acc, [:rbracket | rest]), do: {:ok, acc, rest}

  def parse_array(acc, tokens) do
    case parse_value(tokens) do
      {:ok, element, [:comma | leftover]} -> 
        parse_array([element | acc], leftover)

      {:ok, element, [:rbracket | leftover]} -> 
        {:ok, Enum.reverse([element | acc]), leftover}

      {:error, msg} -> 
        {:error, msg}
    end
  end  
end

