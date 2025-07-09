defmodule UserApi do
  use HTTPoison

  # send request

  def query(id) do
    HTTPoison.get("https://jsonplaceholder.typicode.com/users/1")
  end
end
