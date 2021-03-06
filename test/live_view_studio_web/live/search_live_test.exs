defmodule LiveViewStudioWeb.SearchLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "search by zip code", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/search")

    pid = view.pid()
    :erlang.trace(pid, true, [:receive])

    assert view
           |> element("#search form")
           |> render_submit(%{zip: "80204"}) =~ "Loading..."

    ExUnit.Assertions.assert_receive(
      {:trace, ^pid, :receive, {:run_zip_search, "80204"}},
      3_000
    )

    assert render(view) =~ "Denver"
  end

  test "search by zip code no results", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/search")

    pid = view.pid()
    :erlang.trace(pid, true, [:receive])

    assert view
           |> element("#search form")
           |> render_submit(%{zip: "00000"}) =~ "Loading..."

    ExUnit.Assertions.assert_receive(
      {:trace, ^pid, :receive, {:run_zip_search, "00000"}},
      3_000
    )

    assert render(view) =~ "No stores matching"
  end
end
