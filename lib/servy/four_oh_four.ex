defmodule Servy.GenFourOhFourCounter do
  def start(callback_module) do
    # start server process
    pid = spawn(fn -> callback_module.listen_loop() end)
    Process.register(pid, :listen_loop)
    pid
  end
end

defmodule Servy.FourOhFourCounter do
  alias Servy.GenFourOhFourCounter
  # Server Processes: start & get_counts
  def start() do
    GenFourOhFourCounter.start(__MODULE__)
  end

  def listen_loop(state \\ %{}) do
    # receive-do for incoming message
    receive do
      {:cast, {:count, pathname}} ->
        new_state = handle_cast(:count, pathname, state)
        listen_loop(new_state)

      {:cast, :clear} ->
        new_state = handle_cast(:clear)
        listen_loop(new_state)

      {:call, {pid, :get_count, pathname}} ->
        # new_state = handle_call({pid, :get_count, pathname}, state)
        count = Map.get(state, pathname)
        send(pid, {:listen_loop, count})
        listen_loop(state)

      {:call, {pid, :get_counts}} ->
        new_state = handle_call({pid, :get_counts}, state)
        listen_loop(new_state)

      unexpected ->
        IO.puts("received unexpected stuff in messages! #{unexpected}")
        listen_loop(state)
    after
      4000 ->
        IO.puts("waited 4 eternities, still nothing happened... timeout")
        listen_loop(state)
    end
  end

  # Client processes should be bump-count & get_count
  def bump_count(pathname) do
    cast({:count, pathname})
  end

  def get_count(pathname) do
    pid = self()
    call({pid, :get_count, pathname})
  end

  def get_counts() do
    pid = self()
    call({pid, :get_counts})
  end

  def clear() do
    cast(:clear)
  end

  # Helpers

  def call(message) do
    send(:listen_loop, {:call, message})

    receive do
      {:listen_loop, response} -> response
    after
      3000 -> IO.puts("no response from server")
    end
  end

  def cast(message) do
    send(:listen_loop, {:cast, message})
  end

  def handle_cast(:clear) do
    %{}
  end

  def handle_cast(:count, pathname, state) do
    new_state = Map.update(state, pathname, 1, &(&1 + 1))
    new_state
  end

  def handle_call({pid, :get_count, pathname}, state) do
    count = Map.get(state, pathname)
    send(pid, {:listen_loop, count})
    count
  end

  def handle_call({pid, :get_counts}, state) do
    send(pid, {:listen_loop, state})
    state
  end
end
