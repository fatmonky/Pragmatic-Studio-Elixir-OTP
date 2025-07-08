defmodule Servy.Api.BearController do
  def index(conv) do
    json = Servy.Wildthings.list_bears() |> Poison.encode!()
    %{conv | status: 200, resp_body: json, resp_headers: %{"Content-Type" => "application/json"}}
  end
end
