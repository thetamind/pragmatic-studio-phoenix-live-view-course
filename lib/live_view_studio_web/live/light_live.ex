defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, brightness: 10, temp: 3000)

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Front Porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style="background-color: <%= temp_colour(@temp) %>; width: <%= @brightness %>%">
          <%= @brightness %>%
        </span>
      </div>

      <div class="mb-4">
        <button phx-click="off">
          <img src="images/light-off.svg">
        </button>
        <button phx-click="down">
          <img src="images/down.svg">
        </button>
        <button phx-click="up">
          <img src="images/up.svg">
        </button>
        <button phx-click="on">
          <img src="images/light-on.svg">
        </button>
      </div>
      <div class="mb-4">
        <form id="temp-form" phx-change="change-temp">
          <input type="radio" name="temp" value="3000" <%= if @temp == 3000, do: "checked" %> />
          <label for="3000">3000</label>
          <input type="radio" name="temp" value="4000" <%= if @temp == 4000, do: "checked" %> />
          <label for="4000">4000</label>
          <input type="radio" name="temp" value="5000" <%= if @temp == 5000, do: "checked" %> />
          <label for="5000">5000</label>
        </form>

        <button phx-click="party" class="font-bold">
          Light Me Up!
        </button>
      </div>

      <form id="dimmer-form" phx-change="dimmer" class="mb-4">
        <input type="range" name="brightness" phx-debounce
          min=0 max=100 value="<%= @brightness %>" />
      </form>
    </div>
    """
  end

  def handle_event("on", _meta, socket) do
    socket = assign(socket, :brightness, 100)
    {:noreply, socket}
  end

  def handle_event("up", _meta, socket) do
    socket = update(socket, :brightness, &min(&1 + 10, 100))
    {:noreply, socket}
  end

  def handle_event("down", _meta, socket) do
    socket = update(socket, :brightness, &max(&1 - 10, 0))
    {:noreply, socket}
  end

  def handle_event("off", _meta, socket) do
    socket = assign(socket, :brightness, 0)
    {:noreply, socket}
  end

  def handle_event("party", _meta, socket) do
    socket = assign(socket, :brightness, :rand.uniform(100))
    {:noreply, socket}
  end

  def handle_event("dimmer", %{"brightness" => brightness}, socket) do
    brightness = String.to_integer(brightness)
    socket = assign(socket, :brightness, brightness)
    {:noreply, socket}
  end

  def handle_event("change-temp", %{"temp" => temp}, socket) do
    temp = String.to_integer(temp)
    socket = assign(socket, :temp, temp)
    {:noreply, socket}
  end

  defp temp_colour(3000), do: "#F1C40D"
  defp temp_colour(4000), do: "#FEFF66"
  defp temp_colour(5000), do: "#99CCFF"
end
