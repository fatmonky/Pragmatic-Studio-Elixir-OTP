defmodule Servy.BearController do
  alias Servy.Wildthings

  def index(conv) do
    bears = Wildthings.list_bears()
    # TODO: transform bears to an HTML list
    # previously:
    # %{conv | status: 200, resp_body: "Pandas, Black, Sun"}
    %{conv | status: 200, resp_body: "<ul><li>Name</li><ul>"}
  end

  def show(conv, %{"id" => id}) do
    %{conv | status: 200, resp_body: "Bear #{id}"}
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %{
      conv
      | status: 201,
        resp_body: "Created a #{type} bear named #{name}!"
    }
  end
end
