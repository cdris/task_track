defmodule TaskTrack.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string, null: false
      add :description, :text
      add :time_worked, :integer, default: 0, null: false
      add :completed, :boolean, default: false, null: false
      add :assignee_id, references(:users, on_delete: :delete_all), null: false
      add :reporter_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:tasks, [:assignee_id])
    create index(:tasks, [:reporter_id])
  end
end
