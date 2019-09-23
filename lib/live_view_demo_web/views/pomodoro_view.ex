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
end
