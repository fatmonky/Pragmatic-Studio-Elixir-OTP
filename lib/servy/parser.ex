defmodule Servy.Parser do
  alias Servy.Conv, as: Conv

  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")
    [request_line | header_lines] = String.split(top, "\n")

    [method, route, _] = String.split(request_line, " ")
    headers = parse_headers(header_lines)
    params = parse_params(headers["Content-Type"], params_string)
    %Conv{method: method, path: route, params: params, headers: headers}
  end

  # def parse_headers([head | tail], header) do
  #   split_string = String.split(head, ": ")
  #   [key, value] = split_string
  #   header = Map.put(header, key, value)
  #   parse_headers(tail, header)
  # end

  # def parse_headers([], header), do: header

  # ch 15 reduce headers exercise
  def parse_headers(header_lines) do
    Enum.reduce(header_lines, %{}, fn header, parsed_headers ->
      split_string = String.split(header, ": ")
      [key, value] = split_string
      _header = Map.put(parsed_headers, key, value)
    end)
  end

  @doc """
  Parses params_string of format `key1=value1&key2=value2`
  into a map of the respective key-value pairs.
  iex(1)> params_string = "name=Baloo&type=Brown"
  iex(2)> Servy.Parser.parse_params("application/x-www-form-urlencoded", params_string)
  %{"name" => "Baloo", "type" => "Brown"}
  iex(3)> Servy.Parser.parse_params("multipart/form-data", params_string)
  %{}
  """
  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim() |> URI.decode_query()
  end

  def parse_params(_, _), do: %{}
end
