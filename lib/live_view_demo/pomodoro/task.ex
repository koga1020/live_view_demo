defmodule LiveViewDemo.Pomodoro.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias LiveViewDemo.Pomodoro.Room

  schema "tasks" do
    field :name, :string
    field :sort, :integer
    belongs_to :room, Room

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :room_id, :sort])
    |> validate_required([:name, :room_id, :sort])
  end
end
