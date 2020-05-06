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
           |> element("form")
           |> render_change(%{brightness: 75}) =~ "75%"
  end
end
