defmodule LiveViewStudioWeb.SalesDashboardLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Sales

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, self(), :tick)

    socket = assign_stats(socket)

    {:ok, socket}
  end

  def handle_event("refresh", _, socket) do
    socket = assign_stats(socket)

    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    socket = assign_stats(socket)

    {:noreply, socket}
  end

  def assign_stats(socket) do
    assign(socket,
      new_orders: Sales.new_orders(),
      sales_amount: Sales.sales_amount(),
      satisfaction: Sales.satisfaction()
    )
  end
end
