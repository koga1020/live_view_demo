defmodule LiveViewDemo.Pomodoro.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias LiveViewDemo.Pomodoro.Task

  schema "rooms" do
    field :hash, :string
    has_many(:tasks, Task)

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:hash])
    |> validate_required([:hash])
  end
end
