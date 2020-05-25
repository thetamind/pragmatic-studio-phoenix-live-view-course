defmodule LiveViewStudio.Boats do
  @moduledoc """
  The Boats context.
  """

  import Ecto.Query, warn: false
  alias LiveViewStudio.Repo

  alias LiveViewStudio.Boats.Boat

  @doc """
  Returns the list of boats.

  ## Examples

      iex> list_boats()
      [%Boat{}, ...]

  """
  def list_boats do
    Repo.all(Boat)
  end

  def list_boats(criteria) when is_list(criteria) do
    query = from(b in Boat)

    Enum.reduce(criteria, query, fn
      {:type, ""}, query ->
        query

      {:type, type}, query ->
        from q in query, where: q.type == ^type

      {:prices, [""]}, query ->
        query

      {:prices, prices}, query ->
        from q in query, where: q.price in ^prices
    end)
    |> Repo.all()
  end

  @doc """
  Gets a single boat.

  Raises `Ecto.NoResultsError` if the Boat does not exist.

  ## Examples

      iex> get_boat!(123)
      %Boat{}

      iex> get_boat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_boat!(id), do: Repo.get!(Boat, id)

  @doc """
  Creates a boat.

  ## Examples

      iex> create_boat(%{field: value})
      {:ok, %Boat{}}

      iex> create_boat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_boat(attrs \\ %{}) do
    %Boat{}
    |> Boat.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a boat.

  ## Examples

      iex> update_boat(boat, %{field: new_value})
      {:ok, %Boat{}}

      iex> update_boat(boat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_boat(%Boat{} = boat, attrs) do
    boat
    |> Boat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a boat.

  ## Examples

      iex> delete_boat(boat)
      {:ok, %Boat{}}

      iex> delete_boat(boat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_boat(%Boat{} = boat) do
    Repo.delete(boat)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking boat changes.

  ## Examples

      iex> change_boat(boat)
      %Ecto.Changeset{data: %Boat{}}

  """
  def change_boat(%Boat{} = boat, attrs \\ %{}) do
    Boat.changeset(boat, attrs)
  end
end
