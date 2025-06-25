


# practice 1 - again! 
def parse_headers(headers) do
  Enum.reduce(headers, %{}, fn(lines, header_so_far) ->
    [key, value] = String.split(headers, ": ") # line instead of headers!
    Map.put( header_so_far, key, value)
  end)
end
