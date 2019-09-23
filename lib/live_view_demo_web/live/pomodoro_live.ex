defmodule LiveViewDemoWeb.PomodoroLive do
  use Phoenix.LiveView
  import Calendar.Strftime
  alias LiveViewDemoWeb.PomodoroView

  @doc """
  ToDo:

  - tasksを入力する
  - taskになにポモドーロ分実行するか入力する
  - 上から順に実行される
    - 順序はdrag & dropで変更できるようにしたい
  - 回数は一旦固定(25min, 5minを4回 / 15minの休憩)
  - startを実行
    - タスクの総数から、総ポモドーロを計算
    - 現在の実行回数 - (該当タスクのポモドーロ数 - 過去タスクのポモドーロ数) > 0の場合、該当タスクは終了状態とする
      - 打ち消し線的なUI?
  """

  def render(assigns) do
    PomodoroView.render("pomodoro.html", assigns)
  end

  def mount(_session, socket) do
    {:ok,
     assign(socket,
       mode: :not_yet,
       elapsed: 0,
       minutes: 0,
       seconds: 0
     )}
  end

  def handle_event("submit", %{"task" => task_param}, socket) do
    {:noreply, socket}
  end

  def handle_event("start", _, socket) do
    :timer.send_interval(1000, self(), :tick)

    {:noreply,
     socket
     |> assign(
       mode: :active,
       elapsed: 0
     )}
  end

  def handle_info(:tick, socket) do
    {:noreply, put_timer(socket)}
  end

  @working_seconds 1500
  defp put_timer(%{assigns: %{mode: :active, elapsed: @working_seconds}} = socket) do
    assign(socket,
      mode: :rest,
      elapsed: 0,
      seconds: 0
    )
  end

  @rest_seconds 300
  defp put_timer(%{assigns: %{mode: :rest, elapsed: @rest_seconds}} = socket) do
    assign(socket,
      mode: :active,
      elapsed: 0,
      seconds: 0
    )
  end

  defp put_timer(socket) do
    %{assigns: %{elapsed: elapsed, mode: mode}} = socket

    mode_seconds = get_mode_seconds(mode)

    minutes = div(mode_seconds - elapsed, 60)
    seconds = rem(mode_seconds - elapsed, 60)

    assign(socket, elapsed: elapsed + 1, minutes: minutes, seconds: seconds)
  end

  defp get_mode_seconds(:active), do: @working_seconds
  defp get_mode_seconds(:rest), do: @rest_seconds
end
