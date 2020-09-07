defmodule LiveViewStudioWeb.VolunteersLiveTest do
  use LiveViewStudioWeb.ConnCase

  import Phoenix.LiveViewTest
  alias Phoenix.LiveViewTest.DOM

  alias LiveViewStudio.Repo
  alias LiveViewStudio.Volunteers
  alias LiveViewStudio.Volunteers.Volunteer
  alias LiveViewStudioWeb.VolunteersLive

  @valid_attrs %{name: "My Name", phone: "111-555-1234"}
  @invalid_attrs %{name: "a", phone: "12-12-12"}

  describe "create with valid inputs" do
    test "shows in list"
    test "prepends to list"
  end

  describe "create with invalid inputs" do
    test "shows errors", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/volunteers")

      view |> form("#checkin form", volunteer: @invalid_attrs) |> render_submit()

      assert view
             |> element(".field span[phx-feedback-for=volunteer_name]")
             |> render() =~
               "should be at least"

      assert view |> element(".field .invalid-feedback", "phone") |> render() =~
               "must be a valid phone number"
    end

    test "does not show in list"
  end
end
