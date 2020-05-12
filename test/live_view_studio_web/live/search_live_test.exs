defmodule LiveViewStudioWeb.SearchLiveTest do
  use LiveViewStudioWeb.ConnCase

  import Phoenix.LiveViewTest

  test "search by zip code", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/search")

    assert view
           |> element("#search form")
           |> render_submit(%{zip: "80204"}) =~ "Denver"
  end
end
