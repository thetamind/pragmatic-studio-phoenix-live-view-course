defmodule LiveViewStudio.Donations.Donation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "donations" do
    field :days_until_expires, :integer
    field :emoji, :string
    field :item, :string
    field :quantity, :integer

    timestamps()
  end

  @doc false
  def changeset(donation, attrs) do
    donation
    |> cast(attrs, [:item, :emoji, :quantity, :days_until_expires])
    |> validate_required([:item, :emoji, :quantity, :days_until_expires])
  end
end
