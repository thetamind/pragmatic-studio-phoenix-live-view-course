defmodule LiveViewStudio.Boats.Boat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "boats" do
    field :image, :string
    field :model, :string
    field :price, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(boat, attrs) do
    boat
    |> cast(attrs, [:model, :type, :price, :image])
    |> validate_required([:model, :type, :price, :image])
  end
end
