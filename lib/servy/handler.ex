# require Logger

defmodule Servy.Handler do
  @moduledoc "Handles HTTP requests."

  @pages_path Path.expand("../../pages", __DIR__)

  alias Servy.Conv
  alias Servy.BearController
  alias Servy.VideoCam

  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.FileHandler, only: [handle_file: 2, handle_form: 2]

  @doc "Transforms the request into a request"
  def handler(request) do
    request
    |> parse
    |> rewrite_path
    # |> log
    |> route
    |> track
    # |> emojify
    |> put_content_length
    |> format_response
  end

  @doc """
  adds emoji to %Conv{resp_body} based on conv.status.
  ## Examples
  #iex >  test_struct = %Conv{status: 200, resp_body: "hello!"}
  iex > Servy.Handler.emojify(test_struct)
  %Conv{status:200, resp_body: "😃" <>"\n"<>"hello!"<>"\n"<>"😃"}
  iex > test_struct2 = %Conv{status: 403, resp_body: "world!"}
  iex > Servy.Handler.emojify(test_struct2)
  %Conv{status:403, resp_Body: "🤬"<>"\n"<>"world!"<>"\n"<>"🤬"}
  """
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

  def put_content_length(conv) do
    content_length = byte_size(conv.resp_body)
    %{conv | resp_headers: Map.put(conv.resp_headers, "Content-Length", content_length)}
  end

  def route(%Conv{method: "GET", path: "/snapshots"} = conv) do
    # the request handling process
    parent = self()

    spawn(fn -> send(parent, {:result, VideoCam.get_snapshot("cam-1")}) end)
    spawn(fn -> send(parent, {:result, VideoCam.get_snapshot("cam-2")}) end)
    spawn(fn -> send(parent, {:result, VideoCam.get_snapshot("cam-3")}) end)

    snapshot1 =
      receive do
        {:result, filename} -> filename
      end

    snapshot2 =
      receive do
        {:result, filename} -> filename
      end

    snapshot3 =
      receive do
        {:result, filename} -> filename
      end

    snapshots = [snapshot1, snapshot2, snapshot3]

    %{conv | status: 200, resp_body: inspect(snapshots)}
  end

  def route(%Conv{method: "GET", path: "/hibernate/" <> time} = conv) do
    time |> String.to_integer() |> :timer.sleep()

    %{conv | status: 200, resp_body: "Awake!"}
  end

  def route(%Conv{method: "GET", path: "/kaboom"} = conv) do
    raise "Kaboom!"
  end

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

  def route(%Conv{method: "GET", path: "/pages/" <> name} = conv) do
    @pages_path
    |> Path.join("#{name}.md")
    |> File.read()
    |> handle_file(conv)
    |> markdown_to_html

    # model answer: declare markdown_to_html function, instead of calling Earmark.as_html directly
  end

  # function clause approach
  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read()
    |> handle_form(conv)
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    Servy.Api.BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> _id} = conv) do
    BearController.delete(conv, conv.params)
  end

  # name=Baloo&type=Brown
  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  # ch 19 Ex 2 Handle POSTed JSON data
  def route(%Conv{method: "POST", path: "/api/bears"} = conv) do
    Servy.Api.BearController.create_bears(conv, conv.params)
  end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} found!"}
  end

  def markdown_to_html(%Conv{status: 200} = conv) do
    %{conv | resp_body: Earmark.as_html!(conv.resp_body)}
  end

  def markdown_to_html(%Conv{} = conv), do: conv

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: #{conv.resp_headers["Content-Type"]}\r
    Content-Length: #{conv.resp_headers["Content-Length"]}\r
    \r
    #{conv.resp_body}
    """
  end
end

# request = """
# GET /wildthings HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handler(request)

# IO.puts(response)

# request = """
# GET /bears HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handler(request)

# IO.puts(response)

# request = """
# GET /bigfoot HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handler(request)

# IO.puts(response)

# request = """
# GET /bears/1 HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handler(request)

# IO.puts(response)

# request = """
# GET /wildlife HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handler(request)

# IO.puts(response)

# request = """
# GET /about HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handler(request)

# IO.puts(response)

# request = """
# POST /bears HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*
# Content-Type: application/x-www-form-urlencoded
# Content-Length: 21

# name=Baloo&type=Brown
# """

# response = Servy.Handler.handler(request)

# IO.puts(response)

# # ch 15 exercise
# # # Exercise - add Delete request

# request = """
# DELETE /bears/1 HTTP/1.1
# Host: example.com
# User-Agent: ExampleBrowser/1.0
# Accept: */*

# """

# response = Servy.Handler.handler(request)

# IO.puts(response)
