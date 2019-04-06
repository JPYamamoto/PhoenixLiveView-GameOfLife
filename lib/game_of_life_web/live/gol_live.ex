defmodule GameOfLifeWeb.GOLLive do
  use Phoenix.LiveView
  alias Phoenix.LiveView.Socket
  alias GameOfLife.Game

  @fps 5

  def render(assigns) do
    GameOfLifeWeb.PageView.render("index.html", assigns)
  end

  def mount(_session, socket) do
    Game.begin()
    {:ok, assign(socket, rows: get_rows(), running: false)}
  end

  defp schedule_next_iter(fps, true), do: Process.send_after(self(), :next_iter, trunc(1000/fps))
  defp schedule_next_iter(_fps, false), do: :stop

  def handle_info(:next_iter, socket) do
    if Game.next_iter() == :stop do
      {:noreply, assign(socket, rows: get_rows(), running: false)}
    else
      schedule_next_iter(@fps, socket.assigns.running)
      {:noreply, assign(socket, rows: get_rows())}
    end
  end

  def handle_event("clear", _value, socket) do
    Game.begin()
    {:noreply, assign(socket, rows: get_rows(), running: false)}
  end

  def handle_event("switch_state", _value, %Socket{assigns: %{running: true}} = socket), do: {:noreply, socket}
  def handle_event("switch_state", value, socket) do
    [x, y] = String.split(value, ",")
    x = String.to_integer(x)
    y = String.to_integer(y)

    Game.switch_state(x, y)

    {:noreply, assign(socket, rows: get_rows())}
  end

  def handle_event("run", _value, socket) do
    socket = assign(socket, running: !socket.assigns.running)
    schedule_next_iter(@fps, socket.assigns.running)
    {:noreply, socket}
  end

  defp get_rows do
    Game.values()
    |> Enum.group_by(fn {{_, y}, _} -> y end)
    |> Enum.sort()
    |> Enum.map(fn {row, columns} -> {row, Enum.sort_by(columns, fn {{x, _}, _} -> x end)} end)
  end
end
