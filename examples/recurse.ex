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
end

nums = [1, 2, 3, 4, 5]
sum = Recurse.loopy(nums, 0)
IO.puts("The sum is #{sum}")

new_list = Recurse.triple(nums)
IO.inspect(new_list)
