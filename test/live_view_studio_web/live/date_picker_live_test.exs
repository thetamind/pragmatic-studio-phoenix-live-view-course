defmodule LiveViewStudioWeb.DatePickerLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "date-picked hook renders comforting expression", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/datepicker")

    assert view
           |> element("#date-picker-input")
           |> render_hook("date-picked", %{date: "October 07, 2020"}) =~
             "See you on October 07, 2020!"
  end
end
