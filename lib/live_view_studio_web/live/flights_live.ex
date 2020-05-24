defmodule LiveViewStudioWeb.FlightsLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Airports
  alias LiveViewStudio.Flights

  def mount(_params, _session, socket) do
    socket = assign(socket, number: "", code: "", airport_codes: [], flights: [], loading: false)

    {:ok, socket}
  end

  def handle_event("number-search", %{"number" => number}, socket) do
    send(self(), {:run_number_search, number})
    socket = assign(socket, number: number, flights: [], loading: true)
    {:noreply, socket}
  end

  def handle_event("airport-code-search", %{"code" => code}, socket) do
    send(self(), {:run_code_search, code})
    socket = assign(socket, code: code, flights: [], loading: true)
    {:noreply, socket}
  end

  def handle_event("suggest-airport-code", %{"code" => prefix}, socket) do
    socket = assign(socket, airport_codes: Airports.suggest(prefix))
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

  def handle_info({:run_code_search, code}, socket) do
    flights = Flights.search_by_airport(code)

    socket = assign(socket, flights: flights, loading: false)

    socket =
      case flights do
        [] -> put_flash(socket, :info, "No flights matching \"#{code}\"")
        _ -> clear_flash(socket)
      end

    {:noreply, socket}
  end

  def format(datetime) do
    Timex.format!(datetime, "{Mshort} {D} at {h24}:{m}")
  end
end
