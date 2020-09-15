defmodule LiveViewStudioWeb.ServersLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  alias LiveViewStudio.Servers.Server
  alias LiveViewStudio.Repo
  import Phoenix.LiveViewTest

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
  end

  defp fixtures(_context) do
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
