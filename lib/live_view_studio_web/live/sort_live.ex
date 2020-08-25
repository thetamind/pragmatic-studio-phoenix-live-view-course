defmodule LiveViewStudioWeb.SortLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Donations

  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [donations: []]}
  end

  def handle_params(params, _url, socket) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "5")
    sort_by = String.to_existing_atom(params["sort_by"] || "id")
    sort_order = String.to_existing_atom(params["sort_order"] || "asc")

    paginate_options = %{page: page, per_page: per_page}
    sort_options = %{sort_by: sort_by, sort_order: sort_order}
    donations = Donations.list_donations(paginate: paginate_options, sort: sort_options)

    socket =
      assign(socket,
        options: Map.merge(paginate_options, sort_options),
        donations: donations
      )

    {:noreply, socket}
  end

  def handle_event("select-per-page", %{"per-page" => per_page}, socket) do
    per_page = String.to_integer(per_page)

    %{page: page} = change_per_page(socket.assigns.options, per_page)

    socket =
      push_patch(socket,
        to:
          Routes.live_path(
            socket,
            __MODULE__,
            page: page,
            per_page: per_page
          )
      )

    {:noreply, socket}
  end

  def change_per_page(%{page: page, per_page: per_page}, new_per_page) do
    anchor = page * per_page

    new_page = div(anchor, new_per_page) + 1

    %{page: new_page, per_page: new_per_page}
  end

  defp expires_class(donation) do
    if Donations.almost_expired?(donation), do: "eat-now", else: "fresh"
  end

  defp pagination_link(socket, text, page, per_page, class) do
    live_patch(text,
      to:
        Routes.live_path(socket, __MODULE__,
          page: page,
          per_page: per_page
        ),
      class: class
    )
  end
end
