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

  describe "rooms" do
    alias LiveViewDemo.Pomodoro.Room

    @valid_attrs %{hash: "some hash"}
    @update_attrs %{hash: "some updated hash"}
    @invalid_attrs %{hash: nil}

    def room_fixture(attrs \\ %{}) do
      {:ok, room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Pomodoro.create_room()

      room
    end

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Pomodoro.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Pomodoro.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      assert {:ok, %Room{} = room} = Pomodoro.create_room(@valid_attrs)
      assert room.hash == "some hash"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pomodoro.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      assert {:ok, %Room{} = room} = Pomodoro.update_room(room, @update_attrs)
      assert room.hash == "some updated hash"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Pomodoro.update_room(room, @invalid_attrs)
      assert room == Pomodoro.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Pomodoro.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Pomodoro.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Pomodoro.change_room(room)
    end
  end
end
