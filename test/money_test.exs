defmodule MoneyTest do
  use ExUnit.Case
  doctest Money

  test "greets the world" do
    assert Money.hello() == :world
  end
end
