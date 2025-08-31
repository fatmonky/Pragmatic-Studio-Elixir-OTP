defmodule Servy.GenFourOhFourCounter do
  alias Servy.FourOhFourCounter, as: Counter

  def start() do
    # start server process
    pid = spawn(fn -> listen_loop() end)
    Process.register(pid, :listen_loop)
    pid
  end

  def listen_loop(state \\ %{}) do
    # receive-do for incoming message
    receive do
      {:cast, message} ->
        case message do
          {:count, pathname} ->
            new_state = Counter.handle_cast(:count, pathname, state)
            listen_loop(new_state)

          :clear ->
            new_state = Counter.handle_cast(:clear)
            listen_loop(new_state)
        end

      {:call, message} ->
        case message do
          {pid, :get_count, pathname} ->
            _count = Counter.handle_call({pid, :get_count, pathname}, state)
            listen_loop(state)

          {pid, :get_counts} ->
            new_state = Counter.handle_call({pid, :get_counts}, state)
            listen_loop(new_state)
        end

      unexpected ->
        IO.puts("received unexpected stuff in messages! #{unexpected}")
        listen_loop(state)
    after
      4000 ->
        IO.puts("waited 4 eternities, still nothing happened... timeout")
        listen_loop(state)
    end
  end

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
end

defmodule Servy.FourOhFourCounter do
  alias Servy.GenFourOhFourCounter, as: GenCounter
  # Server Processes: start & get_counts
  def start() do
    GenCounter.start()
  end

  # Client processes should be bump-count & get_count
  def bump_count(pathname) do
    GenCounter.cast({:count, pathname})
  end

  def get_count(pathname) do
    pid = self()
    GenCounter.call({pid, :get_count, pathname})
  end

  def get_counts() do
    pid = self()
    GenCounter.call({pid, :get_counts})
  end

  def clear() do
    GenCounter.cast(:clear)
  end

  # Helpers
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
