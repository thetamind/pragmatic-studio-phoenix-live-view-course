defmodule LiveViewStudioWeb.PaginateLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias LiveViewStudio.Donations.Donation
  alias LiveViewStudio.Repo

  setup [:fixtures]

  test "shows first five items", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/paginate")

    assert has_item?(view, "Grapes")
    refute has_item?(view, "Corn")
  end

  test "next navigates to next page", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/paginate")

    view |> element(".pagination a.next", "Next") |> render_click()

    assert has_item?(view, "Strawberries")
    refute has_item?(view, "Grapes")
  end

  test "previous navigates to previous page", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/paginate?page=4&per_page=5")

    view |> element(".pagination a.previous", "Previous") |> render_click()

    assert has_item?(view, "Avocados")
    refute has_item?(view, "Sweet Potatoes")
  end

  test "first page has no previous link", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/paginate")

    refute view |> has_element?(".pagination a", "Previous")
  end

  test "links to surrounding pages", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/paginate?page=4&per_page=2")

    assert page_numbers(view) == ~w[Previous 2 3 4 5 6 Next]

    view |> element(".pagination a", "2") |> render_click()

    assert page_numbers(view) == ~w[Previous 1 2 3 4 Next]
  end

  test "highlights active page", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/paginate?page=4&per_page=2")

    assert view |> element(".pagination a", "4") |> render() =~ "active"
  end

  test "select number of items per page", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/paginate?page=1&per_page=5")

    assert has_item?(view, "Banana")
    assert has_item?(view, "Grapes")
    refute has_item?(view, "Strawberries")

    view |> element("#donations form") |> render_change(%{"per-page" => "20"})

    assert has_item?(view, "Banana")
    assert has_item?(view, "Strawberries")
    assert has_item?(view, "Sweet Potatoes")
  end

  defp item(view, name) do
    element(view, "#donations .item", name)
  end

  defp has_item?(view, name) do
    item(view, name) |> has_element?()
  end

  defp page_numbers(view) do
    alias Phoenix.LiveViewTest.DOM

    view
    |> element(".pagination")
    |> render()
    |> DOM.parse()
    |> DOM.all("a")
    |> Enum.map(&DOM.child_nodes/1)
    |> Enum.map(&List.first/1)
  end

  defp fixtures(_context) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    donation_items =
      [
        # 1
        {"🍌", "Banana"},
        {"🥕", "Carrots"},
        {"🍋", "Lemons"},
        {"🍉", "Watermelons"},
        {"🍇", "Grapes"},
        # 6
        {"🍓", "Strawberries"},
        {"🍈", "Melons"},
        {"🍒", "Cherries"},
        {"🍑", "Peaches"},
        {"🍍", "Pineapples"},
        # 11
        {"🥝", "Kiwis"},
        {"🍆", "Eggplants"},
        {"🥑", "Avocados"},
        {"🌶", "Peppers"},
        {"🌽", "Corn"},
        # 16
        {"🍠", "Sweet Potatoes"}
      ]
      |> Enum.map(fn {emoji, item} ->
        %{
          emoji: emoji,
          item: item,
          quantity: Enum.random(1..20),
          days_until_expires: Enum.random(1..30),
          inserted_at: now,
          updated_at: now
        }
      end)

    Repo.insert_all(Donation, donation_items)

    :ok
  end
end
