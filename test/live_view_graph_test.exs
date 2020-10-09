defmodule LiveViewGraphTest do
  use ExUnit.Case, async: true

  # modules = Code.require_file("live_view_graph.ex", ".")
  # IO.puts Enum.count(modules)
  require LiveViewGraph.Reporter

  describe "find_event/1" do
    test "3-tuple args" do
      input = "send(self(), {:totals, weight, price})"

      assert LiveViewGraph.Reporter.find_event(input) == :totals
    end
  end
end
