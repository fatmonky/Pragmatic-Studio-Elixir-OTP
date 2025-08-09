defmodule Servy.PledgeServer do
  @name :pledge_server
  def start do
    IO.puts("starting pledge server...")
    pid = spawn(__MODULE__, :listen_loop, [[]])
    Process.register(pid, :pledge_server)
    pid
  end

  def listen_loop(cache) do
    receive do
      {sender, :create_pledge, name, amount} ->
        {:ok, id} = send_pledge_to_service(name, amount)
        most_recent_pledges = Enum.take(cache, 2)
        new_state = [{name, amount} | most_recent_pledges]
        # notify client process about response from server
        send(sender, {:response, id})
        # recursion to listen for another message
        listen_loop(new_state)

      {sender, :recent_pledges} ->
        send(sender, {:response, cache})
        listen_loop(cache)
    end
  end

  def create_pledge(name, amount) do
    send(@name, {self(), :create_pledge, name, amount})

    receive do
      {:response, status} -> status
    end
  end

  def recent_pledges() do
    send(@name, {self(), :recent_pledges})

    receive do
      {:response, pledges} -> pledges
    end
  end

  defp send_pledge_to_service(_name, _amount) do
    # code to simulate sending pledge to external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end

# alias Servy.PledgeServer

# pid = PledgeServer.start()
# IO.inspect(PledgeServer.create_pledge("larry", 10))
# IO.inspect(PledgeServer.create_pledge("moe", 20))
# IO.inspect(PledgeServer.create_pledge("curly", 30))
# IO.inspect(PledgeServer.create_pledge("daisy", 40))
# IO.inspect(PledgeServer.create_pledge("grace", 50))

# IO.inspect(PledgeServer.recent_pledges())
