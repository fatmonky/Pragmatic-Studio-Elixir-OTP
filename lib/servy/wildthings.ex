defmodule Servy.Wildthings do
  alias Servy.Bear

  def list_bears do
    Path.expand("../../db/", __DIR__)
    |> Path.join("bears.json")
    |> read_path
    |> Poison.decode!(as: %{"bears" => [%Bear{}]})
    |> Map.get("bears")
  end

  def read_path(filepath) do
    case File.read(filepath) do
      {:ok, content} ->
        # do something with content
        content

      {:error, reason} ->
        # return reason for error
        IO.inspect("File error: #{reason} when reading #{filepath}")
        "{\"bears\": []}"
    end
  end

  # def list_bears do
  #   [
  #     %Bear{id: 1, name: "Teddy", type: "Brown", hibernating: true},
  #     %Bear{id: 2, name: "Smokey", type: "Black"},
  #     %Bear{id: 3, name: "Paddington", type: "Brown"},
  #     %Bear{id: 4, name: "Scarface", type: "Grizzly", hibernating: true},
  #     %Bear{id: 5, name: "Snow", type: "Polar"},
  #     %Bear{id: 6, name: "Brutus", type: "Grizzly"},
  #     %Bear{id: 7, name: "Rosie", type: "Black", hibernating: true},
  #     %Bear{id: 8, name: "Roscoe", type: "Panda"},
  #     %Bear{id: 9, name: "Iceman", type: "Polar", hibernating: true},
  #     %Bear{id: 10, name: "Kenai", type: "Grizzly"}
  #   ]
  # end

  def get_bear(id) when is_integer(id) do
    Enum.find(list_bears(), fn b -> b.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    id |> String.to_integer() |> get_bear
  end
end
