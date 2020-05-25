defmodule LiveViewStudioWeb.FilterLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  alias LiveViewStudio.Boats.Boat
  alias LiveViewStudio.Repo

  setup [:fixtures]

  test "filter by type", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/filter")

    assert element(view, ".boats .card .model", "1850 Super Hawk") |> render()

    html =
      view
      |> element("#filter form")
      |> render_change(%{type: "sailing"})

    assert html =~ "RS Quest"
    refute html =~ "1850 Super Hawk"
  end

  test "filter by prices", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/filter")

    assert element(view, ".boats .card .model", "Deep Sea Elite") |> render()

    html =
      view
      |> element("#filter form")
      |> render_change(%{prices: ["$", "$$"]})

    assert html =~ "RS Quest"
    assert html =~ "1850 Super Hawk"
    refute html =~ "Deep Sea Elite"
  end

  test "clear filters", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/filter")

    assert element(view, ".boats .card .model", "Deep Sea Elite") |> render()

    html =
      view
      |> element("#filter form")
      |> render_change(%{type: "sailing", prices: ["$", "$$"]})

    assert html =~ "RS Quest"
    refute html =~ "1850 Super Hawk"
    refute html =~ "Deep Sea Elite"

    html = render_click(view, "clear-filters")

    assert html =~ "RS Quest"
    assert html =~ "1850 Super Hawk"
    assert html =~ "Deep Sea Elite"
  end

  defp fixtures(_context) do
    %Boat{
      model: "1850 Super Hawk",
      price: "$$",
      type: "fishing",
      image: "/images/boats/1850-super-hawk.jpg"
    }
    |> Repo.insert!()

    %Boat{
      model: "RS Quest",
      price: "$",
      type: "sailing",
      image: "/images/boats/rs-quest.jpg"
    }
    |> Repo.insert!()

    %Boat{
      model: "Deep Sea Elite",
      price: "$$$",
      type: "fishing",
      image: "/images/boats/deep-sea-elite.jpg"
    }
    |> Repo.insert!()

    :ok
  end
end
