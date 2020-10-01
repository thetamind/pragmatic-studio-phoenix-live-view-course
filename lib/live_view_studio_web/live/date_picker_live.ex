defmodule LiveViewStudioWeb.DatePickerLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, date: nil)}
  end

  def handle_event("date-picked", %{"date" => date}, socket) do
    socket = assign(socket, date: date)
    {:noreply, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Date Picker</h1>
    <div>
      <form>
        <input id="date-picker-input" type="text"
               class="form-input" value="<%= @date %>"
               placeholder="Pick a date"
               phx-hook="DatePicker">
      </form>

      <%= if @date do %>
        <p class="mt-6 text-xl">
          See you on <%= @date %>!
        </p>
      <% end %>
    </div>
    """
  end
end
