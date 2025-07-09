# from https://www.erlang.org/docs/28/apps/kernel/gen_tcp.html
# server() ->
#     {ok, Listen_Socket} = gen_tcp:listen(5678, [binary, {packet, 0},
#                                         {active, false}]),
#     {ok, Sock} = gen_tcp:accept(Listen_Socket),
#     {ok, Bin} = do_recv(Sock, []),
#     ok = gen_tcp:close(Sock),
#     ok = gen_tcp:close(Listen_Socket),
#     Bin.
# defmodule Servy.HttpServer do
#   def server() do
#     {:ok, listen_socket} =
#       :gen_tcp.listen(5678, [:binary, {:packet, 0}, {:active, false}, {:reuseaddr, true}])

#     {:ok, sock} = :gen_tcp.accept(listen_socket)
#     {:ok, bin} = :gen_tcp.recv(sock, 0)
#     :ok = :gen_tcp.close(sock)
#     :ok = :gen_tcp.close(listen_socket)
#     bin
#   end
# end
defmodule Servy.HttpServer do
  @doc """
  Starts server on the given `port` of localhost
  """

  def start(port) when is_integer(port) and port > 1023 do
    # Creates a socket to listen for client connections.
    # `listen_socket` is bound to the listening socket.
    {:ok, listen_socket} =
      :gen_tcp.listen(port, [:binary, {:packet, :raw}, {:active, false}, {:reuseaddr, true}])

    IO.puts("\n 🎧 Listening for connection requests on port #{port}...\n")

    accept_loop(listen_socket)
  end

  @doc """
  Accepts client connections on the `listen_socket`.
  """

  def accept_loop(listen_socket) do
    IO.puts("⌛️  Waiting to accept a client connection...\n")

    # suspends (blocks) and waits for client connection. When connection is accepted
    # `client_socket` is bound to a new client socket
    {:ok, client_socket} = :gen_tcp.accept(listen_socket)
    IO.puts("⚡️ Connection accepted!\n")

    # Receives the request and sends a response over the client socket.
    spawn(fn -> serve(client_socket) end)
    # spawn(fn -> serve(client_socket) end)
    # Loop back to wait and accept the next connection.
    accept_loop(listen_socket)
  end

  @doc """
  Receives request on `client_socket` and sends a response back over the same socket.
  """
  def serve(client_socket) do
    IO.puts("#{inspect(self())}: Working on it!")

    client_socket
    |> read_request
    # |> generate_response
    |> Servy.Handler.handler()
    |> write_response(client_socket)
  end

  @doc """
  Receives a request on the `client_socket`
  """
  def read_request(client_socket) do
    # all available bytes
    {:ok, request} = :gen_tcp.recv(client_socket, 0)
    IO.puts("➡️  Received request: \n")
    IO.puts(request)

    request
  end

  @doc """
  Generates generic HTTP response
  """
  def generate_response(_request) do
    """
    HTTP/1.1 200 OK\r
    Content-Type: text/plain\r
    Content-Length: 6\r
    \r
    Hello!
    """
  end

  @doc """
  sends `response` over the `client_socket`
  """
  def write_response(response, client_socket) do
    :ok = :gen_tcp.send(client_socket, response)

    IO.puts("⬅️  Sent response:\n")
    IO.puts(response)
    # closes client socket, ending connection
    :ok = :gen_tcp.close(client_socket)
    # does NOT close listening socket
  end
end
