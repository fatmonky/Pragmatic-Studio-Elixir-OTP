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
      {:count, _pathname, count} ->
        new_state = %{state | pathname: count + 1}
        listen_loop(new_state)

      {^pid, :get_count, pathname} ->
        send(pid, state.pathname)
        listen_loop(state)

      {:get_counts} ->
        send(pid, state)
        listen_loop(state)
    end
  end

  # Client processes should be bump-count & get_count
  def bump_count(pathname) do
    send(:listen_loop, {:count, pathname, 1})
  end

  def get_count(pathname) do
    pid = self()
    send(:listen_loop, {pid, :get_count, pathname})
  end

  def get_counts() do
    send(:listen_loop, {:get_counts})
  end
end
