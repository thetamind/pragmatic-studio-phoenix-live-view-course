defmodule LiveViewGraph do
  def trace({:imported_function, meta, module, name, arity} = event, env)
      when name in ~w(send self {})a do
    store(env.module, env.file, meta[:line], meta[:column], module, name, arity)
    :ok
  end

  def trace(_, _), do: :ok

  def init do
    :ets.new(:live_view_graph, [:bag, :named_table, :public])
  end

  def store(env_module, file, line, column, module, name, arity) do
    function = "#{inspect(module)}.#{name}/#{arity}"
    :ets.insert(:live_view_graph, {function, file, line, column, env_module})
  end

  @b :_

  def entries() do
    :ets.match_object(:live_view_graph, {@b, @b, @b, @b, @b})
  end

  @column_stream [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
                 |> Stream.cycle()
                 |> Stream.take(30)
                 |> Enum.join()

  def report(entries) do
    for {function, file, line, column, env_module} = entry <- entries do
      IO.inspect(entry)
      IO.puts(@column_stream)

      lines = File.read!(file) |> String.split("\n")

      line = Enum.at(lines, line - 1)
      IO.puts(line)

      code = case String.split(line, "->", parts: 2) do
        [leader, needle] -> needle
        [needle] -> needle
      end

      {:ok, ast} = Code.string_to_quoted(code)

      send_args = fn
        {:send, _meta, args} = node, acc -> {node, [args |> Enum.at(1) |> elem(0) | acc]}
        node, acc -> {node, acc}
      end

      event = Macro.prewalk(ast, [], send_args)
      |> elem(1)
      |> List.first()

      IO.inspect(event, label: "event")
      IO.puts("")
    end
  end
end

defmodule Mix.Tasks.LiveViewGraph do
  use Mix.Task

  @impl true
  def run(_args) do
    unless Version.match?(System.version(), ">= 1.10.0-rc") do
      Mix.raise("Elixir v1.10+ is required!")
    end

    LiveViewGraph.init()

    Code.compiler_options(parser_options: [columns: true])
    Mix.Task.rerun("compile.elixir", ["--force", "--tracer", "LiveViewGraph"])

    entries = LiveViewGraph.entries()
    LiveViewGraph.report(entries)
  end
end

Mix.Task.run("live_view_graph")
