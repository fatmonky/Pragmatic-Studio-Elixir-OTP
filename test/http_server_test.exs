defmodule Servy.HttpServerTest do
  use ExUnit.Case

  alias Servy.HttpServer
  alias Servy.HttpClient

  test "Test /GET connections to server" do
    server = spawn(fn -> HttpServer.start(4000) end)
    IO.puts("Server started at #{inspect(server)}")

    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    client = HttpClient.client(4000, request)

    assert client == """
           HTTP/1.1 200 OK\r
           Content-Type: text/html\r
           Content-Length: 28\r
           \r
           Bears, Lions, Tigers, Tapirs
           """
  end
end
