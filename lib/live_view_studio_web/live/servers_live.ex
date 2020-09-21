defmodule LiveViewStudioWeb.ServersLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Servers

  def mount(_params, _session, socket) do
    servers = Servers.list_servers()

    socket =
      assign(socket,
        changeset: nil,
        servers: servers,
        selected_server: hd(servers)
      )

    {:ok, socket}
  end

  def handle_params(%{"name" => name}, _url, socket) do
    server = Servers.get_server_by_name(name)

    socket = assign(socket, selected_server: server, page_title: server.name)

    {:noreply, socket}
  end

  def handle_params(_params, _url, socket) do
    socket =
      if socket.assigns.live_action == :new do
        socket =
          Phoenix.LiveView.update(socket, :changeset, fn
            nil -> Servers.change_server(%Servers.Server{})
            changeset -> changeset
          end)

        assign(socket, selected_server: nil)
      else
        first_server = hd(socket.assigns.servers)

        assign(socket, selected_server: first_server)
      end

    {:noreply, socket}
  end

  def handle_event("validate", %{"server" => params}, socket) do
    changeset =
      Servers.change_server(%Servers.Server{}, params)
      |> Map.put(:action, :insert)

    socket = assign(socket, changeset: changeset)
    {:noreply, socket}
  end

  def handle_event("stashform", params, socket) do
    nested_params =
      decode_params(params)
      |> Map.get("server")

    changeset = Servers.change_server(%Servers.Server{}, nested_params)
    socket = assign(socket, changeset: changeset)
    {:noreply, socket}
  end

  def handle_event("save", %{"server" => params}, socket) do
    socket =
      case Servers.create_server(params) do
        {:ok, server} ->
          path = Routes.live_path(socket, __MODULE__, name: server.name)

          socket
          |> update(:servers, fn servers -> [server | servers] end)
          |> assign(changeset: nil)
          |> push_patch(to: path)

        {:error, changeset} ->
          assign(socket, changeset: changeset)
      end

    {:noreply, socket}
  end

  def decode_params(params) do
    params
    |> Enum.reduce(%{}, fn {key, value}, acc ->
      path =
        key
        |> String.split(~w([ ]), trim: true)
        |> Enum.map(&Access.key(&1, %{}))

      put_in(acc, path, value)
    end)
  end

  def render(assigns) do
    ~L"""
    <h1>Servers</h1>
    <%= live_patch "Add Server",
          to: Routes.servers_path(@socket, :new),
          class: "w-48 text-center -mt-4 mb-2 block underline" %>
    <div id="servers">
      <div class="sidebar">
        <nav>
          <%= for server <- @servers do %>
            <div>
            <%= live_patch link_body(server),
              to: Routes.live_path(
                  @socket,
                  __MODULE__,
                  name: server.name
              ),
              class: if server == @selected_server, do: "active" %>
            </div>
          <% end %>
        </nav>
      </div>
      <div class="main">
        <div class="wrapper">
          <%= if @live_action == :new do %>
            <%= f = form_for @changeset, "#", phx_submit: "save", phx_change: "validate", phx_hook: "StashForm", id: "new-server-form" %>
              <div class="field">
                <%= label f, :name %>
                <%= text_input f, :name, autocomplete: "off", phx_debounce: "2000" %>
                <%= error_tag f, :name %>
              </div>
              <div class="field">
                <%= label f, :framework %>
                <%= text_input f, :framework, autocomplete: "off", phx_debounce: "2000" %>
                <%= error_tag f, :framework %>
              </div>
              <div class="field">
                <%= label f, :size, "Size (MB)" %>
                <%= text_input f, :size, autocomplete: "off", phx_debounce: "2000" %>
                <%= error_tag f, :size %>
              </div>
              <div class="field">
                <%= label f, :git_repo, "Git Repo" %>
                <%= text_input f, :git_repo, autocomplete: "off", phx_debounce: "2000" %>
                <%= error_tag f, :git_repo %>
              </div>

              <%= submit "Save", phx_disable_with: "Saving..." %>
              <%= live_patch "Cancel",
                  to: Routes.live_path(@socket, __MODULE__),
                  class: "cancel" %>
            </form>
          <% else %>
          <div class="card">
            <div class="header">
              <h2><%= @selected_server.name %></h2>
              <span class="<%= @selected_server.status %>">
                <%= @selected_server.status %>
              </span>
            </div>
            <div class="body">
              <div class="row">
                <div class="deploys">
                  <img src="/images/deploy.svg">
                  <span>
                    <%= @selected_server.deploy_count %> deploys
                  </span>
                </div>
                <span>
                  <%= @selected_server.size %> MB
                </span>
                <span>
                  <%= @selected_server.framework %>
                </span>
              </div>
              <h3>Git Repo</h3>
              <div class="repo">
                <%= @selected_server.git_repo %>
              </div>
              <h3>Last Commit</h3>
              <div class="commit">
                <%= @selected_server.last_commit_id %>
              </div>
              <blockquote>
                <%= @selected_server.last_commit_message %>
              </blockquote>
            </div>
          <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp link_body(server) do
    assigns = %{name: server.name, status: server.status}

    ~L"""
    <span class="status <%= @status %>"></span>
    <img src="/images/server.svg">
    <%= @name %>
    """
  end
end
