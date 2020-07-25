defmodule LiveViewStudioWeb.VehiclesLiveTest do
  use LiveViewStudioWeb.ConnCase

  import Phoenix.LiveViewTest
  alias Phoenix.LiveViewTest.DOM

  alias LiveViewStudio.Repo
  alias LiveViewStudio.Vehicles.Vehicle

  setup [:fixtures]

  test "shows vehicles", %{conn: conn, vehicles: vehicles} do
    {:ok, view, _html} = live(conn, "/vehicles")

    vehicle = vehicles |> List.first()

    pattern = ~r/.*#{vehicle.make}.*#{vehicle.model}.*#{vehicle.color}.*/s

    assert view |> element("#vehicles tbody tr", pattern) |> render() =~ pattern
  end

  test "shows first page of 10 vehicles", %{conn: conn, vehicles: vehicles} do
    {:ok, view, _html} = live(conn, "/vehicles")

    assert vehicle_count(view) == 10

    expected_ids = vehicles |> Enum.take(10) |> Enum.map(& &1.id)
    assert vehicle_ids(view) == expected_ids
  end

  defp vehicle_ids(view) do
    view
    |> table_data()
    |> Enum.map(fn row ->
      List.first(row) |> String.to_integer()
    end)
  end

  defp vehicle_count(view) do
    view
    |> table_data()
    |> Enum.count()
  end

  defp table_data(view) do
    view
    |> element("#vehicles table")
    |> render()
    |> DOM.parse()
    |> DOM.all("tbody tr")
    |> Enum.map(&extract_table_row/1)
  end

  defp extract_table_row({"tr", _attrs, children}) do
    children
    |> Enum.map(fn row ->
      row
      |> Floki.children()
      |> List.first()
      |> String.split([" ", "\n"], trim: true)
      |> List.first()
    end)
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
