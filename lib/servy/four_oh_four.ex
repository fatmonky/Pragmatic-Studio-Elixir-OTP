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
        new_state = Map.update(state, pathname, 1, &(&1 + 1))
        listen_loop(new_state)

      {:cast, :clear} ->
        new_state = handle_cast(:clear)
        listen_loop(new_state)

      {pid, :get_count, pathname} ->
        count = Map.get(state, pathname)
        send(pid, {:listen_loop, count})
        listen_loop(state)

      {pid, :get_counts} ->
        send(pid, {:listen_loop, state})
        listen_loop(state)

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
    send(:listen_loop, {pid, :get_count, pathname})

    receive do
      {:listen_loop, count} -> count
    after
      3000 -> IO.puts("couldn't get count")
    end
  end

  def get_counts() do
    pid = self()
    send(:listen_loop, {pid, :get_counts})

    receive do
      {:listen_loop, state} -> state
    after
      3000 -> IO.puts("couldn't get counts")
    end
  end

  def clear() do
    cast(:clear)
  end

  # Helpers

  def call() do
  end

  def cast(message) do
    send(:listen_loop, {:cast, message})
  end

  def handle_cast(:clear) do
    %{}
  end

  # def handle_cast(:count, pathname, state) do
  #   new_state = Map.update(state, pathname, 1, &(&1 + 1))
  #   new_state
  # end

  # def handle_call(message) do
  #   case message do
  #     {:cast, :count, pathname} ->
  #       new_state = Map.update(state, pathname, 1, &(&1 + 1))
  #   end
  # end
end
