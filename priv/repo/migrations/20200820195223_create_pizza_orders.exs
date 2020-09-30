defmodule LiveViewStudio.Repo.Migrations.CreatePizzaOrders do
  use Ecto.Migration

  def change do
    create table(:pizza_orders) do
      add :username, :string, null: false
      add :pizza, :string, null: false

      timestamps()
    end

  end
end
