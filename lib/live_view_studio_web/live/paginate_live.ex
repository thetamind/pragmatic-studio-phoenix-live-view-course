defmodule LiveViewStudioWeb.PaginateLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Donations

  def mount(_params, _session, socket) do
    pagination_options = %{page: 1, per_page: 5}
    donations = Donations.list_donations(paginate: pagination_options)

    socket =
      assign(socket,
        options: pagination_options,
        donations: donations
      )

    {:ok, socket, temporary_assigns: [donations: []]}
  end

  def handle_params(params, _url, socket) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "5")

    pagination_options = %{page: page, per_page: per_page}
    donations = Donations.list_donations(paginate: pagination_options)

    socket =
      assign(socket,
        options: pagination_options,
        donations: donations
      )

    {:noreply, socket}
  end

  defp expires_class(donation) do
    if Donations.almost_expired?(donation), do: "eat-now", else: "fresh"
  end
end
