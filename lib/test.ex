defmodule PatternMatching do
  def is_even(number) when rem(number, 2) == 0, do: "even"
  def even_or_odd(_), do: "odd"
end
