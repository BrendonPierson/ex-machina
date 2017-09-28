defmodule MLTest do
  use ExUnit.Case
  doctest ML

  test "greets the world" do
    assert ML.hello() == :world
  end
end
