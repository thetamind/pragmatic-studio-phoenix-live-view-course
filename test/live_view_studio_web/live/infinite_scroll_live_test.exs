defmodule LiveViewStudioWeb.InfiniteScrollLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  alias Phoenix.LiveViewTest.DOM

  setup [:fixtures]

  test "load more with button", %{conn: conn} do
    {:ok, view, _html} = live(conn, "\infinite-scroll")

    assert status_count(view) == 10

    view |> element("#footer button", "Load More") |> render_click()

    assert status_count(view) == 20
  end

  defp status_count(view) do
    html = view |> element("#orders") |> render()

    html |> Floki.parse_fragment!() |> DOM.all(".order") |> Enum.count()
  end

  def fixtures(_context) do
    alias LiveViewStudio.Repo
    alias LiveViewStudio.PizzaOrders.PizzaOrder

    pizza_toppings = [
      "🍗 Chicken",
      "🌿 Basil",
      "🧄 Garlic",
      "🥓 Bacon",
      "🧀 Cheese",
      "🐠 Salmon",
      "🍤 Shrimp",
      "🥦 Broccoli",
      "🧅 Onions",
      "🍅 Tomatoes",
      "🍄 Mushrooms",
      "🍍 Pineapples",
      "🍆 Eggplants",
      "🥑 Avocados",
      "🌶 Peppers",
      "🍕 Pepperonis"
    ]

    toppings =
      comb(2, pizza_toppings)
      |> Stream.cycle()
      |> Stream.take(50)

    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    for [topping1, topping2] <- toppings do
      pizza = "#{Faker.Pizza.size()} #{Faker.Pizza.style()} with
     #{topping1} and #{topping2}"

      %{
        username: Faker.Internet.user_name(),
        pizza: pizza,
        inserted_at: now,
        updated_at: now
      }
    end
    |> Enum.to_list()
    |> (&Repo.insert_all(PizzaOrder, &1)).()

    :ok
  end

  @spec comb(non_neg_integer(), Enum.t()) :: [Enum.t()]
  defp comb(0, _), do: [[]]
  defp comb(_, []), do: []

  defp comb(m, [h | t]) do
    for(l <- comb(m - 1, t), do: [h | l]) ++ comb(m, t)
  end
end
