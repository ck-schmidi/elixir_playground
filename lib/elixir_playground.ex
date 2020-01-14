defmodule ElixirPlayground do
  def accumulate(base) do
    base
    |> Enum.reduce([], fn x, acc ->
      case acc do
        [] -> [x]
        acc -> acc ++ [Enum.at(acc, -1) + x]
      end
    end)
  end
end
