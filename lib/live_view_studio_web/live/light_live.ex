defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, :brightness, 10)

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Front Porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style="width: <%= @brightness %>%">
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
        <button phx-click="party" class="font-bold">
          Light Me Up!
        </button>
      </div>
    </div>
    """
  end

  def handle_event("on", _meta, socket) do
    socket = assign(socket, :brightness, 100)
    {:noreply, socket}
  end

  def handle_event("up", _meta, socket) do
    socket = update(socket, :brightness, &(&1 + 10))
    {:noreply, socket}
  end

  def handle_event("down", _meta, socket) do
    socket = update(socket, :brightness, &(&1 - 10))
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
end
