defmodule LiveViewStudioWeb.FlightsLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Flights

  def mount(_params, _session, socket) do
    socket = assign(socket, number: "", flights: [], loading: false)
    {:ok, socket}
  end

  def handle_event("number-search", %{"number" => number}, socket) do
    send(self(), {:run_number_search, number})
    socket = assign(socket, number: number, flights: [], loading: true)
    {:noreply, socket}
  end

  def handle_info({:run_number_search, number}, socket) do
    flights = Flights.search_by_number(number)

    socket = assign(socket, flights: flights, loading: false)

    socket =
      case flights do
        [] -> put_flash(socket, :info, "No flights matching \"#{number}\"")
        _ -> clear_flash(socket)
      end

    {:noreply, socket}
  end
end
