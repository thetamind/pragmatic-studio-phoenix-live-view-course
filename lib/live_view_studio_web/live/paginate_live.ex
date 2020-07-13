defmodule LiveViewStudioWeb.PaginateLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Donations

  def mount(_params, _session, socket) do
    donations = Donations.list_donations()

    socket =
      assign(socket,
        donations: donations
      )

    {:ok, socket, temporary_assigns: [donations: []]}
  end

  defp expires_class(donation) do
    if Donations.almost_expired?(donation), do: "eat-now", else: "fresh"
  end
end
