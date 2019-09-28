defmodule LiveViewDemoWeb.PomodoroLive.New do
  use Phoenix.LiveView
  alias LiveViewDemoWeb.PomodoroView
  alias LiveViewDemo.Pomodoro
  alias LiveViewDemoWeb.PomodoroLive
  alias LiveViewDemoWeb.Router.Helpers, as: Routes

  def render(assigns) do
    PomodoroView.render("new.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, socket}
  end

  def handle_event("submit", _, socket) do
    case Pomodoro.create_room() do
      {:ok, room} ->
        {:stop,
         socket
         |> redirect(to: Routes.live_path(socket, PomodoroLive.Show, room.hash))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
