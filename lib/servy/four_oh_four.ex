# defmodule Servy.GenFourOhFourCounter do
#   alias Servy.FourOhFourCounter, as: Counter

#   def start(callback_module, initial_state, name) do
#     # start server process
#     pid = spawn(__MODULE__, :listen_loop, [initial_state, callback_module])
#     Process.register(pid, name)
#     pid
#   end

#   def listen_loop(state \\ %{}, callback_module) do
#     # receive-do for incoming message
#     receive do
#       {:cast, message} ->
#         new_state = Counter.handle_cast(message, state)
#         listen_loop(new_state, callback_module)

#       {:call, sender, message} ->
#         {response, new_state} = callback_module.handle_call(message, state)
#         send(sender, {:response, response})
#         listen_loop(new_state, callback_module)

#       unexpected ->
#         IO.puts("received unexpected stuff in messages! #{unexpected}")
#         listen_loop(state, callback_module)
#     after
#       4000 ->
#         IO.puts("waited 4 eternities, still nothing happened... timeout")
#         listen_loop(state, callback_module)
#     end
#   end

#   def call(pid, message) do
#     send(pid, {:call, self(), message})

#     receive do
#       {:response, response} -> response
#     after
#       3000 -> IO.puts("no response from server")
#     end
#   end

#   def cast(pid, message) do
#     send(pid, {:cast, message})
#   end
# end

defmodule Servy.FourOhFourCounter do
  @name :four_oh_four

  use GenServer
  # alias Servy.GenFourOhFourCounter, as: GenCounter
  # Server Processes: start & get_counts
  def start() do
    GenServer.start(__MODULE__, %{}, name: @name)
  end

  # Client processes should be bump-count & get_count
  def bump_count(pathname) do
    GenServer.call(@name, {:count, pathname})
  end

  def get_count(pathname) do
    GenServer.call(@name, {:get_count, pathname})
  end

  def get_counts() do
    GenServer.call(@name, :get_counts)
  end

  def clear() do
    GenServer.cast(@name, :clear)
  end

  # Helpers
  def handle_cast(:clear, _state) do
    {:noreply, %{}}
  end

  def handle_call({:count, pathname}, _from, state) do
    new_state = Map.update(state, pathname, 1, &(&1 + 1))
    {:reply, :ok, new_state}
  end

  def handle_call({:get_count, pathname}, _from, state) do
    count = Map.get(state, pathname)
    {:reply, count, state}
  end

  def handle_call(:get_counts, _from, state) do
    {:reply, state, state}
  end
end
