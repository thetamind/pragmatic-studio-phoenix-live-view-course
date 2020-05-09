defmodule LiveViewStudioWeb.LicenseLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Licenses
  import Number.Currency

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    seats = 2
    expiration_time = Timex.shift(Timex.now(), hours: 1)

    socket =
      assign(socket,
        seats: seats,
        amount: Licenses.calculate(seats),
        expiration_time: expiration_time,
        time_remaining: time_remaining(expiration_time)
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Team License</h1>
    <div id="license">
      <div class="card">
        <div class="content">
          <div class="seats">
            <img src="images/license.svg">
            <span>
            Your license is currently for <%= seats(@seats) %>.
            </span>
          </div>

          <p class="mb-4 font-semibold text-indigo-800">
            <%= @time_remaining %> left to save 20%
          </p>

          <form phx-change="update">
            <input type="range" name="seats" min="1" max="10" value="<%= @seats %>" />
          </form>

          <div class="amount"><%= number_to_currency(@amount) %></div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("update", %{"seats" => seats}, socket) do
    seats = String.to_integer(seats)

    socket = assign(socket, seats: seats, amount: Licenses.calculate(seats))
    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    expiration_time = socket.assigns.expiration_time
    socket = assign(socket, time_remaining: time_remaining(expiration_time))
    {:noreply, socket}
  end

  def handle_info({:set_expiration_time, expiration_time}, socket) do
    socket =
      assign(socket,
        expiration_time: expiration_time,
        time_remaining: time_remaining(expiration_time)
      )

    {:noreply, socket}
  end

  def time_remaining(expiration_time) do
    Timex.Interval.new(from: Timex.now(), until: expiration_time)
    |> Timex.Interval.duration(:seconds)
    |> Timex.Duration.from_seconds()
    |> Timex.format_duration(:humanized)
  end

  def seats(1), do: ~E"<strong>1</strong> seat"
  def seats(seats), do: ~E"<strong><%= seats %></strong> seats"
end
