defmodule LiveViewStudioWeb.SandboxLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  @sandbox_component "form[phx-change=calculate]"
  @delivery_component "form[phx-change=calculate-delivery]"

  test "calculate weight", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/sandbox")

    view |> form(@sandbox_component, %{length: 1, width: 1, depth: 1}) |> render_change()

    assert view |> element(".weight") |> render() =~ "7.3 pounds"
  end

  test "get quote", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/sandbox")

    view |> form(@sandbox_component, %{length: 2, width: 4, depth: 8}) |> render_change()

    assert view |> element(".weight") |> render() =~ "467.2 pounds"

    view |> form(@sandbox_component) |> render_submit()

    assert view |> element("#sandbox h3") |> render() =~ "467.2 pounds of sand for $700.80"
  end

  test "calculate delivery charge", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/sandbox")

    view |> form(@delivery_component, %{zip: 80134}) |> render_change()
    view |> form(@sandbox_component) |> render_submit()

    assert view |> element(@delivery_component <> " .unit") |> render() =~ "$16.00"
    assert view |> element("#sandbox h3") |> render() =~ "plus $16.00 delivery"
  end
end
