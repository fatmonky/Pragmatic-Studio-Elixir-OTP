defmodule Servy.Conv do
  defstruct method: "",
            path: "",
            resp_body: "",
            resp_headers: %{"Content-Type" => "text/html"},
            status: nil,
            params: %{},
            headers: %{}

  def full_status(%Servy.Conv{} = conv) do
    "#{conv.status} #{status_reason(conv.status)}"
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
