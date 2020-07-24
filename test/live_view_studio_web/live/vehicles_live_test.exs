defmodule LiveViewStudioWeb.VehiclesLiveTest do
  use LiveViewStudioWeb.ConnCase

  import Phoenix.LiveViewTest

  alias LiveViewStudio.Repo
  alias LiveViewStudio.Vehicles.Vehicle

  setup [:fixtures]

  test "shows vehicles", %{conn: conn, vehicles: vehicles} do
    {:ok, view, _html} = live(conn, "/vehicles")

    vehicle = vehicles |> List.first()

    pattern = ~r/.*#{vehicle.make}.*#{vehicle.model}.*#{vehicle.color}.*/s

    assert view |> element("#vehicles tbody tr", pattern) |> render() =~ pattern
  end

  test "shows first page of 10 vehicles", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/vehicles")

    html = view |> element("#vehicles table") |> render()

    assert Floki.parse_fragment!(html)
           |> Floki.find("tbody")
           |> List.first()
           |> Floki.children()
           |> Enum.count() == 10
  end

  defp fixtures(_context) do
    alias LiveViewStudio.Repo

    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    vehicles =
      for _i <- 1..100 do
        %{
          make: Faker.Vehicle.make(),
          model: Faker.Vehicle.model(),
          color: Faker.Color.name(),
          inserted_at: now,
          updated_at: now
        }
      end

    {100, _} = Repo.insert_all(Vehicle, vehicles)

    vehicles = Repo.all(Vehicle)
    assert Enum.count(vehicles) == 100

    [vehicles: vehicles]
  end
end
