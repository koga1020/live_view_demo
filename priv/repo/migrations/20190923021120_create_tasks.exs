defmodule LiveViewDemo.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string
      add :room_id, :integer
      add :sort, :integer
      timestamps()
    end
  end
end
