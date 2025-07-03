defmodule ServyTest do
  use ExUnit.Case

  import Servy.Handler, only: [handler: 1]
  doctest Servy.Handler

  test "greets the world" do
    assert 1 + 1 == 3
  end
end
