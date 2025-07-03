defmodule ServyHandlerTest do
  use ExUnit.Case

  import Servy.Handler, only: [handler: 1]
  doctest Servy.Handler

  test "GET /wildthings" do
    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r

    """

    response = handler(request)

    assert response == """
           HTTP/1.1 200 OK
           Content-Type: text/html
           Content-Length: 38

           😃
           Bears, Lions, Tigers, Tapirs
           😃
           """
  end
end
