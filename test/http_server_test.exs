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

  test "GET /bears with HTTPoison" do
    server = spawn(fn -> HttpServer.start(4000) end)
    parent = self()

    # for _ <- 1..5 do
    #   spawn(fn ->
    #     {:ok, response} = HTTPoison.get("http://localhost:4000/bears")
    #     send(parent, {:result, response})
    #   end)
    # end
    # for _ <- 1..5 do
    #       expected_response = """
    #       <h1>All The Bears!</h1>

    #       <ul>
    #         <li>Brutus - Grizzly</li>
    #         <li>Iceman - Polar</li>
    #         <li>Kenai - Grizzly</li>
    #         <li>Paddington - Brown</li>
    #         <li>Roscoe - Panda</li>
    #         <li>Rosie - Black</li>
    #         <li>Scarface - Grizzly</li>
    #         <li>Smokey - Black</li>
    #         <li>Snow - Polar</li>
    #         <li>Teddy - Brown</li>
    #       </ul>
    #       """

    #       received_response1 =
    #         receive do
    #           {:result, bearlist} -> bearlist
    #         end

    # ch 23 Ex using Tasks
    expected_response = """
    <h1>All The Bears!</h1>

    <ul>
      <li>Brutus - Grizzly</li>
      <li>Iceman - Polar</li>
      <li>Kenai - Grizzly</li>
      <li>Paddington - Brown</li>
      <li>Roscoe - Panda</li>
      <li>Rosie - Black</li>
      <li>Scarface - Grizzly</li>
      <li>Smokey - Black</li>
      <li>Snow - Polar</li>
      <li>Teddy - Brown</li>
    </ul>
    """

    tasks =
      for _ <- 1..5 do
        Task.async(fn ->
          {:ok, response} = HTTPoison.get("http://localhost:4000/bears")
          response
        end)
      end

    for task <- tasks do
      received_response1 = Task.await(task)

      assert received_response1.status_code == 200
      assert remove_whitespace(received_response1.body) == remove_whitespace(expected_response)
    end
  end

  # model answer
  # test "accepts a request on a socket and sends back a response" do
  #   spawn(HttpServer, :start, [4000])

  #   {:ok, response} = HTTPoison.get "http://localhost:4000/wildthings"

  #   assert response.status_code == 200
  #   assert response.body == "Bears, Lions, Tigers"
  # end

  test "sanity check for multiple pages on site" do
    server = spawn(fn -> HttpServer.start(4000) end)
    parent = self()

    check_pages =
      for page <- [
            "/wildthings",
            "/bears",
            "/api/bears",
            "/about"
          ] do
        Task.async(fn ->
          {:ok, response} = HTTPoison.get("http://localhost:4000#{page}")
          response
        end)
      end

    for task <- check_pages do
      response = Task.await(task)
      assert response.status_code == 200
    end
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end
end
