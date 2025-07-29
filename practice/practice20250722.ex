defmodule Recurse do
  @doc """
  Takes a list of headers e.g. ["Head: Blah blah", "Tail: yak yak"] and
  turns them into a single map %{"Head" => "Blah blah", "Tail" => "yak yak"]
  """
  def parse_headers(list) do
    # for each line, split string by ": " demarcation, and bind to key, val
    # use Map.put to put the key val pair into the map
    # return map
    # Enum.reduce(list, %{}, fn list_element, headers_so_far ->
    #   [key, val] = String.split(list_element, ": ")
    #   Map.put(headers_so_far, key, val)
    parse_headers(list, %{})
  end

  def parse_headers([head | tail], map) do
    [key, val] = String.split(head, ": ")
    map = Map.put(map, key, val)
    parse_headers(tail, map)
  end

  def parse_headers([], map), do: map
end

headers = ["Head: Blah Blah", "Tail: yak yak"]
IO.inspect(Recurse.parse_headers(headers))
