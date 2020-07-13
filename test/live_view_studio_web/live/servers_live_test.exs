defmodule LiveViewStudioWeb.ServersLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  alias LiveViewStudio.Servers.Server
  alias LiveViewStudio.Repo

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

    assert page_title(view) =~ "lively-frog"
    assert element(view, ".card", "Does it scale?") |> render()
    assert html =~ "Does it scale?"
    refute html =~ "I'm going disco"
  end

  defp fixtures(_context) do
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

    :ok
  end
end
