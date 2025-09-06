defmodule Servy.PledgeServer do
  @name :pledge_server

  use GenServer
  # Client processes
  def start do
    GenServer.start(__MODULE__, [], name: @name)
  end

  def create_pledge(name, amount) do
    GenServer.call(@name, {:create_pledge, name, amount})
  end

  def recent_pledges() do
    GenServer.call(@name, :recent_pledges)
  end

  def total_pledges() do
    GenServer.call(@name, :total_pledged)
  end

  def clear do
    GenServer.cast(@name, :clear)
  end

  # Server

  # multiclause pattern matching functions:
  # def handle_call(:total_pledged, cache) do
  #   total = Enum.map(cache, &elem(&1, 1)) |> Enum.sum()
  #   {cache, total}
  # end

  # def handle_call(:recent_pledges, cache) do
  #   {cache, cache}
  # end

  # def handle_call({:create_pledge, name, amount}, cache) do
  #   {:ok, id} = send_pledge_to_service(name, amount)
  #   most_recent_pledges = Enum.take(cache, 2)
  #   new_state = [{name, amount} | most_recent_pledges]
  #   {new_state, id}
  # end

  # own experiment with using case: this seems cleaner to me than function clauses...
  def handle_call(message, _from, cache) do
    case {message, _from, cache} do
      {:total_pledged, _from, cache} ->
        total = Enum.map(cache, &elem(&1, 1)) |> Enum.sum()
        {:reply, total, cache}

      {:recent_pledges, _from, cache} ->
        {:reply, cache, cache}

      {{:create_pledge, name, amount}, _from, cache} ->
        {:ok, id} = send_pledge_to_service(name, amount)
        most_recent_pledges = Enum.take(cache, 2)
        new_state = [{name, amount} | most_recent_pledges]
        {:reply, id, new_state}
    end
  end

  def handle_cast(:clear, _cache) do
    {:noreply, []}
  end

  defp send_pledge_to_service(_name, _amount) do
    # code to simulate sending pledge to external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end

alias Servy.PledgeServer

pid = PledgeServer.start()

# send(pid, {:stop, "help!"})

IO.inspect(PledgeServer.create_pledge("larry", 10))
IO.inspect(PledgeServer.create_pledge("moe", 20))
IO.inspect(PledgeServer.create_pledge("curly", 30))
IO.inspect(PledgeServer.create_pledge("daisy", 40))

# PledgeServer.clear()

IO.inspect(PledgeServer.create_pledge("grace", 50))

IO.inspect(PledgeServer.recent_pledges())

IO.inspect(PledgeServer.total_pledges())

# IO.inspect(Process.info(pid, :messages))
