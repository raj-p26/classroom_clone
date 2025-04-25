defmodule ClassroomClone.Repo.Migrations.CreateSubmissions do
  use Ecto.Migration

  def change do
    create table(:submissions, primary_key: false) do
      add :id, :string, primary_key: true
      add :assignment_id, references(:assignments, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :naive_datetime)
    end

    create index(:submissions, [:assignment_id])
    create index(:submissions, [:user_id])
  end
end
