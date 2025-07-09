# Anki practice 9 July
defmodule Recurse do
  def my_map([head | tail], fun) do
    new_list = []
    # apply fun on head
    # cons to list
    new_list = [fun.(head) | new_list]
    # recurse/loop
    my_map(tail, fun)
  end

  def my_map([], _fun) do
    Enum.reverse()
  end
end

nums = [1, 2, 3, 4, 5]
IO.inspect(Recurse.my_map(nums, &(&1 * 2)))
IO.inspect(Recurse.my_map(nums, &(&1 * 3)))
IO.inspect(Recurse.my_map(nums, &(&1 * 4)))
