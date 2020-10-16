Code.require_file("live_view_graph.ex", "priv")

defmodule LiveViewGraphTest do
  use ExUnit.Case, async: true

  describe "find_event/1" do
    test "bare arg" do
      input = "send(self(), :refresh)" |> Code.string_to_quoted!()
      assert LiveViewGraph.Reporter.find_event(input) == :refresh
    end

    test "2-tuple args" do
      input = "send(self(), {:delivery_charge, charge})" |> Code.string_to_quoted!()
      assert LiveViewGraph.Reporter.find_event(input) == :delivery_charge
    end

    test "3-tuple args" do
      input = "send(self(), {:totals, weight, price})" |> Code.string_to_quoted!()

      assert LiveViewGraph.Reporter.find_event(input) == :totals
    end
  end
end
