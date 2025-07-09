# Anki practice 9 July
# defmodule Recurse do
#   def my_map([head | tail], fun) do
#     new_list = []
#     # apply fun on head
#     # cons to list
#     new_list = [fun.(head) | new_list]
#     # recurse/loop
#     my_map(tail, fun)
#   end

#   def my_map([], _fun) do
#     Enum.reverse()
#   end
# end

# Correction
# defmodule Recurse do
#   def my_map([head | tail], fun) do
#     [fun.(head) | my_map(tail, fun)]
#   end

#   def my_map([], _fun), do: []
# end

# nums = [1, 2, 3, 4, 5]
# IO.inspect(Recurse.my_map(nums, &(&1 * 2)))
# IO.inspect(Recurse.my_map(nums, &(&1 * 3)))
# IO.inspect(Recurse.my_map(nums, &(&1 * 4)))

# """
# Practice rewriting parse_headers function using Enum.reduce.

# original function:
#  def parse_headers([head|tail],headers) do
#    [key, value] = String.split(head, ": ")
#    headers = Map.put(headers, key, value)
#    parse_headers(tail, headers)
#  end

#  def parse_headers([], headers), do: headers
# """

# defmodule Recurse do
#   def parse_headers([head | tail], headers) do
#     [key, val] = String.split(head, ": ")
#     Enum.reduce([head | tail], %{}, fn headers -> Map.put(headers, key, val) end)
#     parse_headers(tail, headers)
#   end

#   def parse_headers([], headers), do: headers
# end

# Correction
# defmodule Recurse do
#   def parse_headers(headers) do
#     Enum.reduce(headers, %{}, fn line, headers_so_far ->
#       [key, value] = String.split(line, ": ")
#       Map.put(headers_so_far, key, value)
#     end)
#   end
# end

# keyvals = ["Content-Type: application/json", "Content-Length: 36"]
# IO.inspect(Recurse.parse_headers(keyvals))

# """
# Write a triple function that takes a list of numbers and returns a new list consisting of each of the original numbers multiplied by 3. For example, if you call triple with a list of numbers 1 to 5 like so
# IO.inspect Recurse.triple([1, 2, 3, 4, 5])
# then the result should be:
# [3, 6, 9, 12, 15]
# """

# defmodule Recurse do
#   def triple(list) do
#     triple(list, [])
#   end

#   def triple([head | tail], acc) do
#     acc = [head * 3 | acc]
#     triple(tail, acc)
#   end

#   def triple([], acc), do: Enum.reverse(acc)
# end

# nums = [1, 2, 3, 4, 5]
# IO.inspect(Recurse.triple(nums))

# Correction
# defmodule Recurse do
#   def triple([head | tail]) do
#     [head * 3 | triple(tail)]
#   end

#   def triple([]), do: []
# end

# IO.inspect(Recurse.triple([1, 2, 3, 4, 5]))
# """
# Practice writing the parse-header function in module 14 (recursion).
# This function takes a list of headers e.g. ["Head: Blah blah", "Tail: yak yak"] and turns them into a single map %{"Head" => "Blah blah", "Tail" => "yak yak"]
# """

# defmodule Recurse do
#   def parse_headers(list) do
#     parse_headers(list, %{})
#   end

#   def parse_headers([head | tail], acc) do
#     [key, val] = String.split(head, ": ")
#     acc = Map.put(acc, key, val)
#     parse_headers(tail, acc)
#   end

#   def parse_headers([], acc), do: acc
# end

# headers = ["Head: Blah blah", "Tail: yak yak"]
# IO.inspect(Recurse.parse_headers(headers))

# defmodule Recurse do
#   def my_map([head | tail], fun) do
#     [fun.(head) | my_map(tail, fun)]
#   end

#   def my_map([], _fun), do: []
# end

# nums = [1, 2, 3, 4, 5]
# IO.inspect(Recurse.my_map(nums, &(&1 * 2)))

# defmodule Recurse do
#   def parse_headers(headers) do
#     Enum.reduce(headers, %{}, fn line, headers_so_far ->
#       # string split, bind to key, val
#       [key, val] = String.split(line, ": ")
#       # put key, val into map accumulator
#       Map.put(headers_so_far, key, val)
#     end)
#   end
# end

# headers = ["Head: Blah blah", "Tail: yak yak"]
# IO.inspect(Recurse.parse_headers(headers))

# defmodule Recurse do
#   def triple([head | tail]) do
#     [head * 3 | triple(tail)]
#   end

#   def triple([]), do: []
# end

# IO.inspect(Recurse.triple([1, 2, 3, 4, 5]))

# defmodule Recurse do
#   def my_map([head | tail], fun) do
#     [fun.(head) | my_map(tail, fun)]
#   end

#   def my_map([], _fun), do: []
# end

# nums = [1, 2, 3, 4, 5]
# IO.inspect(Recurse.my_map(nums, &(&1 * 2)))
# IO.inspect(Recurse.my_map(nums, &(&1 * 3)))

defmodule Recurse do
  def parse_headers(headers) do
    Enum.reduce(headers, %{}, fn line, headers_so_far ->
      [key, val] = String.split(line, ": ")
      Map.put(headers_so_far, key, val)
    end)
  end
end

headers = ["Head: Blah blah", "Tail: yak yak"]
IO.inspect(Recurse.parse_headers(headers))
