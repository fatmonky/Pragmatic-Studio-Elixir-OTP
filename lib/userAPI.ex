defmodule UserAPI do
  # send request to API

  def query(id) do
    api_url(id)
    |> HTTPoison.get()
    |> handle_response
  end

  defp api_url(id) do
    "https://jsonplaceholder.typicode.com/users/" <> id
  end

  # handle response tuples
  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    city = Poison.Parser.parse!(body, %{}) |> get_in(["address", "city"])
    {:ok, city}
  end

  # error case 1
  defp handle_response({:ok, %{status_code: _status, body: body}}) do
    message = Poison.Parser.parse!(body, %{}) |> get_in(["message"])
    {:error, message}
  end

  # error case 2
  defp handle_response({:error, %{reason: reason}}) do
    {:error, reason}
  end
end
