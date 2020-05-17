defmodule LiveViewStudioWeb.LightLiveTest do
  use LiveViewStudioWeb.ConnCase

  import Phoenix.LiveViewTest

  test "turn light on", %{conn: conn} do
    {:ok, view, html} = live(conn, "/light")
    assert html =~ "10%"
    assert render(view) =~ "10%"

    assert view
           |> element("#light > div:nth-child(2) > button:nth-child(4)")
           |> render_click() =~ "100%"
  end

  test "dimmer for light", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/light")

    assert view
           |> element("#dimmer-form")
           |> render_change(%{brightness: 75}) =~ "75%"
  end

  test "toggle light colour", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/light")
    assert element(view, "#light .meter span") |> render() =~ "#F1C40D"

    view
    |> element("#temp-form")
    |> render_change(%{temp: "4000"})

    assert element(view, "#light .meter span") |> render() =~ "#FEFF66"
  end
end
