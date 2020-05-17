defmodule LiveViewStudioWeb.SearchLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Stores

  def mount(_params, _session, socket) do
    socket = assign(socket, zip: "", stores: [], loading: false)
    {:ok, socket}
  end

  def handle_event("zip-search", %{"zip" => zip}, socket) do
    send(self(), {:run_zip_search, zip})
    socket = assign(socket, zip: zip, stores: [], loading: true)
    {:noreply, socket}
  end

  def handle_info({:run_zip_search, zip}, socket) do
    socket = assign(socket, stores: Stores.search_by_zip(zip), loading: false)
    {:noreply, socket}
  end
end
