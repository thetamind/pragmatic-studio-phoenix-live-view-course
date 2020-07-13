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

    assert view |> element(".pagination a", "Next") |> render_click() =~ "Strawberries"
    refute has_element?(view, "#donations .item", "Grapes")
    assert has_element?(view, "#donations .item", "Strawberries")
  end

  defp fixtures(_context) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    donation_items =
      [
        {"🍌", "Banana"},
        {"🥕", "Carrots"},
        {"🍋", "Lemons"},
        {"🍉", "Watermelons"},
        {"🍇", "Grapes"},
        {"🍓", "Strawberries"},
        {"🍈", "Melons"},
        {"🍒", "Cherries"},
        {"🍑", "Peaches"},
        {"🍍", "Pineapples"},
        {"🥝", "Kiwis"},
        {"🍆", "Eggplants"},
        {"🥑", "Avocados"},
        {"🌶", "Peppers"},
        {"🌽", "Corn"},
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
