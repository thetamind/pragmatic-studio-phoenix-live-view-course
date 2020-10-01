defmodule LiveViewStudio.SandboxCalculator do
  def calculate_weight(length, width, depth) do
    l = to_integer(length)
    w = to_integer(width)
    d = to_integer(depth)

    (l * w * d * 7.3) |> Float.round(2)
  end

  def calculate_price(weight) do
    weight * 1.5
  end

  defp to_integer(param) do
    case Integer.parse(param) do
      {value, ""} ->
        value

      :error ->
        0
    end
  end
end
