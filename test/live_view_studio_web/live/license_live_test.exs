defmodule LiveViewStudioWeb.LicenseLiveTest do
  use LiveViewStudioWeb.ConnCase

  import Phoenix.LiveViewTest

  test "change seats updates amount", %{conn: conn} do
    {:ok, view, html} = live(conn, "/license")
    assert html =~ "$40.00"
    assert render(view) =~ "<strong>2</strong> seats"

    assert view
           |> element("form")
           |> render_change(%{seats: 5}) =~ "$100.00"
  end
end
