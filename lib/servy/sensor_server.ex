defmodule State do
  defstruct sensor_data: %{}, refresh_interval: :timer.seconds(5)
end

defmodule Servy.SensorServer do
  @name :sensor_server
  # prod will be :timer.minutes(60)
  @refresh_interval :timer.seconds(5)
  use GenServer

  # Client Interface

  def start do
    GenServer.start(__MODULE__, %State{}, name: @name)
  end

  def get_sensor_data do
    GenServer.call(@name, :get_sensor_data)
  end

  # Server Callbacks

  def init(_state.sensor_data) do
    initial_state = run_tasks_to_get_sensor_data()
    refresh_message()
    {:ok, initial_state}
  end

  def handle_info(:refresh, _state.sensor_data) do
    IO.puts("Refresh the cache...")
    new_state = run_tasks_to_get_sensor_data()
    refresh_message()
    {:noreply, new_state}
  end

  defp refresh_message do
    Process.send_after(self(), :refresh, @refresh_interval)
  end

  def set_refresh_interval(state.refresh_interval) do
    %State{state.refresh_interval | refresh_interval: state.refresh_interval}
  end

  def handle_call(:get_sensor_data, _from, state.sensor_data) do
    {:reply, state.sensor_data, state.sensor_data}
  end

  defp run_tasks_to_get_sensor_data do
    IO.puts("Running tasks to get sensor data...")

    task = Task.async(fn -> Servy.Tracker.get_location("bigfoot") end)

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> Servy.VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await/1)

    where_is_bigfoot = Task.await(task)

    %{snapshots: snapshots, location: where_is_bigfoot}
  end
end
