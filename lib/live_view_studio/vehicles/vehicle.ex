defmodule LiveViewStudio.Vehicles.Vehicle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "vehicles" do
    field :color, :string
    field :make, :string
    field :model, :string

    timestamps()
  end

  @doc false
  def changeset(vehicle, attrs) do
    vehicle
    |> cast(attrs, [:make, :model, :color])
    |> validate_required([:make, :model, :color])
  end
end
