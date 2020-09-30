defmodule LiveViewStudio.Repo.Migrations.CreatePizzaOrders do
  use Ecto.Migration

  def change do
    create table(:pizza_orders) do
      add :username, :string
      add :pizza, :string

      timestamps()
    end

  end
end
