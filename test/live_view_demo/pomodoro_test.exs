defmodule LiveViewDemo.PomodoroTest do
  use LiveViewDemo.DataCase

  alias LiveViewDemo.Pomodoro

  describe "tasks" do
    alias LiveViewDemo.Pomodoro.Task

    @valid_attrs %{name: "some name", pomodoro_count: 42}
    @update_attrs %{name: "some updated name", pomodoro_count: 43}
    @invalid_attrs %{name: nil, pomodoro_count: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Pomodoro.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Pomodoro.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Pomodoro.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = Pomodoro.create_task(@valid_attrs)
      assert task.name == "some name"
      assert task.pomodoro_count == 42
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pomodoro.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, %Task{} = task} = Pomodoro.update_task(task, @update_attrs)
      assert task.name == "some updated name"
      assert task.pomodoro_count == 43
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Pomodoro.update_task(task, @invalid_attrs)
      assert task == Pomodoro.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Pomodoro.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Pomodoro.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Pomodoro.change_task(task)
    end
  end
end
