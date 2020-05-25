defmodule LiveViewStudioWeb.FilterLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Boats

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        boats: Boats.list_boats(),
        type: "",
        prices: []
      )

    {:ok, socket}
  end

  def handle_event("filter", %{"type" => type, "prices" => prices}, socket) do
    boats = Boats.list_boats(type: type, prices: prices)
    socket = assign(socket, boats: boats, type: type, prices: prices)
    {:noreply, socket}
  end

  defp dom_id(boat) do
    "boat-#{boat.id}"
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
