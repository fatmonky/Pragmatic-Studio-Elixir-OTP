# defmodule Recurse do
#   def parse_headers(headers) do
#     # takes list of headers
#     # turn into single map
#     Enum.reduce(headers, %{}, fn line, headers_so_far ->
#       [key, val] = String.split(line, ": ")
#       Map.put(headers_so_far, key, val)
#     end)
#   end
# end

defmodule Recurse do
  def parse_headers(list) do
    parse_headers(list, %{})
  end

  def parse_headers([head | tail], headers) do
    [key, val] = String.split(head, ": ")
    headers = Map.put(headers, key, val)
    parse_headers(tail, headers)
  end

  def parse_headers([], headers), do: headers

  def my_map([head | tail], fun) do
    [fun.(head) | my_map(tail, fun)]
  end

  def my_map([], _fun), do: []

  def triple([head | tail]) do
    [head * 3 | triple(tail)]
  end

  def triple([]), do: []
end

headers = ["head: Blah blah", "Tail: yak yak"]
# expect %{"Head" => "Blah blah", "Tail" => "yak yak"}
IO.inspect(Recurse.parse_headers(headers))

nums = [1, 2, 3, 4, 5]

IO.inspect(Recurse.my_map(nums, &(&1 * 2)))
IO.inspect(Recurse.my_map(nums, &(&1 * 3)))
IO.inspect(Recurse.my_map(nums, &(&1 * 4)))
IO.inspect(Recurse.triple(nums))
