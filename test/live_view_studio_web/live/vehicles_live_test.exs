defmodule LiveViewStudioWeb.VehiclesLiveTest do
  use LiveViewStudioWeb.ConnCase

  import Phoenix.LiveViewTest
  alias Phoenix.LiveViewTest.DOM

  alias LiveViewStudio.Repo
  alias LiveViewStudio.Vehicles.Vehicle
  alias LiveViewStudioWeb.VehiclesLive

  describe "pagination" do
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

    test "selects number of items per page", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/vehicles?page=1&per_page=10")

      assert vehicle_count(view) == 10

      select_per_page(view, "20")

      assert vehicle_count(view) == 20
    end

    test "changing per page adjusts page to keep items visible", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/vehicles?page=4&per_page=20")

      original_ids = vehicle_ids(view)
      expected_ids = original_ids |> Enum.take(10)

      select_per_page(view, "10")

      assert vehicle_ids(view) == expected_ids
    end
  end

  describe "change_per_page/2 adapts page to keep item anchored" do
    test "when per_page decreases" do
      options = %{page: 10, per_page: 20}
      new_per_page = 10

      assert %{page: 19, per_page: ^new_per_page, anchor: 181} =
               VehiclesLive.change_per_page(options, new_per_page)
    end

    test "when per_page decreases on page 1" do
      options = %{page: 1, per_page: 20}
      new_per_page = 15

      assert %{page: 1, per_page: ^new_per_page, anchor: 1} =
               VehiclesLive.change_per_page(options, new_per_page)
    end

    test "when per_page increases on page 1" do
      options = %{page: 1, per_page: 10}
      new_per_page = 20

      assert %{page: 1, per_page: ^new_per_page, anchor: 1} =
               VehiclesLive.change_per_page(options, new_per_page)
    end

    test "when per_page increases" do
      options = %{page: 5, per_page: 10}
      new_per_page = 15

      assert %{page: 3, per_page: ^new_per_page, anchor: 41} =
               VehiclesLive.change_per_page(options, new_per_page)
    end

    test "when per_page increases by double" do
      options = %{page: 7, per_page: 10}
      new_per_page = 20

      assert %{page: 4, per_page: ^new_per_page, anchor: 61} =
               VehiclesLive.change_per_page(options, new_per_page)
    end
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

  defp select_per_page(view, per_page) do
    view |> element("#vehicles form") |> render_change(%{"per-page" => per_page})
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
