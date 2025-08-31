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

  def clear do
    cast(@name, :clear)
  end

  # Helper
  def call(pid, message) do
    send(pid, {:call, self(), message})

    receive do
      {:response, response} -> response
    end
  end

  def cast(pid, message) do
    send(pid, {:cast, message})
  end

  # Server
  def listen_loop(cache) do
    receive do
      {:call, sender, message} when is_pid(sender) ->
        {cache, response} = handle_call(message, cache)
        send(sender, {:response, response})
        listen_loop(cache)

      # async message clauses
      {:cast, message} ->
        new_state = handle_cast(message, cache)
        listen_loop(new_state)

      # :clear ->
      # new_state = []
      # listen_loop(new_state)

      unexpected ->
        IO.puts("unexpected message: #{inspect(unexpected)}")
        listen_loop(cache)
    end
  end

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
  def handle_call(message, cache) do
    case {message, cache} do
      {:total_pledged, cache} ->
        total = Enum.map(cache, &elem(&1, 1)) |> Enum.sum()
        {cache, total}

      {:recent_pledges, cache} ->
        {cache, cache}

      {{:create_pledge, name, amount}, cache} ->
        {:ok, id} = send_pledge_to_service(name, amount)
        most_recent_pledges = Enum.take(cache, 2)
        new_state = [{name, amount} | most_recent_pledges]
        {new_state, id}
    end
  end

  def handle_cast(:clear, _cache) do
    []
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

PledgeServer.clear()

IO.inspect(PledgeServer.create_pledge("grace", 50))

IO.inspect(PledgeServer.recent_pledges())

IO.inspect(PledgeServer.total_pledges())

# IO.inspect(Process.info(pid, :messages))
