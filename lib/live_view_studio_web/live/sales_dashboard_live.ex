defmodule LiveViewStudioWeb.SalesDashboardLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Sales

  def mount(_params, _session, socket) do
    socket = assign(socket, refresh: 1)
    if connected?(socket), do: schedule_refresh(socket)

    socket = assign_stats(socket)

    {:ok, socket}
  end

  def handle_event("refresh", _, socket) do
    socket = assign_stats(socket)

    {:noreply, socket}
  end

  def handle_event("select-refresh", %{"refresh" => refresh}, socket) do
    refresh = String.to_integer(refresh)
    socket = assign(socket, refresh: refresh)
    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    socket =
      socket
      |> assign_stats()
      |> schedule_refresh()

    {:noreply, socket}
  end

  def assign_stats(socket) do
    assign(socket,
      new_orders: Sales.new_orders(),
      sales_amount: Sales.sales_amount(),
      satisfaction: Sales.satisfaction(),
      last_updated_at: Timex.local()
    )
  end

  def schedule_refresh(socket) do
    Process.send_after(self(), :tick, socket.assigns.refresh * 1000)
    socket
  end

  def refresh_select(refresh) do
    Phoenix.HTML.Form.options_for_select(refresh_options(), refresh)
  end

  def refresh_options do
    [{"1s", 1}, {"5s", 5}, {"15s", 15}, {"30s", 30}, {"60s", 60}]
  end

  def time(time) do
    Timex.format!(time, "%T", :strftime)
  end
end
