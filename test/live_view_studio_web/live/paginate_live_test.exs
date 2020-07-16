defmodule LiveViewStudioWeb.PaginateLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias LiveViewStudio.Donations.Donation
  alias LiveViewStudio.Repo

  setup [:fixtures]

  test "shows first five items", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/paginate")

    assert has_element?(view, "#donations .item", "Grapes")
    refute has_element?(view, "#donations .item", "Corn")
  end

  test "next navigates to next page", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/paginate")

    view |> element(".pagination a", "Next") |> render_click()

    assert has_element?(view, "#donations .item", "Strawberries")
    refute has_element?(view, "#donations .item", "Grapes")
  end

  test "previous navigates to previous page", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/paginate?page=4&per_page=5")

    view |> element(".pagination a", "Previous") |> render_click()

    assert has_element?(view, "#donations .item", "Avocados")
    refute has_element?(view, "#donations .item", "Sweet Potatoes")
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
