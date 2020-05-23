defmodule LiveViewStudioWeb.AutocompleteLiveTest do
  use LiveViewStudioWeb.ConnCase

  import Phoenix.LiveViewTest

  test "search by zip code", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/autocomplete")

    pid = view.pid()
    :erlang.trace(pid, true, [:receive])

    assert view
           |> element("#zip-form")
           |> render_submit(%{zip: "80204"}) =~ "Loading..."

    ExUnit.Assertions.assert_receive(
      {:trace, ^pid, :receive, {:run_zip_search, "80204"}},
      3_000
    )

    assert render(view) =~ "Denver"
  end

  test "search by zip code no results", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/autocomplete")

    pid = view.pid()
    :erlang.trace(pid, true, [:receive])

    assert view
           |> element("#zip-form")
           |> render_submit(%{zip: "00000"}) =~ "Loading..."

    ExUnit.Assertions.assert_receive(
      {:trace, ^pid, :receive, {:run_zip_search, "00000"}},
      3_000
    )

    assert render(view) =~ "No stores matching"
  end

  test "autocomplete city", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/autocomplete")

    assert view
           |> element("#city-form")
           |> render_change(%{city: "Cle"})

    html = element(view, "#matches") |> render()
    assert html =~ "Clearwater"
    assert html =~ "Cleveland"
  end
end
