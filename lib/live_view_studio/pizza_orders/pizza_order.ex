defmodule LiveViewStudio.PizzaOrders.PizzaOrder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pizza_orders" do
    field :pizza, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(pizza_order, attrs) do
    pizza_order
    |> cast(attrs, [:username, :pizza])
    |> validate_required([:username, :pizza])
  end
end
