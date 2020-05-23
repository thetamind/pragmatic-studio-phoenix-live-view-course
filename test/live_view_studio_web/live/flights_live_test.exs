defmodule LiveViewStudioWeb.FlightsLiveTest do
  use LiveViewStudioWeb.ConnCase

  import Phoenix.LiveViewTest

  test "search by flight number", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/flights")

    pid = view.pid()
    :erlang.trace(pid, true, [:receive])

    assert view
           |> element("#search form")
           |> render_submit(%{number: "450"}) =~ "Loading..."

    ExUnit.Assertions.assert_receive(
      {:trace, ^pid, :receive, {:run_number_search, "450"}},
      3_000
    )

    assert render(view) =~ "Flight #450"

    short_date = Timex.now() |> Timex.shift(days: 1) |> Timex.format!("{Mshort} {D}")

    assert element(view, ".arrives", short_date) |> render() =~
             "Arrives: #{short_date} at"
  end

  test "search by flight number no results", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/flights")

    pid = view.pid()
    :erlang.trace(pid, true, [:receive])

    assert view
           |> element("#search form")
           |> render_submit(%{number: "00000"}) =~ "Loading..."

    ExUnit.Assertions.assert_receive(
      {:trace, ^pid, :receive, {:run_number_search, "00000"}},
      3_000
    )

    assert render(view) =~ "No flights matching"
  end
end
