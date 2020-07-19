defmodule LiveViewStudioWeb.VehiclesLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Vehicles

  def mount(_params, _session, socket) do
    vehicles = Vehicles.list_vehicles()

    socket =
      assign(socket,
        vehicles: vehicles
      )

    {:noreply, socket}

    {:ok, socket, temporary_assigns: [vehicles: []]}
  end

  def render(assigns) do
    ~L"""
    <h1>🚙 Vehicles 🚘</h1>
    <div id="vehicles">
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
          </div>
        </div>
      </div>
    </div>
    """
  end
end
