defmodule Recurse do
  def parse_headers(list) do
    Enum.reduce(list, %{}, fn line, headers_so_far ->
      [key, val] = String.split(line, ": ")
      Map.put(headers_so_far, key, val)
    end)
  end

  # def parse_headers(list) do
  #   parse_headers(list, %{})
  # end

  # def parse_headers([head | tail], acc) do
  #   [key, val] = String.split(head, ": ")
  #   acc = Map.put(acc, key, val)
  #   parse_headers(tail, acc)
  # end

  # def parse_headers([], acc), do: acc
end

yak = ["Head: Blah blah", "Tail: yak yak"]
map_yak = Recurse.parse_headers(yak)
IO.inspect(map_yak)
