# Ex: write a simple timer
defmodule Timer do
  def remind(msg, secs) do
    spawn(fn ->
      (secs * 1000) |> :timer.sleep()
      IO.puts(msg)
    end)
  end
end

Timer.remind("Stand Up", 5)
Timer.remind("Sit Down", 10)
Timer.remind("Fight, Fight, Fight", 15)

# note to self: didn't use spawn in initial answer, as wasn't clear from instructions that we need to use spawn

# Ex: super mega spawn
# Ex: get comfortable with Observer
# Both exercises are done in IEX and with Erlang observer, not through coding.
#
# Ex: write an HTTP server test

defmodule Servy.HttpServerTest do
  use ExUnit


end
