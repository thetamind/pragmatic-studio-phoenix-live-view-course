defmodule LiveViewStudioWeb.DatePickerLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, date: nil)}
  end

  def render(assigns) do
    ~L"""
    <h1>Date Picker</h1>
    <div>
      <form>
        <input id="date-picker-input" type="text"
               class="form-input" value="<%= @date %>"
               placeholder="Pick a date">
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
