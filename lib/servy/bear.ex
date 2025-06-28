defmodule Servy.Bear do
  defstruct id: nil, name: "", type: "", hibernating: false

  def is_grizzly(bear) do
    bear.type == "Grizzly"
  end

  def sort_bears_asc(bear1, bear2) do
    bear1.name <= bear2.name
  end
end
