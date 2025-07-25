defmodule Servy.Fetcher do
  def async(func) do
    parent = self()

    spawn(fn -> send(parent, {self(), :result, func.()}) end)
  end

  def get_result(pid) do
    receive do
      {^pid, :result, value} -> value
    end
  end
end
