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

    :ok
  end
end
