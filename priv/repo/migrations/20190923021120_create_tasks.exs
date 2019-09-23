defmodule LiveViewDemo.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string
      add :pomodoro_count, :integer

      timestamps()
    end
  end
end
