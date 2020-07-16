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

    view |> element(".pagination a.next", "Next") |> render_click()

    assert has_element?(view, "#donations .item", "Strawberries")
    refute has_element?(view, "#donations .item", "Grapes")
  end

  test "previous navigates to previous page", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/paginate?page=4&per_page=5")

    view |> element(".pagination a.previous", "Previous") |> render_click()

    assert has_element?(view, "#donations .item", "Avocados")
    refute has_element?(view, "#donations .item", "Sweet Potatoes")
  end

  test "first page has no previous link", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/paginate")

    refute view |> has_element?(".pagination a", "Previous")
  end

  test "links to surrounding pages", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/paginate?page=4&per_page=2")

    assert view |> element(".pagination") |> render() =~ ~r/.*2<\/a>.*3.*4<\/a>.*5.*6.*/
    refute view |> element(".pagination") |> render() =~ ~r/0<\/a>/
    refute view |> element(".pagination") |> render() =~ ~r/7<\/a>/

    view |> element(".pagination a", "2") |> render_click()

    assert view |> element(".pagination") |> render() =~ ~r/.*1<\/a>.*2<\/a>.*3.*4.*/
    refute view |> element(".pagination") |> render() =~ ~r/0<\/a>/
    refute view |> element(".pagination") |> render() =~ ~r/5<\/a>/
  end

  test "highlights active page", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/paginate?page=4&per_page=2")

    assert view |> element(".pagination a", "4") |> render() =~ "active"
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
