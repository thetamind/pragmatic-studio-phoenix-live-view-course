defmodule LiveViewStudioWeb.AutocompleteLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "populate search fields from url params", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/autocomplete?zip=80204")

    assert element(view, "#zip-form input[name=zip]") |> render() =~ "80204"

    {:ok, view, _html} = live(conn, "/autocomplete?city=Vancouver")

    assert element(view, "#city-form input[name=city]") |> render() =~ "Vancouver"
  end

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
    assert element(view, "#zip-form input[name=zip]") |> render() =~ "80204"
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

  test "search by city", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/autocomplete")

    pid = view.pid()
    :erlang.trace(pid, true, [:receive])

    assert view
           |> element("#city-form")
           |> render_submit(%{city: "Denver, CO"}) =~ "Loading..."

    ExUnit.Assertions.assert_receive(
      {:trace, ^pid, :receive, {:run_city_search, "Denver, CO"}},
      3_000
    )

    assert render(view) =~ "Denver"
  end

  test "search by city no results", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/autocomplete")

    pid = view.pid()
    :erlang.trace(pid, true, [:receive])

    assert view
           |> element("#city-form")
           |> render_submit(%{city: "Nullville"}) =~ "Loading..."

    ExUnit.Assertions.assert_receive(
      {:trace, ^pid, :receive, {:run_city_search, "Nullville"}},
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
