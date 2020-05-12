defmodule LiveViewStudioWeb.SearchLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Stores

  def mount(_params, _session, socket) do
    socket = assign(socket, zip: "", stores: [])
    {:ok, socket}
  end

  def handle_event("zip-search", %{"zip" => zip}, socket) do
    socket = assign(socket, zip: zip, stores: Stores.search_by_zip(zip))
    {:noreply, socket}
  end
end
