defmodule LiveViewStudioWeb.PageLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Welcome to Phoenix!"
    assert render(page_live) =~ "Welcome to Phoenix!"
  end

  test "table of contents", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    element(view, ".examples a", "Light") |> render_click()
    assert_redirected(view, "/light")

    {:ok, view, _html} = live(conn, "/")
    element(view, ".examples a", "Team License") |> render_click()
    assert_redirected(view, "/license")

    {:ok, view, _html} = live(conn, "/")
    element(view, ".examples a", "Filter") |> render_click()
    assert_redirected(view, "/filter")

    {:ok, view, _html} = live(conn, "/")
    element(view, ".examples a", "Vehicles") |> render_click()
    assert_redirected(view, "/vehicles")
  end

  test "return to home", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/light")

    {:ok, view, _html} = element(view, "a.home") |> render_click() |> follow_redirect(conn, "/")

    {:ok, view, _html} =
      element(view, ".examples a", "Sales Dashboard")
      |> render_click()
      |> follow_redirect(conn, "/sales_dashboard")

    {:ok, _view, _html} = element(view, "a.home") |> render_click() |> follow_redirect(conn, "/")
  end
end
