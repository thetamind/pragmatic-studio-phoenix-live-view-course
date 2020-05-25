defmodule LiveViewStudioWeb.FilterLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Boats

  def mount(_params, _session, socket) do
    socket = assign_defaults(socket)

    {:ok, socket, temporary_assigns: [boats: []]}
  end

  def handle_event("filter", %{"type" => type, "prices" => prices}, socket) do
    params = [type: type, prices: prices]
    boats = Boats.list_boats(params)
    socket = assign(socket, params ++ [boats: boats])

    {:noreply, socket}
  end

  def handle_event("clear-filters", _, socket) do
    socket = assign_defaults(socket)

    {:noreply, socket}
  end

  defp assign_defaults(socket) do
    assign(socket, boats: Boats.list_boats(), type: "", prices: [])
  end

  defp dom_id(boat) do
    "boat-#{boat.id}"
  end

  defp price_checkbox(assigns) do
    assigns = Enum.into(assigns, %{})

    ~L"""
    <input type="checkbox" id="<%= @price %>"
            name="prices[]" value="<%= @price %>"
            <%= if @checked, do: "checked" %> />
    <label for="<%= @price %>"><%= @price %></label>
    """
  end

  defp type_options do
    [
      "All Types": "",
      Fishing: "fishing",
      Sporting: "sporting",
      Sailing: "sailing"
    ]
  end
end
