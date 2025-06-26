defmodule Servy.Parser do
  alias Servy.Conv, as: Conv

  def parse(request) do
    [method, route, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %Conv{method: method, path: route}
  end
end
