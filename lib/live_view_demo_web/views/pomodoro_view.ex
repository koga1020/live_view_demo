defmodule LiveViewDemoWeb.PomodoroView do
  use LiveViewDemoWeb, :view

  def task_state_class(current_task_index, index) do
    cond do
      current_task_index == index ->
        "active-task"

      current_task_index > index ->
        "finished-task"

      true ->
        ""
    end
  end
end
