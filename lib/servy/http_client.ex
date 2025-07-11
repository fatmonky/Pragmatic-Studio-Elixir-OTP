defmodule Servy.HttpClient do
  def client(port, request) do
    # to make it runnable on one machine
    someHostInNet = 'localhost'
    {:ok, sock} = :gen_tcp.connect(someHostInNet, port, [:binary, packet: :raw, active: false])
    :ok = :gen_tcp.send(sock, request)
    {:ok, response} = :gen_tcp.recv(sock, 0)
    IO.puts("➡️  Received response: \n")
    IO.puts(response)
    :ok = :gen_tcp.close(sock)
    response
  end
end

# request = """
# GET /bears HTTP/1.1\r
# Host: example.com\r
# User-Agent: ExampleBrowser/1.0\r
# Accept: */*\r
# \r
# """

# model answer:
# defmodule Servy.HttpClient do
#   def send_request(request) do
#     some_host_in_net = 'localhost'  # to make it runnable on one machine
#     {:ok, socket} =
#       :gen_tcp.connect(some_host_in_net, 4000, [:binary, packet: :raw, active: false])
#     :ok = :gen_tcp.send(socket, request)
#     {:ok, response} = :gen_tcp.recv(socket, 0)
#     :ok = :gen_tcp.close(socket)
#     response
#   end
# end

# request = """
# GET /bears HTTP/1.1\r
# Host: example.com\r
# User-Agent: ExampleBrowser/1.0\r
# Accept: */*\r
# \r
# """

# spawn(fn -> Servy.HttpServer.start(4000) end)

# response = Servy.HttpClient.send_request(request)
# IO.puts response
