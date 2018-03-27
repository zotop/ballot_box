defmodule ViewTest do
  use ExUnit.Case
  doctest View

  test "greets the world" do
    assert View.hello() == :world
  end
end
