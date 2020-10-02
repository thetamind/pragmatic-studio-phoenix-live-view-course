defmodule LiveViewStudioWeb.DeliveryChargeComponent do
  use LiveViewStudioWeb, :live_component

  alias LiveViewStudio.SandboxCalculator

  import Number.Currency

  def mount(socket) do
    socket = assign(socket, zip: "", charge: nil)

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <form phx-change="calculate-delivery" phx-target="<%= @myself %>">
      <div class="field">
        <label for="zip">Zip Code:</label>
        <input type="text" name="zip" value="<%= @zip %>" />
        <span class="unit"><%= number_to_currency(@charge) %></span>
      </div>
    </form>
    """
  end

  def handle_event("calculate-delivery", %{"zip" => zip}, socket) do
    charge = SandboxCalculator.calculate_delivery_charge(zip)

    socket = assign(socket, charge: charge)

    send(self(), {:delivery_charge, charge})

    {:noreply, socket}
  end
end
