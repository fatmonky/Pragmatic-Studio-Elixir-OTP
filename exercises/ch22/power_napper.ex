parent = self()

power_nap = fn ->
  time = :rand.uniform(10_000)
  :timer.sleep(time)
  time
end

spawn(fn ->
  time = power_nap.()
  send(parent, {:slept, time})
end)

naptime =
  receive do
    {:slept, time} -> time
  end

IO.puts("Slept #{naptime}ms")

# model answer:
# parent = self()

# spawn(fn -> send(parent, {:slept, power_nap.()}) end)

# receive do
#   {:slept, time} -> IO.puts "Slept #{time} ms"
# end
