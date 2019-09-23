defmodule LiveViewDemo.Pomodoro.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias LiveViewDemo.Pomodoro.Room

  schema "tasks" do
    field :name, :string
    field :pomodoro_count, :integer
    belongs_to :room, Room

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :pomodoro_count, :room_id])
    |> validate_required([:name, :pomodoro_count, :room_id])
  end
end
