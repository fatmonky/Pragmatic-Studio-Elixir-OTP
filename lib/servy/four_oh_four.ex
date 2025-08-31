defmodule Servy.GenFourOhFourCounter do
  alias Servy.FourOhFourCounter, as: Counter

  def start(callback_module, initial_state, name) do
    # start server process
    pid = spawn(__MODULE__, :listen_loop, [initial_state, callback_module])
    Process.register(pid, name)
    pid
  end

  def listen_loop(state \\ %{}, callback_module) do
    # receive-do for incoming message
    receive do
      {:cast, message} ->
        new_state = Counter.handle_cast(message, state)
        listen_loop(new_state, callback_module)

      {:call, sender, message} ->
        {response, new_state} = callback_module.handle_call(message, state)
        send(sender, {:response, response})
        listen_loop(new_state, callback_module)

      unexpected ->
        IO.puts("received unexpected stuff in messages! #{unexpected}")
        listen_loop(state, callback_module)
    after
      4000 ->
        IO.puts("waited 4 eternities, still nothing happened... timeout")
        listen_loop(state, callback_module)
    end
  end

  def call(pid, message) do
    send(pid, {:call, self(), message})

    receive do
      {:response, response} -> response
    after
      3000 -> IO.puts("no response from server")
    end
  end

  def cast(pid, message) do
    send(pid, {:cast, message})
  end
end

defmodule Servy.FourOhFourCounter do
  @name :four_oh_four

  alias Servy.GenFourOhFourCounter, as: GenCounter
  # Server Processes: start & get_counts
  def start() do
    GenCounter.start(__MODULE__, %{}, @name)
  end

  # Client processes should be bump-count & get_count
  def bump_count(pathname) do
    GenCounter.call(@name, {:count, pathname})
  end

  def get_count(pathname) do
    GenCounter.call(@name, {:get_count, pathname})
  end

  def get_counts() do
    GenCounter.call(@name, :get_counts)
  end

  def clear() do
    GenCounter.cast(@name, :clear)
  end

  # Helpers
  def handle_cast(:clear, _state) do
    %{}
  end

  def handle_call({:count, pathname}, state) do
    new_state = Map.update(state, pathname, 1, &(&1 + 1))
    {:ok, new_state}
  end

  def handle_call({:get_count, pathname}, state) do
    count = Map.get(state, pathname)
    {count, state}
  end

  def handle_call(:get_counts, state) do
    {state, state}
  end
end
