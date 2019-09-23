defmodule LiveViewDemo.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :hash, :string

      timestamps()
    end
  end
end
