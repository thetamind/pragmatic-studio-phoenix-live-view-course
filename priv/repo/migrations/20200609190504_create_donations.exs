defmodule LiveViewStudio.Repo.Migrations.CreateDonations do
  use Ecto.Migration

  def change do
    create table(:donations) do
      add :item, :string
      add :emoji, :string
      add :quantity, :integer
      add :days_until_expires, :integer

      timestamps()
    end

  end
end
