defmodule Token do
  def tokenize(?{), do: :lcurly
  def tokenize(?}), do: :rcurly
end
