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

  test "GET /wildthings with HTTPoison" do
    parent = self()
    spawn(fn -> send(parent, {:result, HTTPoison.get("http://localhost:4000/wildthings")}) end)

    expected_response = """
           HTTP/1.1 200 OK\r
           Content-Type: text/html\r
           Content-Length: 28\r
           \r
           Bears, Lions, Tigers, Tapirs
    """

    received_response1 =
      receive do
        {:result, animallists} -> animallists
      end

    assert remove_whitespace(received_response1.body) == remove_whitespace(expected_response)
  end

  # model answer
  # test "accepts a request on a socket and sends back a response" do
  #   spawn(HttpServer, :start, [4000])

  #   {:ok, response} = HTTPoison.get "http://localhost:4000/wildthings"

  #   assert response.status_code == 200
  #   assert response.body == "Bears, Lions, Tigers"
  # end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end
end
