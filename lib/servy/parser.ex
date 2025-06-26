defmodule Servy.Parser do
  def parse(request) do
    [method, route, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: route, status: nil, status_reason: "", resp_body: ""}
  end
end
