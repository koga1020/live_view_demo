defmodule LiveViewDemoWeb.PomodoroController do
  use LiveViewDemoWeb, :controller
  alias LiveViewDemoWeb.PomodoroLive
  alias Phoenix.LiveView
  alias LiveViewDemo.Pomodoro

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, _params) do
    case Pomodoro.create_room() do
      {:ok, room} ->
        conn
        |> redirect(to: Routes.pomodoro_path(conn, :show, room.hash))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"hash" => hash}) do
    room = Pomodoro.get_room_by_hash!(hash)

    LiveView.Controller.live_render(conn, PomodoroLive, session: %{room: room})
  end
end
