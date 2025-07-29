defmodule Recurse do
  def my_map([head | tail], fun) do
    [fun.(head) | my_map(tail, fun)]
  end

  def my_map([], _fun), do: []

  def triple([head | tail]) do
    [head * 3 | triple(tail)]
  end

  def triple([]), do: []
end

IO.inspect(Recurse.my_map([1, 2, 3, 4, 5], fn x -> x * 3 end))
IO.inspect(Recurse.triple([1, 2, 3, 4, 5]))
