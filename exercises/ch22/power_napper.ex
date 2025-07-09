defmodule Nap do
  parent = self()
  power_nap = fn ->
    time = :rand.uniform(10_000)
    :timer.sleep(time)
    time
  end

  spawn(power_nap; send(parent, ))
end
