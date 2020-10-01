defmodule LiveViewStudioWeb.SandboxLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "calculate weight", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/sandbox")

    view |> form("form", %{length: 1, width: 1, depth: 1}) |> render_change()

    assert view |> element(".weight") |> render() =~ "7.3 pounds"
  end

  test "get quote", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/sandbox")

    view |> form("form", %{length: 2, width: 4, depth: 8}) |> render_change()

    assert view |> element(".weight") |> render() =~ "467.2 pounds"

    view |> form("form") |> render_submit()

    assert view |> element("#sandbox h3") |> render() =~ "467.2 pounds of sand for $700.80"
  end
end
