# require Logger

defmodule Servy.Handler do
  @moduledoc "Handles HTTP requests."

  @pages_path Path.expand("../../pages", __DIR__)

  alias Servy.Conv

  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.FileHandler, only: [handle_file: 2, handle_form: 2]

  @doc "Transforms the request into a request"
  def handler(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> emojify
    |> format_response
  end

  def emojify(%Conv{status: 200} = conv) do
    emojies = "😃"
    emojified_resp_body = emojies <> "\n" <> conv.resp_body <> "\n" <> emojies
    %{conv | resp_body: emojified_resp_body}
  end

  def emojify(%Conv{status: 403} = conv) do
    emojies = "🤬"
    emojified_resp_body = emojies <> "\n" <> conv.resp_body <> "\n" <> emojies
    %{conv | resp_body: emojified_resp_body}
  end

  def emojify(%Conv{} = conv), do: conv

  # def route(conv) do
  # route(conv, conv.method, conv.path)
  # end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{
      conv
      | status: 200,
        resp_body: "Bears, Lions, Tigers, Tapirs"
    }
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conv)
  end

  # def route(%{method: "GET", path: "/about"} = conv) do
  #   file =
  #     Path.expand("../../pages", __DIR__)
  #     |> Path.join("about.html")

  #   case File.read(file) do
  #     {:ok, content} ->
  #       %{conv | status: 200, resp_body: content}

  #     {:error, :enoent} ->
  #       %{conv | status: 404, resp_body: "File not found!"}

  #     {:error, reason} ->
  #       %{conv | status: 500, resp_body: "File error: #{reason}"}
  #   end
  # end

  # ch9 Exercise read HTML form file
  # case
  # def route(%{method: "GET", path: "/bears/new"} = conv) do
  #   file =
  #     Path.expand("../../pages/", __DIR__)
  #     |> Path.join("form.html")

  #   case File.read(file) do
  #     {:ok, content} ->
  #       %{conv | status: 200, resp_body: content}

  #     {:error, :enoent} ->
  #       %{conv | status: 404, resp_body: "File not found!"}

  #     {:error, reason} ->
  #       %{conv | status: 500, resp_body: "File error: #{reason}"}
  #   end
  # end

  # function clause approach
  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read()
    |> handle_form(conv)
  end

  # ch9 handle arbitrary page files
  def route(%Conv{path: "/pages/" <> page} = conv) do
    file =
      Path.expand("../../pages/", __DIR__)
      |> Path.join(page)

    case File.read(file) do
      {:ok, content} ->
        %{conv | status: 200, resp_body: content}

      {:error, :enoent} ->
        %{conv | status: 404, resp_body: "File not found!"}

      {:error, reason} ->
        %{conv | status: 500, resp_body: "File error: #{reason} "}
    end
  end

  # Model answer from the Clarks: (but noted that this isn't what you'll want to do in prod!)
  # def route(%{method: "GET", path: "/pages/" <> file} = conv) do
  #   Path.expand("../../pages", __DIR__)
  #   |> Path.join(file <> ".html")
  #   |> File.read
  #   |> handle_file(conv)
  # end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    %{conv | status: 200, resp_body: "Pandas, Black, Sun"}
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    %{conv | status: 200, resp_body: "Bear #{id}"}
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    %{conv | status: 200, resp_body: "contents of a file"}
  end

  def route(%Conv{method: "DELETE", path: "/bears" <> _id} = conv) do
    %{conv | status: 403, resp_body: "Deleting a bear is forbidden!"}
  end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} found!"}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{byte_size(conv.resp_body)}

    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handler(request)

IO.puts(response)

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handler(request)

IO.puts(response)

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handler(request)

IO.puts(response)

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handler(request)

IO.puts(response)

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handler(request)

IO.puts(response)

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handler(request)

IO.puts(response)

# Exercise - add Delete request
request = """
DELETE /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handler(request)

IO.puts(response)

# ch 8 Exercise - add query request
request = """
GET /bears?id=1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handler(request)

IO.puts(response)

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handler(request)

IO.puts(response)

# ch9 - Exercise
request = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handler(request)

IO.puts(response)

# ch9 - Exercise Arbitrary files
request = """
GET /pages/contact HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handler(request)

IO.puts(response)

request = """
GET /pages/faq HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handler(request)

IO.puts(response)

request = """
GET /pages/wtf HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handler(request)

IO.puts(response)
