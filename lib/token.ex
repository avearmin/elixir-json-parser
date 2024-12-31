defmodule Token do
  def tokenize(?{), do: :lcurly
  def tokenize(?}), do: :rcurly
  def tokenize(?:), do: :colon
  def tokenize(?,), do: :comma
  def tokenize(str), do: {:string, str}

  def illegal_string(str), do: {:illegal, str, "string is missing a trailing `\"`"}
end
