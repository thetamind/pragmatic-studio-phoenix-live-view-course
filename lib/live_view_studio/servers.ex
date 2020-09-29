defmodule LiveViewStudio.Servers do
  @moduledoc """
  The Servers context.
  """

  import Ecto.Query, warn: false
  alias LiveViewStudio.Repo

  alias LiveViewStudio.Servers.Server

  @topic "servers"

  def subscribe() do
    Phoenix.PubSub.subscribe(LiveViewStudio.PubSub, @topic)
  end

  defp broadcast({:ok, server} = result, event) do
    Phoenix.PubSub.broadcast(LiveViewStudio.PubSub, @topic, {event, server})

    result
  end

  defp broadcast({:error, _server} = error, _event), do: error

  @doc """
  Returns the list of servers.

  ## Examples

      iex> list_servers()
      [%Server{}, ...]

  """
  def list_servers do
    Repo.all(from s in Server, order_by: [desc: s.id])
  end

  @doc """
  Gets a single server.

  Raises `Ecto.NoResultsError` if the Server does not exist.

  ## Examples

      iex> get_server!(123)
      %Server{}

      iex> get_server!(456)
      ** (Ecto.NoResultsError)

  """
  def get_server!(id), do: Repo.get!(Server, id)

  @doc """
  Gets a single server by name.

  Returns `nil` if the Server does not exist.

  ## Examples

      iex> get_server_by_name("boo")
      %Server{}

      iex> get_server_by_name("not-here")
      nil

  """
  def get_server_by_name(name), do: Repo.get_by(Server, name: name)

  @doc """
  Creates a server.

  ## Examples

      iex> create_server(%{field: value})
      {:ok, %Server{}}

      iex> create_server(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_server(attrs \\ %{}) do
    %Server{}
    |> Server.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:server_created)
  end

  @doc """
  Updates a server.

  ## Examples

      iex> update_server(server, %{field: new_value})
      {:ok, %Server{}}

      iex> update_server(server, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_server(%Server{} = server, attrs) do
    server
    |> Server.changeset(attrs)
    |> Repo.update()
    |> broadcast(:server_updated)
  end

  def toggle_status(%Server{} = server) do
    status =
      case server.status do
        "up" -> "down"
        "down" -> "up"
      end

    update_server(server, %{status: status})
  end

  @doc """
  Deletes a server.

  ## Examples

      iex> delete_server(server)
      {:ok, %Server{}}

      iex> delete_server(server)
      {:error, %Ecto.Changeset{}}

  """
  def delete_server(%Server{} = server) do
    Repo.delete(server)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking server changes.

  ## Examples

      iex> change_server(server)
      %Ecto.Changeset{data: %Server{}}

  """
  def change_server(%Server{} = server, attrs \\ %{}) do
    Server.changeset(server, attrs)
  end
end
