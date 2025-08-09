defmodule Servy.PledgeServer do
  def listen_loop(cache) do
    IO.puts("\nWaiting for a message...")

    receive do
      {:create_pledge, name, amount} ->
        {:ok, id} = send_pledge_to_service(name, amount)
        new_state = [{name, amount} | cache]
        IO.puts("#{name} donated #{amount}")
        IO.puts("New state is #{inspect(new_state)}")
        # recursion to listen for another message
        listen_loop(new_state)

      {sender, :recent_pledges} ->
        send(sender, {:response, cache})
        IO.puts("Sent pledges to #{inspect(sender)}")
        listen_loop(cache)
    end
  end

  # def create_pledge(name, amount) do
  #   {:ok, id} = send_pledge_to_service(name, amount)
  #   # optional - add case statement to handle errors if pledge cannot be created
  #   #
  #   # Cache the pledge:
  #   [{"Larry", 10}]
  # end

  # def recent_pledges do
  #   # return most recent pledges (from cache):
  #   #
  #   # Where to store cache?? Modules CANNOT HOLD STATE, but processes can!
  # end

  defp send_pledge_to_service(_name, _amount) do
    # code to simulate sending pledge to external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end
