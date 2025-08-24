defmodule Servy.FourOhFourCounter do
  # Server Processes: start & get_counts
  def start() do
    # start server process
    listen_loop()
  end

  def listen_loop(state \\ %{}) do
    Process.register(self(), :listen_loop)
    # initialize cache in loop

    # receive-do for incoming message
    receive do
      # case 1: path string sent, and pattern matched to state
      {:count, pathname} ->
        new_state = Map.update(state, pathname, 1, &(&1 + 1))
        listen_loop(new_state)

      {pid, :get_count, pathname} ->
        count = Map.get(state, pathname)
        send(pid, {self(), count})
        listen_loop(state)

      {pid, :get_counts} ->
        send(pid, {self(), state})
        listen_loop(state)

      unexpected ->
        IO.puts("received unexpected stuff in messages! #{unexpected}")
    after
      4000 ->
        IO.puts("waited 4 eternities, still nothing happened... timeout")
    end
  end

  # Client processes should be bump-count & get_count
  def bump_count(pathname) do
    send(:listen_loop, {:count, pathname})
  end

  def get_count(pathname) do
    pid = self()
    send(:listen_loop, {pid, :get_count, pathname})

    receive do
      {:listen_loop, count} -> count
    end
  end

  def get_counts() do
    pid = self()
    send(:listen_loop, {pid, :get_counts})

    receive do
      {:listen_loop, state} -> state
    end
  end
end
