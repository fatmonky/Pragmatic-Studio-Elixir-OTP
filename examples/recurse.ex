defmodule Recurse do
  def loopy([head | tail], aggregator) do
    # IO.puts("Head: #{head}, Tail: #{tail}")
    aggregator = head + aggregator
    loopy(tail, aggregator)
  end

  def loopy([], aggregator), do: aggregator

  # Ch 14 ex 2

  def triple(list) do
    triple(list, [])
  end

  def triple([head | tail], new_list) do
    # take each head multiply by 3
    # add to new list with each recursion
    [head * 3 | triple(tail, new_list)]
    # IO.inspect(head)
    # IO.inspect(tail)
    # IO.inspect(new_list)
    # triple(tail, new_list)
  end

  def triple([], new_list), do: new_list
end

nums = [1, 2, 3, 4, 5]
sum = Recurse.loopy(nums, 0)
IO.puts("The sum is #{sum}")

new_list = Recurse.triple(nums)
IO.inspect(new_list)
