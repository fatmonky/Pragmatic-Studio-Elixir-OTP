defmodule Servy.PledgeServerTest do
  use ExUnit.Case

  alias Servy.PledgeServer

  test "server caches only 3 most recent pledges, and totals amounts" do
    {:ok, pid} = Servy.PledgeServer.start()
    PledgeServer.set_cache_size(3)
    PledgeServer.create_pledge("larry", 10)
    PledgeServer.create_pledge("moe", 20)
    PledgeServer.create_pledge("curly", 30)
    PledgeServer.create_pledge("daisy", 40)
    PledgeServer.create_pledge("grace", 50)

    no_recent_pledges = PledgeServer.recent_pledges() |> Enum.count()
    totals = 30 + 40 + 50
    assert no_recent_pledges == 3
    assert PledgeServer.total_pledges() == totals
  end
end
