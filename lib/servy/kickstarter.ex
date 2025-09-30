defmodule Servy.Kickstarter do
  use GenServer

  #client processes
  def start do
    IO.puts("Starting the kickstarter...")
    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  def get_server do
    GenServer.call(__MODULE__, :get_server)
  end

  # server processes
  def init(:ok) do
    Process.flag(:trap_exit, true)
    server_pid = start_http_server()
    {:ok, server_pid}
  end

  # from Prag studio: couldn't get this on my own...
  def handle_call(:get_server, _from, state) do
    {:reply, state, state}
  end

  def handle_info({:EXIT, _pid, reason}, _state) do
    server_pid = start_http_server()
    {:noreply, server_pid}
  end

  def start_http_server do
    IO.puts("starting the HTTP server...")
    server_pid = spawn_link(Servy.HttpServer, :start, [4000])
    # links HTTP server process to Kickstart process
    Process.register(server_pid, :http_server)
    server_pid
  end
end
