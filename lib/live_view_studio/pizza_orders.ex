defmodule LiveViewStudio.PizzaOrders do
  @moduledoc """
  The PizzaOrders context.
  """

  import Ecto.Query, warn: false
  alias LiveViewStudio.Repo

  alias LiveViewStudio.PizzaOrders.PizzaOrder

  @doc """
  Returns the list of pizza_orders.

  ## Examples

      iex> list_pizza_orders()
      [%PizzaOrder{}, ...]

  """
  def list_pizza_orders do
    Repo.all(PizzaOrder)
  end

  @doc """
  Returns batches of pizza orders.

  ## Examples

      iex> list_pizza_orders(page: 1, per_page: 5)
      [%PizzaOrder{}, ...]
  """
  def list_pizza_orders(page: page, per_page: per_page) do
    query =
      from p in PizzaOrder,
        offset: ^((page - 1) * per_page),
        limit: ^per_page,
        order_by: [{:desc, :id}]

    Repo.all(query)
  end

  @doc """
  Gets a single pizza_order.

  Raises `Ecto.NoResultsError` if the Pizza order does not exist.

  ## Examples

      iex> get_pizza_order!(123)
      %PizzaOrder{}

      iex> get_pizza_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pizza_order!(id), do: Repo.get!(PizzaOrder, id)

  @doc """
  Creates a pizza_order.

  ## Examples

      iex> create_pizza_order(%{field: value})
      {:ok, %PizzaOrder{}}

      iex> create_pizza_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pizza_order(attrs \\ %{}) do
    %PizzaOrder{}
    |> PizzaOrder.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pizza_order.

  ## Examples

      iex> update_pizza_order(pizza_order, %{field: new_value})
      {:ok, %PizzaOrder{}}

      iex> update_pizza_order(pizza_order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pizza_order(%PizzaOrder{} = pizza_order, attrs) do
    pizza_order
    |> PizzaOrder.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pizza_order.

  ## Examples

      iex> delete_pizza_order(pizza_order)
      {:ok, %PizzaOrder{}}

      iex> delete_pizza_order(pizza_order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pizza_order(%PizzaOrder{} = pizza_order) do
    Repo.delete(pizza_order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pizza_order changes.

  ## Examples

      iex> change_pizza_order(pizza_order)
      %Ecto.Changeset{data: %PizzaOrder{}}

  """
  def change_pizza_order(%PizzaOrder{} = pizza_order, attrs \\ %{}) do
    PizzaOrder.changeset(pizza_order, attrs)
  end
end
