defmodule Servy.PledgeServer do
  def create_pledge(name, amount) do
    {:ok, id} = send_pledge_to_service(name, amount)
    # optional - add case statement to handle errors if pledge cannot be created
    #
    # Cache the pledge:
    [{"Larry", 10}]
  end

  defp send_pledge_to_service(_name, _amount) do
    # code to simulate sending pledge to external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  def recent_pledges do
    # return most recent pledge:
    #
    # Where to store cache?? Modules CANNOT HOLD STATE, but processes can!
  end
end
