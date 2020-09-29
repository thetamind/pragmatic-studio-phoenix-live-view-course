defmodule LiveViewStudioWeb.VolunteersLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Volunteers
  alias LiveViewStudio.Volunteers.Volunteer

  def mount(_params, _session, socket) do
    if connected?(socket), do: Volunteers.subscribe()

    volunteers = Volunteers.list_volunteers()

    changeset = Volunteers.change_volunteer(%Volunteer{})

    socket =
      assign(socket,
        changeset: changeset,
        volunteers: volunteers
      )

    {:ok, socket, temporary_assigns: [volunteers: []]}
  end

  def handle_event("save", %{"volunteer" => params}, socket) do
    socket =
      case Volunteers.create_volunteer(params) do
        {:ok, _volunteer} ->
          blank_changeset = Volunteers.change_volunteer(%Volunteer{})

          assign(socket, changeset: blank_changeset)

        {:error, changeset} ->
          assign(socket, changeset: changeset)
      end

    {:noreply, socket}
  end

  def handle_event("validate", %{"volunteer" => params}, socket) do
    changeset =
      %Volunteer{}
      |> Volunteers.change_volunteer(params)
      |> Map.put(:action, :insert)

    socket = assign(socket, changeset: changeset)

    {:noreply, socket}
  end

  def handle_event("checkout", %{"id" => id}, socket) do
    volunteer = Volunteers.get_volunteer!(id)

    {:ok, _volunteer} = Volunteers.toggle_status_volunteer(volunteer)

    {:noreply, socket}
  end

  def handle_info({:volunteer_created, volunteer}, socket) do
    socket = update(socket, :volunteers, fn volunteers -> [volunteer | volunteers] end)

    {:noreply, socket}
  end

  def handle_info({:volunteer_updated, volunteer}, socket) do
    socket = update(socket, :volunteers, fn volunteers -> [volunteer | volunteers] end)

    {:noreply, socket}
  end
end
