defmodule TaskTrack.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :name, :string, null: false
      add :level, :integer, null: false
      add :manager_id, references(:users, on_delete: :nilify_all)

      timestamps()
    end
    create unique_index(:users, [:email])
    create index(:users, [:manager_id])
  end
end
