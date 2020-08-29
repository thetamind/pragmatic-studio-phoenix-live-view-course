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
    test "id ascending is default", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/sort")

      assert_sorted(view, :id, :asc)
    end

    test "item ascending", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/sort?sort_by=item")

      assert_sorted(view, :item, :asc)
    end

    test "item descending", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/sort?sort_by=item&sort_order=desc")

      assert_sorted(view, :item, :desc)
    end

    test "by clicked table heading", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/sort")

      assert_sorted(view, :id, :asc)

      view |> element("th a", "Item") |> render_click()

      assert_sorted(view, :item, :asc)

      view |> element("th a", "Quantity") |> render_click()

      assert_sorted(view, :quantity, :asc)

      view |> element("th a", "Days Until Expires") |> render_click()

      assert_sorted(view, :days_until_expires, :asc)
    end
  end

  test "extract row values", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/sort")
    item = rows(view) |> List.first()

    assert %{id: id, item: "Banana", quantity: qty, days_until_expires: days} = item
    assert is_integer(id)
    assert is_integer(qty)
    assert is_integer(days)
  end

  defp assert_sorted(view, key, dir) do
    items = rows(view)

    assert items == sort_items(items, key, dir)
  end

  defp item(view, name) do
    element(view, "#donations .item", name)
  end

  defp has_item?(view, name) do
    item(view, name) |> has_element?()
  end

  defp sort_items(items, sort_by, dir) do
    Enum.sort_by(items, &Map.fetch!(&1, sort_by), dir)
  end

  defp items(view) do
    view
    |> rows()
    |> Enum.map(& &1.item)
  end

  defp rows(view) do
    view
    |> element("#donations tbody")
    |> render()
    |> DOM.parse()
    |> DOM.all("tbody tr")
    |> Enum.map(fn html ->
      nodes = DOM.child_nodes(html)
      item_nodes = DOM.all(html, ".item") |> List.first() |> DOM.child_nodes()

      item =
        Regex.scan(~r/[\w\s]+/, Enum.at(item_nodes, 1))
        |> List.flatten()
        |> Enum.at(1)
        |> String.trim()

      id = item_nodes |> text_cell(0) |> String.to_integer()
      quantity = nodes |> text_cell(1) |> grab_number()
      days = nodes |> text_cell(2) |> String.to_integer()

      %{id: id, item: item, quantity: quantity, days_until_expires: days}
    end)
  end

  defp text_cell(nodes, index) do
    nodes |> Enum.at(index) |> DOM.to_text() |> String.trim()
  end

  defp grab_number(string) do
    string
    |> String.trim()
    |> String.split()
    |> List.first()
    |> String.to_integer()
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
