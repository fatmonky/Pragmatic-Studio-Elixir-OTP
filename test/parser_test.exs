defmodule ParserTest do
  use ExUnit.Case
  doctest Servy.Parser
  alias Servy.Parser

  test "parses list of headers into map of header lines" do
    list_headers = ["A: 1", "B: 2"]
    expected = %{"A" => "1", "B" => "2"}
    assert Parser.parse_headers(list_headers) == expected
  end

  test "parses JSON into map" do
    json = ~s({"name": "Breezly", "type": "Polar"})
    expected = %{"name" => "Breezly", "type" => "Polar"}
    assert Parser.parse_params("application/json", json) == expected
  end
end
