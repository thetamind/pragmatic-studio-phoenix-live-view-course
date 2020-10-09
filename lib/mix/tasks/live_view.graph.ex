defmodule Mix.Tasks.LiveView.Graph do
  use Mix.Task

  @impl true
  def run(_args) do
    unless Version.match?(System.version(), ">= 1.10.0-rc") do
      Mix.raise("Elixir v1.10+ is required!")
    end

    LiveViewGraph.Tracer.init()

    Code.compiler_options(parser_options: [columns: true])
    Mix.Task.rerun("compile.elixir", ["--force", "--tracer", "LiveViewGraph.Tracer"])

    entries = Elixir.LiveViewGraph.Tracer.entries()
    LiveViewGraph.Reporter.report(entries)
  end
end
