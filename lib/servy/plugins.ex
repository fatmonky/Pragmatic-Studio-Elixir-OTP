defmodule Servy.Plugins do
  @doc "Logs 404 requests"
  def track(%{status: 404, path: path} = conv) do
    # Logger.warn("#{path} is awry")
    IO.puts("Warning: #{path} is on the loose!")
    conv
  end

  def track(conv) do
    # Logger.info("all normal here")
    conv
  end

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%{path: "/bears?id=" <> id} = conv) do
    %{conv | path: "/bears/#{id}"}
  end

  def rewrite_path(conv), do: conv

  def log(conv), do: IO.inspect(conv)
end
