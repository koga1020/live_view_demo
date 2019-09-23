defmodule LiveViewDemoWeb.PomodoroLive do
  use Phoenix.LiveView
  import Calendar.Strftime
  alias LiveViewDemoWeb.PomodoroView
  alias LiveViewDemo.Pomodoro
  alias LiveViewDemo.Pomodoro.Task

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
    changeset = Pomodoro.change_task(%Task{})

    {:ok,
     assign(socket,
       mode: :not_yet,
       elapsed: 0,
       current_pomodoro: 0,
       minutes: 0,
       seconds: 0,
       changeset: changeset,
       tasks: Pomodoro.list_tasks()
     )}
  end

  def handle_event("submit", %{"task" => task_params}, socket) do
    case Pomodoro.create_task(task_params) do
      {:ok, task} ->
        {:noreply,
         socket
         |> assign(tasks: Pomodoro.list_tasks())}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("start", _, socket) do
    :timer.send_interval(1000, self(), :tick)

    {:noreply,
     socket
     |> assign(
       mode: :active,
       elapsed: 0,
       current_pomodoro: 0
     )}
  end

  def handle_event("delete_task", task_id, socket) do
    task = Pomodoro.get_task!(task_id)

    {:ok, _task} = Pomodoro.delete_task(task)

    {:noreply,
     socket
     |> assign(tasks: Pomodoro.list_tasks())}
  end

  def handle_info(:tick, socket) do
    {:noreply, put_timer(socket)}
  end

  @working_seconds 1500
  defp put_timer(
         %{
           assigns: %{
             current_pomodoro: current_pomodoro,
             mode: :active,
             elapsed: @working_seconds
           }
         } = socket
       ) do
    finished_pomodoro_count = current_pomodoro + 1

    rest_mode =
      case rem(finished_pomodoro_count, 4) do
        0 -> :long_rest
        _ -> :rest
      end

    assign(socket,
      mode: rest_mode,
      elapsed: 0,
      seconds: 0,
      current_pomodoro: finished_pomodoro_count
    )
  end

  @rest_seconds 300
  defp put_timer(%{assigns: %{mode: :rest, elapsed: @rest_seconds}} = socket),
    do: activate(socket)

  @long_rest_seconds 900
  defp put_timer(%{assigns: %{mode: :long_rest, elapsed: @long_rest_seconds}} = socket),
    do: activate(socket)

  defp activate(socket) do
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
  defp get_mode_seconds(:long_rest), do: @long_rest_seconds
end
