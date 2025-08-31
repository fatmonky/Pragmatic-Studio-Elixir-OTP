defmodule Servy.PledgeServer do
  @name :pledge_server

  # Client processes
  def start do
    IO.puts("starting pledge server...")
    pid = spawn(__MODULE__, :listen_loop, [[]])
    Process.register(pid, :pledge_server)
    pid
  end

  def create_pledge(name, amount) do
    call(@name, {:create_pledge, name, amount})
  end

  def recent_pledges() do
    call(@name, :recent_pledges)
  end

  def total_pledges() do
    call(@name, :total_pledged)
  end

  def call(pid, message) do
    send(pid, {self(), message})

    receive do
      {:response, response} -> response
    end
  end

  # Server
  def listen_loop(cache) do
    receive do
      {sender, message} ->
        response = handle_call(message, cache)
        send(sender, {:response, response})
        listen_loop(cache)

      # {sender, {:create_pledge, name, amount}} ->
      #   # {:ok, id} = send_pledge_to_service(name, amount)
      #   # most_recent_pledges = Enum.take(cache, 2)
      #   # new_state = [{name, amount} | most_recent_pledges]
      #   # notify client process about response from server
      #   # send(sender, {:response, id})
      #   # recursion to listen for another message
      #   listen_loop(new_state)

      # {sender, :recent_pledges} ->
      #   send(sender, {:response, cache})
      #   listen_loop(cache)

      unexpected ->
        IO.puts("unexpected message: #{inspect(unexpected)}")
        listen_loop(cache)
    end
  end

  def handle_call(:total_pledged, cache) do
    total = Enum.map(cache, &elem(&1, 1)) |> Enum.sum()
  end

  defp send_pledge_to_service(_name, _amount) do
    # code to simulate sending pledge to external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end

alias Servy.PledgeServer

pid = PledgeServer.start()

send(pid, {:stop, "help!"})

IO.inspect(PledgeServer.create_pledge("larry", 10))
IO.inspect(PledgeServer.create_pledge("moe", 20))
IO.inspect(PledgeServer.create_pledge("curly", 30))
IO.inspect(PledgeServer.create_pledge("daisy", 40))
IO.inspect(PledgeServer.create_pledge("grace", 50))

IO.inspect(PledgeServer.recent_pledges())

IO.inspect(PledgeServer.total_pledges())

# IO.inspect(Process.info(pid, :messages))
