defmodule GameOfLife.Cell do
  alias __MODULE__

  defstruct x: nil, y: nil, state: :dead

  def switch_state(%Cell{state: :dead} = cell), do: %{cell | state: :alive}
  def switch_state(%Cell{state: :alive} = cell), do: %{cell | state: :dead}
end

defmodule GameOfLife.Game do
  use Agent
  alias GameOfLife.Cell

  @size 30
  @neighbours [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]

  def begin do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
    populate_board()
  end

  def populate_board do
    for y <- 1..@size do
      for x <- 1..@size do
        cell = %Cell{x: x, y: y}
        Agent.update(__MODULE__, &Map.put(&1, {x, y}, cell))
      end
    end
  end

  def switch_state(x, y) do
    Agent.update(__MODULE__, &Map.update!(&1, {x, y}, fn cell -> Cell.switch_state(cell) end))
  end

  def get(x, y) do
    coords = {x, y}
    %{^coords => cell} = Agent.get(__MODULE__, & &1)
    cell
  end

  def values do
    Agent.get(__MODULE__, & &1)
  end

  def next_iter do
    cells = values()

    new_cells =
      cells
      |> Enum.map(fn {_coords, cell} -> evolve(cell, cells) end)
      |> Enum.reject(&is_nil/1)

    Enum.map(new_cells, fn cell -> switch_state(cell.x, cell.y) end)

    case Enum.count(values(), fn {_, %Cell{state: state}} -> state == :alive end) do
      0 -> :stop
      _ -> :continue
    end
  end

  defp evolve(%Cell{state: :alive} = cell, cells) do
    case count_alive_neighbours(cell, cells) do
      2 -> nil
      3 -> nil
      _ -> Cell.switch_state(cell)
    end
  end
  defp evolve(%Cell{state: :dead} = cell, cells) do
    case count_alive_neighbours(cell, cells) do
      3 -> Cell.switch_state(cell)
      _ -> nil
    end
  end

  defp count_alive_neighbours(%Cell{x: x, y: y}, cells) do
    (for {x_nghbr, y_nghbr} <- @neighbours, do: Map.get(cells, {x + x_nghbr, y + y_nghbr}))
    |> Enum.reject(&is_nil/1)
    |> Enum.count(&(&1.state == :alive))
  end
end
