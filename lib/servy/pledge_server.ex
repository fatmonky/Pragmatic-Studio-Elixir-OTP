defmodule Servy.PledgeServer do
  @name :pledge_server

  defmodule State do
    defstruct cache_size: 4, pledges: []
  end

  use GenServer
  # Client processes
  def start_link(_args) do
    IO.puts "Starting pledge server..."
    GenServer.start_link(__MODULE__, %State{}, name: @name)
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

  def set_cache_size(size) do
    GenServer.cast(@name, {:set_cache_size, size})
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
        total = Enum.map(cache.pledges, &elem(&1, 1)) |> Enum.sum()
        {:reply, total, cache}

      {:recent_pledges, _from, cache} ->
        {:reply, cache.pledges, cache}

      {{:create_pledge, name, amount}, _from, cache} ->
        {:ok, id} = send_pledge_to_service(name, amount)
        most_recent_pledges = Enum.take(cache.pledges, cache.cache_size - 1)
        cache_pledge = [{name, amount} | most_recent_pledges]
        new_state = %State{cache | pledges: cache_pledge}
        {:reply, id, new_state}
    end
  end

  def handle_info(message, state) do
    IO.puts("can't touch this! #{inspect(message)}")
    {:noreply, state}
  end

  def init(state) do
    pledges = fetch_recent_pledges_from_service()
    new_state = %{state | pledges: pledges}
    {:ok, new_state}
  end

  def handle_cast(:clear, state) do
    {:noreply, %{state | pledges: []}}
  end

  def handle_cast({:set_cache_size, size}, state) do
    {:noreply, %{state | cache_size: size}}
  end

  defp send_pledge_to_service(_name, _amount) do
    # code to simulate sending pledge to external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  defp fetch_recent_pledges_from_service do
    # CODE GOES HERE TO FETCH RECENT PLEDGES FROM EXTERNAL SERVICE

    # Example return value:
    [{"wilma", 15}, {"fred", 25}]
  end
end

# alias Servy.PledgeServer

# {:ok, pid} = PledgeServer.start()

# send(pid, {:stop, "help!"})

# PledgeServer.set_cache_size(4)

# IO.inspect(PledgeServer.create_pledge("larry", 10))
# PledgeServer.clear()
# IO.inspect(PledgeServer.create_pledge("moe", 20))
# IO.inspect(PledgeServer.create_pledge("curly", 30))
# IO.inspect(PledgeServer.create_pledge("daisy", 40))

# IO.inspect(PledgeServer.create_pledge("grace", 50))

# IO.inspect(PledgeServer.recent_pledges())

# IO.inspect(PledgeServer.total_pledges())

# IO.inspect(Process.info(pid, :messages))
