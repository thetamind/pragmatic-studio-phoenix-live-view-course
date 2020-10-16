defmodule LiveViewGraph do
end

defmodule LiveViewGraph.Tracer do
  def trace({:imported_function, meta, module, name, arity}, env)
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
end

defmodule LiveViewGraph.Reporter do
  def maybe_remove_fn_clause(line) do
    case String.split(line, "->", parts: 2) do
      [_clause, body] -> body
      [body] -> body
    end
  end

  def to_quoted(line), do: Code.string_to_quoted!(line)

  def grab_args(list) do
    case list do
      event when is_atom(event) -> event
      {:{}, _meta, args} -> args |> List.first()
      tuple when is_tuple(tuple) -> elem(tuple, 0)
    end
  end

  @spec find_event(Macro.t()) :: atom()
  def find_event(ast) do
    send_args = fn
      {:send, _meta, args} = node, acc -> {node, [args |> Enum.at(1) |> grab_args() | acc]}
      node, acc -> {node, acc}
    end

    Macro.prewalk(ast, [], send_args)
    |> elem(1)
    |> List.first()
  end

  def report(entries) do
    for {_function, file, line, _column, _env_module} <- entries do
      lines = File.read!(file) |> String.split("\n")

      line = Enum.at(lines, line - 1)
      IO.puts(line)

      event =
        line
        |> maybe_remove_fn_clause()
        |> to_quoted
        |> find_event

      IO.inspect(event, label: "event")
      IO.puts("")
    end
  end
end
