defmodule LiveViewStudioWeb.AutocompleteLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Cities
  alias LiveViewStudio.Stores

  def mount(_params, _session, socket) do
    socket = assign(socket, zip: "", city: "", stores: [], matches: [], loading: false)
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    zip = params["zip"] || ""
    city = params["city"] || ""

    case zip do
      "" -> nil
      zip -> send(self(), {:run_zip_search, zip})
    end

    if String.length(city) > 0 do
      send(self(), {:run_city_search, city})
    end

    socket = assign(socket, zip: zip, city: city)

    {:noreply, socket}
  end

  def handle_event("zip-search", %{"zip" => zip}, socket) do
    send(self(), {:run_zip_search, zip})
    path = Routes.live_path(socket, __MODULE__, zip: zip)
    socket = assign(socket, zip: zip, stores: [], loading: true)
    socket = push_patch(socket, to: path)
    {:noreply, socket}
  end

  def handle_event("city-search", %{"city" => city}, socket) do
    send(self(), {:run_city_search, city})
    path = Routes.live_path(socket, __MODULE__, city: city)
    socket = assign(socket, city: city, stores: [], loading: true)
    socket = push_patch(socket, to: path)
    {:noreply, socket}
  end

  def handle_event("suggest-city", %{"city" => prefix}, socket) do
    matches = Cities.suggest(prefix) |> Enum.take(15)
    socket = assign(socket, matches: matches)

    {:noreply, socket}
  end

  def handle_info({:run_zip_search, zip}, socket) do
    case Stores.search_by_zip(zip) do
      [] ->
        socket =
          socket
          |> put_flash(:info, "No stores matching \"#{zip}\"")
          |> assign(stores: [], loading: false)

        {:noreply, socket}

      stores ->
        socket =
          socket
          |> clear_flash()
          |> assign(stores: stores, loading: false)

        {:noreply, socket}
    end
  end

  def handle_info({:run_city_search, city}, socket) do
    stores = Stores.search_by_city(city)

    socket =
      case stores do
        [] -> put_flash(socket, :info, "No stores matching \"#{city}\"")
        _ -> clear_flash(socket)
      end

    socket = assign(socket, stores: stores, loading: false)
    {:noreply, socket}
  end
end
