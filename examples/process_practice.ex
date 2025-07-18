defmodule PingPong do
  def ping do
    receive do
      {:ping, sender} ->
        IO.puts("ping process received `ping`, sending `pong`")
        send(sender, {:pong, self()})
        # loop again if needed
        ping()
    after
      1000 ->
        IO.puts("ping process timed out")
    end
  end

  def pong do
    receive do
      {:pong, sender} ->
        IO.puts("pong process received `pong`, sending `ping`")
        send(sender, {:ping, self()})
        # loop again if needed
        pong()
    after
      1000 ->
        IO.puts("pong process timed out")
    end
  end

  def start do
    pid1 = spawn(fn -> ping() end)
    pid2 = spawn(fn -> pong() end)

    # Kick off the ping-pong by sending the first message
    send(pid1, {:ping, pid2})

    IO.inspect(pid1, label: "Ping PID")
    IO.inspect(pid2, label: "Pong PID")
  end
end

PingPong.start()
