defmodule LiveViewStudioWeb.VehiclesLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Vehicles

  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [vehicles: []]}
  end

  def handle_params(params, _url, socket) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "10")

    pagination_options = %{page: page, per_page: per_page}
    vehicles = Vehicles.list_vehicles(paginate: pagination_options)

    socket =
      assign(socket,
        options: pagination_options,
        vehicles: vehicles
      )

    {:noreply, socket}
  end

  def handle_event("select-per-page", %{"per-page" => per_page}, socket) do
    per_page = String.to_integer(per_page)

    %{page: page} = change_per_page(socket.assigns.options, per_page)
    path = Routes.live_path(socket, __MODULE__, page: page, per_page: per_page)

    socket = push_patch(socket, to: path)

    {:noreply, socket}
  end

  def change_per_page(%{page: page, per_page: per_page}, new_per_page) do
    anchor = (page - 1) * per_page + 1

    new_page = div(anchor, new_per_page) + 1

    %{page: new_page, per_page: new_per_page, anchor: anchor}
  end

  def render(assigns) do
    ~L"""
    <h1>🚙 Vehicles 🚘</h1>
    <div id="vehicles">
      <form phx-change="select-per-page">Show
        <select name="per-page">
          <%= options_for_select([5, 10, 15, 20], @options.per_page) %>
        </select>
        <label for="per-page">per page</label>
      </form>

      <div class="wrapper">
        <table>
          <thead>
            <tr>
              <th>
                ID
              </th>
              <th>
                Make
              </th>
              <th>
                Model
              </th>
              <th>
                Color
              </th>
            </tr>
          </thead>
          <tbody>
            <%= for vehicle <- @vehicles do %>
              <tr>
                <td>
                  <%= vehicle.id %>
                </td>
                <td>
                  <%= vehicle.make %>
                </td>
                <td>
                  <%= vehicle.model %>
                </td>
                <td>
                  <%= vehicle.color %>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
        <div class="footer">
          <div class="pagination">
            <%= if @options.page > 1 do %>
              <%= pagination_link(@socket, "Previous", @options.page - 1, @options.per_page, "previous") %>
            <% end %>
            <%= for i <- (@options.page - 2)..(@options.page + 2), i > 0 do %>
              <%= pagination_link(@socket, i, i, @options.per_page, if(i == @options.page, do: "active")) %>
            <% end %>
            <%= pagination_link(@socket, "Next", @options.page + 1, @options.per_page, "next") %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp pagination_link(socket, text, page, per_page, class) do
    live_patch(text,
      to:
        Routes.live_path(socket, __MODULE__,
          page: page,
          per_page: per_page
        ),
      class: class
    )
  end
end
