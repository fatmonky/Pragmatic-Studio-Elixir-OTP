defmodule Servy.Api.BearController do
  def index(conv) do
    json = Servy.Wildthings.list_bears() |> Poison.encode!()
    conv = put_resp_content_type(conv, "application/json")
    %{conv | status: 200, resp_body: json}
  end

  def put_resp_content_type(conv, content_type) do
    new_headers = Map.put(conv.resp_headers, "Content-Type", content_type)
    %{conv | resp_headers: new_headers}
  end

  def create_bears(conv, params) do
    %{
      conv
      | status: 201,
        resp_body: "Created a #{params["type"]} bear named #{params["name"]}!"
    }
  end
end
