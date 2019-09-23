defmodule LiveViewDemoWeb.PomodoroView do
  use LiveViewDemoWeb, :view

  def task_state_class(pomodoro_count, index) do
    cond do
      pomodoro_count == index ->
        "active-task"

      pomodoro_count > index ->
        "finished-task"

      true ->
        ""
    end
  end

  @message %{
    active: "start pomodoro!",
    break: "start short break!",
    long_break: "start long break!"
  }
  def notification_script(mode, notification_id) do
    message = Map.get(@message, mode)

    """
      <script id="#{notification_id}">
      if (Notification.permission === "granted") {
        new Notification("#{message}");
      }
    </script>
    """
  end
end
