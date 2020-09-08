defmodule LiveViewStudioWeb.VolunteersLiveTest do
  use LiveViewStudioWeb.ConnCase

  import Phoenix.LiveViewTest
  alias Phoenix.LiveViewTest.DOM

  alias LiveViewStudio.Volunteers

  @valid_attrs %{name: "My Name", phone: "111-555-1234"}
  @invalid_attrs %{name: "a", phone: "12-12-12"}

  describe "create with valid inputs" do
    test "shows in list", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/volunteers")

      view |> form("form", volunteer: @valid_attrs) |> render_submit()

      assert view |> render() =~ "My Name"
      assert view |> render() =~ "111-555-1234"
    end

    test "prepends to list", %{conn: conn} do
      volunteer1 = make_volunteer(%{name: "Alpha", phone: "111-111-1111"})
      volunteer2 = make_volunteer(%{name: "Beta", phone: "222-222-2222"})

      {:ok, view, _html} = live(conn, "/volunteers")

      assert volunteer_data(view) == [volunteer2, volunteer1]

      volunteer3 = %{name: "Gamma", phone: "333-333-3333"}
      view |> form("form", volunteer: volunteer3) |> render_submit()

      assert volunteer_data(view) == [volunteer3, volunteer2, volunteer1]
    end
  end

  describe "create with invalid inputs" do
    test "shows errors", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/volunteers")

      view |> form("form", volunteer: @invalid_attrs) |> render_submit()

      assert view
             |> element(".field span[phx-feedback-for=volunteer_name]")
             |> render() =~
               "should be at least"

      assert view |> element(".field .invalid-feedback", "phone") |> render() =~
               "must be a valid phone number"
    end

    test "does not show in list"
  end

  defp make_volunteer(attrs) do
    {:ok, volunteer} = Volunteers.create_volunteer(attrs)

    Map.take(volunteer, [:name, :phone])
  end

  defp volunteer_data(view) do
    view
    |> element("#volunteer-list")
    |> render()
    |> Floki.parse_fragment!()
    |> DOM.all(".volunteer")
    |> Enum.map(&extract_row/1)
  end

  defp extract_row(row) do
    row
    |> Floki.children(include_text: false)
    |> Enum.map(fn
      {"div", [{"class", name}], children} ->
        {name |> String.to_existing_atom(), DOM.to_text(children) |> String.trim()}
    end)
    |> Map.new()
    |> Map.take([:name, :phone])
  end
end
