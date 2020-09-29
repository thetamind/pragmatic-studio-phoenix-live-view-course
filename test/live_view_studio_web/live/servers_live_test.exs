defmodule LiveViewStudioWeb.ServersLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias LiveViewStudioWeb.ServersLive

  setup [:fixtures]

  test "shows first server by default", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/servers")

    assert element(view, ".card", "I'm going disco") |> render()
  end

  test "shows server after selection", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/servers")

    assert element(view, ".card", "I'm going disco") |> render()

    html =
      view
      |> element("#servers nav a", "lively-frog")
      |> render_click()

    assert_patched(view, "/servers?name=lively-frog")
    assert page_title(view) =~ "lively-frog"
    assert element(view, ".card", "Does it scale?") |> render()
    assert html =~ "Does it scale?"
    refute html =~ "I'm going disco"
  end

  describe "status" do
    test "toggle up/down", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/servers?name=dancing-lizard")
      assert_status(view, :up)

      toggle_status(view)
      assert_status(view, :down)

      toggle_status(view)
      assert_status(view, :up)
    end
  end

  defp assert_status(view, expected) do
    assert view |> element(".card .header button") |> render() =~ Atom.to_string(expected)
  end

  defp toggle_status(view) do
    assert view |> element(".card .header button") |> render_click()
  end

  describe "add server" do
    test "cancel form navigates to list servers", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/servers")

      assert element(view, "a", "Add Server") |> render_click()
      assert_patched(view, "/servers/new")

      assert element(view, ".cancel", "Cancel") |> render_click()

      assert_patched(view, "/servers")
      assert element(view, ".card", "I'm going disco") |> render()
    end

    test "valid params prepends to servers", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/servers")

      assert element(view, "a", "Add Server") |> render_click()

      params = %{
        name: "agile-stoat",
        framework: "Elixir/Phoenix",
        size: "25",
        git_repo: "https://git.example.com/agile-stoat.git"
      }

      assert view |> form("form", server: params) |> render_submit()

      assert_patched(view, "/servers?name=agile-stoat")
      assert view |> element(".sidebar .active") |> render() =~ "agile-stoat"
    end

    test "invalid params display validation errors", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/servers")

      assert element(view, "a", "Add Server") |> render_click()

      params = %{name: "rejected-rabbit", framework: "", size: "", git_repo: "Z"}

      assert view |> form("form", server: params) |> render_submit()

      assert_patched(view, "/servers/new")
      assert view |> element("form") |> render() =~ "can&apos;t be blank"
    end

    test "live validation display validation errors", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/servers")

      assert element(view, "a", "Add Server") |> render_click()

      params = %{name: " ", framework: "Z", size: "0", git_repo: "z"}

      assert view |> form("form") |> render_change(server: Map.take(params, [:name]))
      assert feedback_for(view, "name") =~ "be blank"

      assert view |> form("form") |> render_change(server: Map.take(params, [:framework]))
      assert feedback_for(view, "framework") =~ "at least 2"

      assert view |> form("form") |> render_change(server: Map.take(params, [:size]))
      assert feedback_for(view, "size") =~ "greater than 0"

      assert view |> form("form") |> render_change(server: Map.take(params, [:git_repo]))
      assert feedback_for(view, "git_repo") =~ "at least 2"

      assert_patched(view, "/servers/new")
    end

    test "new server form while receiving update events", %{conn: conn} do
      {:ok, view_new, _html} = live(conn, "/servers/new")

      {:ok, view, _html} = live(conn, "/servers?name=dancing-lizard")
      assert_status(view, :up)
      toggle_status(view)
      assert_status(view, :down)

      assert view_new |> form("form") |> render()
    end
  end

  defp feedback_for(view, field) do
    view |> element(~s(.field [phx-feedback-for$="#{field}])) |> render()
  end

  test "extract nested params in handle_event" do
    params = %{
      "_csrf_token" => "token",
      "server[framework]" => "framework",
      "server[git_repo]" => "git",
      "server[name]" => "name",
      "server[size]" => "100"
    }

    expected = %{
      "_csrf_token" => "token",
      "server" => %{
        "framework" => "framework",
        "git_repo" => "git",
        "name" => "name",
        "size" => "100"
      }
    }

    assert ServersLive.decode_params(params) == expected
  end

  defp fixtures(_context) do
    alias LiveViewStudio.Repo
    alias LiveViewStudio.Servers.Server

    %Server{
      name: "lively-frog",
      status: "up",
      deploy_count: 12,
      size: 24.0,
      framework: "Elixir/Phoenix",
      git_repo: "https://git.example.com/lively-frog.git",
      last_commit_id: "d2eba26",
      last_commit_message: "Does it scale? 🤔"
    }
    |> Repo.insert!()

    %Server{
      name: "dancing-lizard",
      status: "up",
      deploy_count: 14,
      size: 19.5,
      framework: "Elixir/Phoenix",
      git_repo: "https://git.example.com/dancing-lizard.git",
      last_commit_id: "f3d41f7",
      last_commit_message: "If this works, I'm going disco    🕺"
    }
    |> Repo.insert!()

    :ok
  end
end
