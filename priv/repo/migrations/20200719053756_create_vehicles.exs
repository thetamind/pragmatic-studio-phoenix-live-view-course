defmodule LiveViewStudio.Repo.Migrations.CreateVehicles do
  use Ecto.Migration

  def change do
    create table(:vehicles) do
      add :make, :string, null: false
      add :model, :string, null: false
      add :color, :string, null: false

      timestamps()
    end
  end
end
