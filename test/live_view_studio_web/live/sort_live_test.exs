defmodule LiveViewStudioWeb.SortLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  alias Phoenix.LiveViewTest.DOM

  alias LiveViewStudio.Donations.Donation
  alias LiveViewStudio.Repo
  alias LiveViewStudioWeb.SortLive

  setup [:fixtures]

  describe "paginate" do
    test "shows first five items", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/sort")

      assert has_item?(view, "Grapes")
      refute has_item?(view, "Corn")
    end

    test "next navigates to next page", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/sort")

      view |> element(".pagination a.next", "Next") |> render_click()

      assert has_item?(view, "Strawberries")
      refute has_item?(view, "Grapes")
    end

    test "previous navigates to previous page", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/sort?page=4&per_page=5")

      view |> element(".pagination a.previous", "Previous") |> render_click()

      assert has_item?(view, "Avocados")
      refute has_item?(view, "Sweet Potatoes")
    end

    test "first page has no previous link", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/sort")

      refute view |> has_element?(".pagination a", "Previous")
    end

    test "links to surrounding pages", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/sort?page=4&per_page=2")

      assert page_numbers(view) == ~w[Previous 2 3 4 5 6 Next]

      view |> element(".pagination a", "2") |> render_click()

      assert page_numbers(view) == ~w[Previous 1 2 3 4 Next]
    end

    test "highlights active page", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/sort?page=4&per_page=2")

      assert view |> element(".pagination a", "4") |> render() =~ "active"
    end

    test "select number of items per page", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/sort?page=1&per_page=5")

      assert has_item?(view, "Banana")
      assert has_item?(view, "Grapes")
      refute has_item?(view, "Strawberries")
      refute has_item?(view, "Sweet Potatoes")

      select_per_page(view, "20")

      assert has_item?(view, "Banana")
      assert has_item?(view, "Strawberries")
      assert has_item?(view, "Sweet Potatoes")
    end

    test "changing per page adjusts page to keep items visible", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/sort?page=3&per_page=5")

      orig_items = ~w(Kiwis Eggplants Avocados Peppers Corn)

      assert items(view) == orig_items

      select_per_page(view, "10")

      assert items(view) == orig_items ++ ["Sweet Potatoes"] ++ ~w(Bagels Soup)

      assert_patched(view, "/sort?page=2&per_page=10")
    end

    test "change_per_page/2 adapts page to keep item anchored" do
      options = %{page: 10, per_page: 5}
      new_per_page = 20

      assert %{page: 3, per_page: ^new_per_page} = SortLive.change_per_page(options, new_per_page)
    end
  end

  describe "sort" do
    test "item ascending", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/sort?sort_by=item")

      assert_sorted(view, :item, :asc)
    end
  end

  defp assert_sorted(view, col, dir)

  defp assert_sorted(view, :item, :asc) do
    items = items(view)

    assert_sorted(items)
  end

  defp assert_sorted(list) do
    assert list == Enum.sort(list)
  end

  defp item(view, name) do
    element(view, "#donations .item", name)
  end

  defp has_item?(view, name) do
    item(view, name) |> has_element?()
  end

  defp items(view) do
    view
    |> element("#donations tbody")
    |> render()
    |> DOM.parse()
    |> DOM.all(".item")
    |> Enum.map(fn html ->
      text = DOM.child_nodes(html) |> Enum.at(1)

      Regex.scan(~r/[\w\s]+/, text)
      |> List.flatten()
      |> Enum.at(1)
      |> String.trim()
    end)
  end

  defp page_numbers(view) do
    view
    |> element(".pagination")
    |> render()
    |> DOM.parse()
    |> DOM.all("a")
    |> Enum.map(&DOM.child_nodes/1)
    |> Enum.map(&List.first/1)
  end

  defp select_per_page(view, per_page) do
    view |> element("#donations form") |> render_change(%{"per-page" => per_page})
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
        {"🍠", "Sweet Potatoes"},
        {"🥯", "Bagels"},
        {"🥫", "Soup"}
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
