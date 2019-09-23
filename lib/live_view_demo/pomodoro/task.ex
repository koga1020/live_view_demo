defmodule LiveViewDemo.Pomodoro.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :name, :string
    field :pomodoro_count, :integer

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :pomodoro_count])
    |> validate_required([:name, :pomodoro_count])
  end
end
