defmodule Recurse do
  def loopy([head | tail], aggregator) do
    IO.puts("Head: #{head}, Tail: #{tail}")
    aggregator = head + aggregator
    loopy(tail, aggregator)
  end

  def loopy([], aggregator), do: aggregator
end

nums = [1, 2, 3, 4, 5]
sum = Recurse.loopy(nums, 0)
IO.puts("The sum is #{sum}")
