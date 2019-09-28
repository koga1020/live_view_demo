defmodule LiveViewDemoWeb.PomodoroLive.Show do
  use Phoenix.LiveView
  alias LiveViewDemoWeb.PomodoroView
  alias LiveViewDemo.Pomodoro
  alias LiveViewDemo.Pomodoro.Task
  alias DemoWeb.Router.Helpers, as: Routes
  alias LiveViewDemoWeb.PomodoroLive

  def mount(session, socket) do
    changeset = Pomodoro.change_task(%Task{})

    {:ok,
     assign(socket,
       mode: :inactive,
       elapsed: 0,
       current_pomodoro: 0,
       minutes: 25,
       seconds: 0,
       changeset: changeset,
       notification_id: nil
     )}
  end

  def handle_params(%{"hash" => hash}, val, socket) do
    room = Pomodoro.get_room_by_hash!(hash)

    {:noreply, assign(socket, room: room, tasks: Pomodoro.list_tasks(room.id))}
  end

  def render(assigns) do
    PomodoroView.render("show.html", assigns)
  end

  def handle_event("submit", %{"task" => task_params}, socket) do
    room_id = socket.assigns.room.id
    tasks_count = Enum.count(socket.assigns.tasks)

    case Pomodoro.create_task(
           task_params
           |> Map.put("room_id", room_id)
           |> Map.put("sort", tasks_count + 1)
         ) do
      {:ok, _} ->
        {:noreply,
         socket
         |> assign(tasks: Pomodoro.list_tasks(room_id))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("start", _, socket) do
    :timer.send_interval(1000, self(), :tick)

    {:noreply,
     socket
     |> activate()
     |> assign(current_pomodoro: 0)}
  end

  def handle_event("delete_task", %{"id" => task_id}, socket) do
    task = Pomodoro.get_task!(task_id)

    {:ok, _task} = Pomodoro.delete_task(task)

    {:noreply,
     socket
     |> assign(tasks: Pomodoro.list_tasks(socket.assigns.room.id))}
  end

  def handle_event(
        "sort_task",
        %{"moved_task_id" => moved_task_id, "new_sort_value" => new_sort_value},
        socket
      ) do
    room_id = socket.assigns.room.id
    to_move_task = Pomodoro.get_task!(moved_task_id)

    cond do
      to_move_task.sort + 1 == new_sort_value ->
        {:noreply, socket}

      to_move_task.sort < new_sort_value == true ->
        Pomodoro.down_task_sort(room_id, to_move_task, new_sort_value)
        {:noreply, socket |> assign(tasks: Pomodoro.list_tasks(socket.assigns.room.id))}

      to_move_task.sort > new_sort_value == true ->
        Pomodoro.up_task_sort(room_id, to_move_task, new_sort_value)
        {:noreply, socket |> assign(tasks: Pomodoro.list_tasks(socket.assigns.room.id))}
    end
  end

  def handle_info(:tick, socket) do
    update_socket = put_timer(socket)

    if update_socket.assigns.current_pomodoro == Enum.count(update_socket.assigns.tasks) do
      {:stop,
       update_socket
       |> put_flash(:info, "Finish all pomodoro!")
       |> redirect(
         to: Routes.live_path(socket, PomodoroLive.Show, update_socket.assigns.room.hash)
       )}
    else
      {:noreply, update_socket}
    end
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

    break_mode =
      case rem(finished_pomodoro_count, 4) do
        0 -> :long_break
        _ -> :break
      end

    assign(socket,
      mode: break_mode,
      elapsed: 0,
      seconds: 0,
      current_pomodoro: finished_pomodoro_count
    )
  end

  @break_seconds 300
  defp put_timer(%{assigns: %{mode: :break, elapsed: @break_seconds}} = socket),
    do: activate(socket)

  @long_break_seconds 900
  defp put_timer(%{assigns: %{mode: :long_break, elapsed: @long_break_seconds}} = socket),
    do: activate(socket)

  defp put_timer(%{assigns: %{elapsed: 0}} = socket) do
    socket
    |> assign_timer_val()
    |> assign(notification_id: Ecto.UUID.generate())
  end

  defp put_timer(socket) do
    assign_timer_val(socket)
  end

  defp assign_timer_val(socket) do
    %{assigns: %{elapsed: elapsed, mode: mode}} = socket

    mode_seconds = get_mode_seconds(mode)

    minutes = div(mode_seconds - elapsed, 60)
    seconds = rem(mode_seconds - elapsed, 60)

    assign(socket, elapsed: elapsed + 1, minutes: minutes, seconds: seconds)
  end

  defp activate(socket) do
    socket
    |> assign(
      mode: :active,
      elapsed: 0,
      seconds: 0
    )
  end

  defp get_mode_seconds(:active), do: @working_seconds
  defp get_mode_seconds(:break), do: @break_seconds
  defp get_mode_seconds(:long_break), do: @long_break_seconds
end
