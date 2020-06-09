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

  def render(assigns) do
    ~L"""
    <h1>Food Bank Donations</h1>
    <div id="donations">
      <div class="wrapper">
        <table>
          <thead>
            <tr>
              <th class="item">
                Item
              </th>
              <th>
                Quantity
              </th>
              <th>
                Days Until Expires
              </th>
            </tr>
          </thead>
          <tbody>
            <%= for donation <- @donations do %>
              <tr>
                <td class="item">
                  <span class="id"><%= donation.id %></span>
                  <%= donation.emoji %> <%= donation.item %>
                </td>
                <td>
                  <%= donation.quantity %> lbs
                </td>
                <td>
                  <span class="<%= expires_class(donation) %>">
                    <%= donation.days_until_expires %>
                  </span>
                </td>
              </tr>
            <% end %>
          </tbody>
        </table>
        <div class="footer">
          <div class="pagination">
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp expires_class(donation) do
    if Donations.almost_expired?(donation), do: "eat-now", else: "fresh"
  end
end
