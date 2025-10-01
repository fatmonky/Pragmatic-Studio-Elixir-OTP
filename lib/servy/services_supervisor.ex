defmodule Servy.ServicesSupervisor do
  use Supervisor

  def start_link() do
    IO.puts "Starting Supervisor..."
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    #this is where Supervisor is told what processes to supervise
   children = [Servy.PledgeServer, Servy.SensorServer]
   Supervisor.init(children, strategy: :one_for_one)
  end
end
