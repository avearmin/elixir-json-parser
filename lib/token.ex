defmodule Token do
  def tokenize(?[), do: :lbracket
  def tokenize(?]), do: :rbracket
  def tokenize(?{), do: :lcurly
  def tokenize(?}), do: :rcurly
  def tokenize(?:), do: :colon
  def tokenize(?,), do: :comma
  def tokenize("true"), do: true
  def tokenize("false"), do: false
  def tokenize("null"), do: :null

  def tokenize_str(literal), do: {:string, literal}

  def tokenize_num(literal), do: {:number, literal}

  def tokenize_illegal(literal), do: {:illegal, literal}
end
