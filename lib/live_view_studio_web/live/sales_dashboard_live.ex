defmodule LiveViewStudioWeb.SalesDashboardLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Sales

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(refresh: 1, timer: nil)
      |> schedule_refresh()
      |> assign_stats()

    {:ok, socket}
  end

  def handle_event("refresh", _, socket) do
    socket = assign_stats(socket)

    {:noreply, socket}
  end

  def handle_event("select-refresh", %{"refresh" => refresh}, socket) do
    refresh = String.to_integer(refresh)

    socket =
      socket
      |> assign(refresh: refresh)
      |> schedule_refresh()

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
      satisfaction: Sales.satisfaction(),
      last_updated_at: Timex.local()
    )
  end

  def schedule_refresh(socket) do
    if connected?(socket) do
      _ = :timer.cancel(socket.assigns.timer)
      {:ok, timer} = :timer.send_interval(socket.assigns.refresh * 1000, :tick)

      assign(socket, timer: timer)
    else
      socket
    end
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
