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

  defp triple([head | tail], new_list) do
    triple(tail, [head * 3 | new_list])
    # IO.inspect(head)
    # IO.inspect(tail)
    # IO.inspect(new_list)
    # Note 27 June: see this link for explanation for why my previous commit was
    # not tail-call optimised: https://chatgpt.com/share/685e5091-4028-8006-94b4-cdfbd280cd84
  end

  defp triple([], new_list) do
    new_list |> Enum.reverse()
  end

  # ch 15 ex 3
  """
   In the Recurse module (or a stand-alone module of your choosing),
   define a my_map function that acts just like Enum.map. For example:

  > nums = [1, 2, 3, 4, 5]

  > Recurse.my_map(nums, &(&1 * 2))
  [2, 4, 6, 8, 10]

  > Recurse.my_map(nums, &(&1 * 4))
  [4, 8, 12, 16, 20]

  > Recurse.my_map(nums, &(&1 * 5))
  [5, 10, 15, 20, 25]

  """

  def my_map(list, fun) do
    my_map(list, fun, [])
  end

  def my_map([head | tail], fun, new_list) do
    new_list = [fun.(head) | new_list]
    my_map(tail, fun, new_list)
  end

  def my_map([], _fun, new_list) do
    new_list |> Enum.reverse()
  end

  # model answer: defmodule(Recurse) do
  #   def my_map([head | tail], fun) do
  #     [fun.(head) | my_map(tail, fun)]
  #   end

  #   def my_map([], _fun), do: []
  # end
end

nums = [1, 2, 3, 4, 5]
sum = Recurse.loopy(nums, 0)
IO.puts("The sum is #{sum}")

new_list = Recurse.triple(nums)
IO.inspect(new_list)

new_list = Recurse.my_map(nums, &(&1 * 2))
IO.inspect(new_list)
