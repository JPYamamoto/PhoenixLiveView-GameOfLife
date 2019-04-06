defmodule GameOfLifeWeb.PageController do
  use GameOfLifeWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    LiveView.Controller.live_render(conn, GameOfLifeWeb.GOLLive, session: %{})
  end
end
